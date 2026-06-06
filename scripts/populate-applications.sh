#!/usr/bin/env bash
#
# populate-applications.sh
# -------------------------------------------------------------------
# Iteratively populate AMD Machines application pages, ONE per fresh
# Claude Code agent, so quality never degrades across pages.
#
# Each page gets its own isolated `claude` process (fresh context).
# After every page the script runs a hard validation gate + a full
# site build before committing. It STOPS on the first failure so you
# never waste tokens on a broken run.
#
# Usage:
#   scripts/populate-applications.sh --status        # show progress, do nothing
#   scripts/populate-applications.sh --dry-run       # show what it WOULD do
#   scripts/populate-applications.sh                 # process next MAX_PAGES (default 3)
#   scripts/populate-applications.sh --limit 1 --yes # process exactly 1, no prompt
#   scripts/populate-applications.sh --page automated-leak-test-stations
#
# Stopping safely (nothing breaks, ever):
#   touch STOP    -> finishes the current page (incl. validation + commit), then exits.
#   Ctrl-C        -> stops NOW; the in-flight page is auto-restored to its last
#                    committed state. Completed pages are already committed.
#                    Re-running resumes exactly where it left off.
#   kill -9/crash -> next run detects the leftover edits and SKIPS that page;
#                    discard them with --reset-dirty (or git checkout the file).
#
# Live progress: each agent's steps stream to your terminal as they happen
# (tool calls, elapsed time, final cost). Set STREAM=0 for the old quiet mode.
#
# Tunable safeguards (env vars):
#   MAX_PAGES=3 MAX_TURNS=60 TIMEOUT_SECS=1800 MODEL= PERMISSION_MODE=acceptEdits
#   MIN_WORDS=550 MAX_WORDS=1600 MIN_INTERNAL_LINKS=5 MIN_FAQ=4
#   MIN_FIGURES=2 MIN_TABLES=1 MIN_GLANCE=5
#   HALT_ON_FAIL=1 REVERT_ON_FAIL=0 COMMIT=1 STREAM=1 CLAUDE_EXTRA_ARGS=
# -------------------------------------------------------------------
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

APP_DIR="content/applications"
PROMPT_TEMPLATE="$SCRIPT_DIR/application-page-prompt.md"
VALIDATOR="$SCRIPT_DIR/validate_application_page.py"
LOG_DIR="$REPO_ROOT/logs"
STOP_FILE="$REPO_ROOT/STOP"

# ---- safeguards (env-overridable) ----
MAX_PAGES="${MAX_PAGES:-3}"
MAX_TURNS="${MAX_TURNS:-60}"
TIMEOUT_SECS="${TIMEOUT_SECS:-1800}"
MODEL="${MODEL:-}"
PERMISSION_MODE="${PERMISSION_MODE:-acceptEdits}"
export MIN_WORDS="${MIN_WORDS:-550}"
export MAX_WORDS="${MAX_WORDS:-1600}"
export MIN_INTERNAL_LINKS="${MIN_INTERNAL_LINKS:-5}"
export MIN_FAQ="${MIN_FAQ:-4}"
export MIN_FIGURES="${MIN_FIGURES:-2}"
export MIN_TABLES="${MIN_TABLES:-1}"
export MIN_GLANCE="${MIN_GLANCE:-5}"
HALT_ON_FAIL="${HALT_ON_FAIL:-1}"
REVERT_ON_FAIL="${REVERT_ON_FAIL:-0}"
COMMIT="${COMMIT:-1}"
STREAM="${STREAM:-1}"
CLAUDE_EXTRA_ARGS="${CLAUDE_EXTRA_ARGS:-}"

DRY_RUN=0; STATUS_ONLY=0; ASSUME_YES=0; ONLY_SLUG=""; LIMIT_OVERRIDE=""; RESET_DIRTY=0; DO_PUSH="${AUTOPUSH:-0}"

c_red()  { printf '\033[31m%s\033[0m\n' "$*"; }
c_grn()  { printf '\033[32m%s\033[0m\n' "$*"; }
c_ylw()  { printf '\033[33m%s\033[0m\n' "$*"; }
c_bld()  { printf '\033[1m%s\033[0m\n' "$*"; }

usage() { sed -n '2,48p' "$0"; exit 0; }

while [ $# -gt 0 ]; do
  case "$1" in
    --status) STATUS_ONLY=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) ASSUME_YES=1 ;;
    --no-commit) COMMIT=0 ;;
    --reset-dirty) RESET_DIRTY=1 ;;
    --push) DO_PUSH=1 ;;
    --limit) LIMIT_OVERRIDE="${2:-}"; shift ;;
    --page) ONLY_SLUG="${2:-}"; shift ;;
    -h|--help) usage ;;
    *) c_red "Unknown arg: $1"; exit 2 ;;
  esac
  shift
done
[ -n "$LIMIT_OVERRIDE" ] && MAX_PAGES="$LIMIT_OVERRIDE"

# ---- preflight ----
preflight() {
  local ok=1
  command -v claude >/dev/null 2>&1 || c_ylw "Note: 'claude' CLI not found — needed for a real run (ok for --status/--dry-run). Install Claude Code: https://docs.claude.com"
  command -v python3 >/dev/null 2>&1 || { c_red "Missing python3"; ok=0; }
  command -v git >/dev/null 2>&1 || { c_red "Missing git"; ok=0; }
  [ -f "$PROMPT_TEMPLATE" ] || { c_red "Missing prompt template: $PROMPT_TEMPLATE"; ok=0; }
  [ -f "$VALIDATOR" ] || { c_red "Missing validator: $VALIDATOR"; ok=0; }
  [ -d "$APP_DIR" ] || { c_red "Missing $APP_DIR"; ok=0; }
  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { c_red "Not a git repo"; ok=0; }
  [ "$ok" = 1 ] || exit 2
}

# list pending slugs (status != complete OR noindex truthy), deterministic order
list_pending() {
  python3 - "$APP_DIR" <<'PY'
import sys, os, glob
try:
    import yaml
except Exception:
    print("__NOYAML__"); sys.exit(0)
d = sys.argv[1]
for f in sorted(glob.glob(os.path.join(d, "*.md"))):
    if os.path.basename(f) == "index.md":
        continue
    raw = open(f, encoding="utf-8").read()
    fm = {}
    if raw.startswith("---"):
        p = raw.split("---", 2)
        if len(p) >= 3:
            try: fm = yaml.safe_load(p[1]) or {}
            except Exception: fm = {}
    status = str(fm.get("status", "")).lower()
    noindex = fm.get("noindex")
    pending = (status != "complete") or (noindex in (True, "true", "True"))
    if pending:
        print(os.path.splitext(os.path.basename(f))[0])
PY
}

list_done() {
  python3 - "$APP_DIR" <<'PY'
import sys, os, glob, yaml
d = sys.argv[1]
for f in sorted(glob.glob(os.path.join(d, "*.md"))):
    if os.path.basename(f) == "index.md": continue
    raw = open(f, encoding="utf-8").read(); fm = {}
    if raw.startswith("---"):
        p = raw.split("---", 2)
        if len(p) >= 3:
            try: fm = yaml.safe_load(p[1]) or {}
            except Exception: fm = {}
    if str(fm.get("status","")).lower()=="complete" and fm.get("noindex") in (False,None,"false","False"):
        print(os.path.splitext(os.path.basename(f))[0])
PY
}

preflight

# ---- self-heal: if a previous run died mid-page (ANY cause: Ctrl-C, kill -9,
# crash, power loss), the journal knows which page the agent was touching.
# Restore it to the last committed state so nothing is ever left half-done. ----
INFLIGHT="$LOG_DIR/.inflight"
if [ -f "$INFLIGHT" ]; then
  prev="$(cat "$INFLIGHT" 2>/dev/null)"
  if [ -n "$prev" ] && [ -f "$prev" ] && ! git diff --quiet -- "$prev" 2>/dev/null; then
    git checkout -- "$prev" 2>/dev/null || true
    c_ylw "Recovered from an interrupted previous run: restored '$prev' to its last committed state."
  fi
  rm -f "$INFLIGHT"
fi

# ---- leftover / dirty-page safety (protects interrupted runs AND your manual edits) ----
DIRTY_FILES=()
while IFS= read -r f; do [ -n "$f" ] && DIRTY_FILES+=("$f"); done < <(git status --porcelain -- "$APP_DIR" | cut -c4-)
if [ "${#DIRTY_FILES[@]}" -gt 0 ]; then
  if [ "$RESET_DIRTY" = 1 ]; then
    c_ylw "Discarding uncommitted application-page changes (interrupted-run leftovers):"
    for f in "${DIRTY_FILES[@]:-}"; do
      [ -z "$f" ] && continue
      echo "  - $f"
      git checkout -- "$f" 2>/dev/null || rm -f "$f"
    done
    DIRTY_FILES=()
  else
    c_ylw "NOTE: uncommitted changes detected in application pages:"
    for f in "${DIRTY_FILES[@]:-}"; do [ -n "$f" ] && echo "  - $f"; done
    c_ylw "Those pages will be SKIPPED this run (protects manual edits)."
    c_ylw "Leftovers from an interrupted run? Re-run with --reset-dirty to discard them."
  fi
fi
is_dirty() {
  local p="$1" f
  for f in "${DIRTY_FILES[@]:-}"; do
    [ -n "$f" ] && [ "$f" = "$p" ] && return 0
  done
  return 1
}

# ---- safe interrupt: restore the in-flight page so nothing is ever left half-done ----
CURRENT_PAGE=""
AGENT_GROUP=""
on_interrupt() {
  echo
  c_ylw "Interrupted — shutting down safely…"
  if [ -n "${AGENT_GROUP:-}" ]; then
    pkill -TERM -P "$AGENT_GROUP" 2>/dev/null || true
    kill -TERM "$AGENT_GROUP" 2>/dev/null || true
    sleep 1
  fi
  if [ -n "$CURRENT_PAGE" ]; then
    git checkout -- "$CURRENT_PAGE" 2>/dev/null || true
    git checkout -- output 2>/dev/null || true
    rm -f "$INFLIGHT" 2>/dev/null || true
    c_ylw "  In-flight page restored to last committed state: $CURRENT_PAGE"
  fi
  c_grn "  Everything previously completed is already committed — nothing lost. Re-run to resume."
  exit 130
}
trap on_interrupt INT TERM

PENDING=()
while IFS= read -r l; do [ -n "$l" ] && PENDING+=("$l"); done < <(list_pending)
DONE=()
while IFS= read -r l; do [ -n "$l" ] && DONE+=("$l"); done < <(list_done)

if [ "${PENDING[0]:-}" = "__NOYAML__" ]; then
  c_red "python3 is missing PyYAML. Run: pip install pyyaml --break-system-packages"; exit 2
fi

c_bld "AMD application-page populator"
echo "  Completed: ${#DONE[@]}    Pending: ${#PENDING[@]}    Batch size (MAX_PAGES): $MAX_PAGES"

if [ "$STATUS_ONLY" = 1 ]; then
  echo; c_grn "DONE (${#DONE[@]}):";    printf '  - %s\n' "${DONE[@]:-(none)}"
  echo;  c_ylw "PENDING (${#PENDING[@]}):"; printf '  - %s\n' "${PENDING[@]:-(none)}"
  exit 0
fi

# Build the queue for this run
QUEUE=()
if [ -n "$ONLY_SLUG" ]; then
  [ -f "$APP_DIR/$ONLY_SLUG.md" ] || { c_red "No such page: $APP_DIR/$ONLY_SLUG.md"; exit 2; }
  if is_dirty "$APP_DIR/$ONLY_SLUG.md"; then
    c_red "$ONLY_SLUG has uncommitted changes. Commit them, run 'git checkout -- $APP_DIR/$ONLY_SLUG.md', or pass --reset-dirty."
    exit 2
  fi
  QUEUE=("$ONLY_SLUG")
else
  for s in "${PENDING[@]:-}"; do
    [ -z "$s" ] && continue
    is_dirty "$APP_DIR/$s.md" && continue
    QUEUE+=("$s")
    [ "${#QUEUE[@]}" -ge "$MAX_PAGES" ] && break
  done
fi

if [ "${#QUEUE[@]}" -eq 0 ]; then
  c_grn "Nothing to do — all application pages are complete. 🎉"; exit 0
fi

echo; c_bld "This run will process ${#QUEUE[@]} page(s):"; printf '  - %s\n' "${QUEUE[@]}"
echo "  Guards: MAX_TURNS=$MAX_TURNS  TIMEOUT=${TIMEOUT_SECS}s  HALT_ON_FAIL=$HALT_ON_FAIL  COMMIT=$COMMIT"
echo "  Quality gate: words $MIN_WORDS-$MAX_WORDS  tables>=$MIN_TABLES  figures>=$MIN_FIGURES  glance>=$MIN_GLANCE  faq>=$MIN_FAQ  links>=$MIN_INTERNAL_LINKS"

if [ "$DRY_RUN" = 1 ]; then c_ylw "[dry-run] no agents launched."; exit 0; fi

if [ "$ASSUME_YES" != 1 ]; then
  printf "Proceed? [y/N] "; read -r ans
  case "$ans" in y|Y|yes|YES) ;; *) echo "Aborted."; exit 0 ;; esac
fi

command -v claude >/dev/null 2>&1 || { c_red "Cannot start a real run: 'claude' CLI not found. Install Claude Code first."; exit 2; }

mkdir -p "$LOG_DIR"
RUN_LOG="$LOG_DIR/run-$(date +%Y%m%d-%H%M%S).log"
processed=0; succeeded=0

for slug in "${QUEUE[@]}"; do
  if [ -f "$STOP_FILE" ]; then c_ylw "STOP file present — exiting cleanly."; rm -f "$STOP_FILE"; break; fi

  page="$APP_DIR/$slug.md"
  log="$LOG_DIR/$slug.log"
  echo | tee -a "$RUN_LOG"
  c_bld "==> [$((processed+1))/${#QUEUE[@]}] $slug" | tee -a "$RUN_LOG"

  PROMPT="$(sed -e "s#{{PAGE}}#$page#g" -e "s#{{SLUG}}#$slug#g" "$PROMPT_TEMPLATE")"

  # ---- fresh, isolated agent for THIS page only ----
  cargs=(-p "$PROMPT" --max-turns "$MAX_TURNS" --permission-mode "$PERMISSION_MODE"
         --allowedTools "Read,Edit,Write,Grep,Glob,WebSearch,WebFetch,Bash")
  [ -n "$MODEL" ] && cargs+=(--model "$MODEL")
  # shellcheck disable=SC2206
  [ -n "$CLAUDE_EXTRA_ARGS" ] && cargs+=($CLAUDE_EXTRA_ARGS)

  CURRENT_PAGE="$page"
  printf '%s\n' "$page" > "$INFLIGHT"   # journal: lets the NEXT run self-heal after any hard kill
  # Run the agent in the background and `wait` on it: bash then delivers INT/TERM
  # to our trap IMMEDIATELY (Ctrl-C, kill, Activity Monitor — all stop safely).
  if [ "$STREAM" = 1 ]; then
    echo "    launching fresh agent — live progress below (full log: $log)"
    ( timeout "$TIMEOUT_SECS" claude "${cargs[@]}" --output-format stream-json --verbose 2>>"$log" \
        | tee -a "$log" \
        | python3 "$SCRIPT_DIR/stream_progress.py" ) &
  else
    echo "    launching fresh agent (quiet mode; log: $log)…"
    ( timeout "$TIMEOUT_SECS" claude "${cargs[@]}" >"$log" 2>&1 ) &
  fi
  AGENT_GROUP=$!
  wait "$AGENT_GROUP"
  rc=$?
  AGENT_GROUP=""

  if [ "$rc" -eq 124 ]; then
    c_red "    TIMED OUT after ${TIMEOUT_SECS}s." | tee -a "$RUN_LOG"
  elif [ "$rc" -ne 0 ]; then
    c_red "    agent exited with code $rc." | tee -a "$RUN_LOG"
    [ "$STREAM" = 1 ] && c_ylw "    (if the log shows an unknown --output-format/--verbose option, your claude CLI is older — re-run with STREAM=0)"
  fi

  page_ok=0
  if [ "$rc" -eq 0 ]; then
    if python3 "$VALIDATOR" "$page" | tee -a "$RUN_LOG"; then
      echo "    building site…"
      if python3 build.py >>"$log" 2>&1; then
        page_ok=1
      else
        c_red "    BUILD FAILED after editing $slug (see $log)." | tee -a "$RUN_LOG"
      fi
    fi
  fi

  processed=$((processed+1))

  if [ "$page_ok" -eq 1 ]; then
    c_grn "    PASSED quality gate + build." | tee -a "$RUN_LOG"
    if [ "$COMMIT" = 1 ]; then
      git add "$page" output _redirects >/dev/null 2>&1
      git add -A output >/dev/null 2>&1
      git commit -q -m "Populate application page: $slug" && c_grn "    committed." | tee -a "$RUN_LOG"
    fi
    succeeded=$((succeeded+1))
    CURRENT_PAGE=""
    rm -f "$INFLIGHT" 2>/dev/null
  else
    CURRENT_PAGE=""   # intentionally leaving the file for inspection — interrupt must not wipe it
    rm -f "$INFLIGHT" 2>/dev/null
    c_red "    FAILED: $slug (left for inspection; see $log)" | tee -a "$RUN_LOG"
    if [ "$REVERT_ON_FAIL" = 1 ]; then git checkout -- "$page" && c_ylw "    reverted $page"; fi
    if [ "$HALT_ON_FAIL" = 1 ]; then
      c_red "HALTING run (HALT_ON_FAIL=1). Fix the issue, then re-run to resume." | tee -a "$RUN_LOG"
      break
    fi
  fi

  c_bld "    Status: $(list_done | grep -c .) complete · $(list_pending | grep -c .) pending" | tee -a "$RUN_LOG"
done

echo | tee -a "$RUN_LOG"
c_bld "Run complete: $succeeded/$processed page(s) succeeded this run." | tee -a "$RUN_LOG"
remaining=$(( ${#PENDING[@]} - succeeded ))
echo "  Approx. pending remaining: $remaining   (run again to continue; uses fresh agents)" | tee -a "$RUN_LOG"
echo "  Tip: scripts/populate-applications.sh --status"

if [ "$DO_PUSH" = 1 ]; then
  echo "Pushing all committed work to production…"
  pushed=0
  for i in 1 2 3; do
    if git push origin main; then pushed=1; break; fi
    echo "push failed (attempt $i/3) — retrying in 30s…"; sleep 30
  done
  if [ "$pushed" = 1 ]; then c_grn "✔ Pushed to production — Cloudflare deploys in ~1–2 min."
  else c_red "✖ Push failed 3x — run 'git push origin main' manually."; fi
fi
