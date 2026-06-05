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
# Kill switch:  create a file named STOP in the repo root -> loop exits cleanly.
#               (or just Ctrl-C)
#
# Tunable safeguards (env vars):
#   MAX_PAGES=3 MAX_TURNS=60 TIMEOUT_SECS=1800 MIN_WORDS=800
#   MIN_INTERNAL_LINKS=5 MIN_FAQ=3 MODEL= PERMISSION_MODE=acceptEdits
#   HALT_ON_FAIL=1 REVERT_ON_FAIL=0 COMMIT=1 CLAUDE_EXTRA_ARGS=
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
export MIN_WORDS="${MIN_WORDS:-800}"
export MIN_INTERNAL_LINKS="${MIN_INTERNAL_LINKS:-5}"
export MIN_FAQ="${MIN_FAQ:-3}"
HALT_ON_FAIL="${HALT_ON_FAIL:-1}"
REVERT_ON_FAIL="${REVERT_ON_FAIL:-0}"
COMMIT="${COMMIT:-1}"
CLAUDE_EXTRA_ARGS="${CLAUDE_EXTRA_ARGS:-}"

DRY_RUN=0; STATUS_ONLY=0; ASSUME_YES=0; ONLY_SLUG=""; LIMIT_OVERRIDE=""

c_red()  { printf '\033[31m%s\033[0m\n' "$*"; }
c_grn()  { printf '\033[32m%s\033[0m\n' "$*"; }
c_ylw()  { printf '\033[33m%s\033[0m\n' "$*"; }
c_bld()  { printf '\033[1m%s\033[0m\n' "$*"; }

usage() { sed -n '2,40p' "$0"; exit 0; }

while [ $# -gt 0 ]; do
  case "$1" in
    --status) STATUS_ONLY=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --yes|-y) ASSUME_YES=1 ;;
    --no-commit) COMMIT=0 ;;
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
  QUEUE=("$ONLY_SLUG")
else
  for s in "${PENDING[@]:-}"; do
    [ -z "$s" ] && continue
    QUEUE+=("$s")
    [ "${#QUEUE[@]}" -ge "$MAX_PAGES" ] && break
  done
fi

if [ "${#QUEUE[@]}" -eq 0 ]; then
  c_grn "Nothing to do — all application pages are complete. 🎉"; exit 0
fi

echo; c_bld "This run will process ${#QUEUE[@]} page(s):"; printf '  - %s\n' "${QUEUE[@]}"
echo "  Guards: MAX_TURNS=$MAX_TURNS  TIMEOUT=${TIMEOUT_SECS}s  HALT_ON_FAIL=$HALT_ON_FAIL  COMMIT=$COMMIT"
echo "  Min quality: words>=$MIN_WORDS  internal_links>=$MIN_INTERNAL_LINKS  faq>=$MIN_FAQ"

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
         --allowedTools "Read,Edit,Write,Grep,Glob,WebSearch,WebFetch,Bash(python3 build.py)")
  [ -n "$MODEL" ] && cargs+=(--model "$MODEL")
  # shellcheck disable=SC2206
  [ -n "$CLAUDE_EXTRA_ARGS" ] && cargs+=($CLAUDE_EXTRA_ARGS)

  echo "    launching agent (log: $log)…"
  timeout "$TIMEOUT_SECS" claude "${cargs[@]}" >"$log" 2>&1
  rc=$?

  if [ "$rc" -eq 124 ]; then
    c_red "    TIMED OUT after ${TIMEOUT_SECS}s." | tee -a "$RUN_LOG"
  elif [ "$rc" -ne 0 ]; then
    c_red "    agent exited with code $rc." | tee -a "$RUN_LOG"
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
  else
    c_red "    FAILED: $slug (left for inspection; see $log)" | tee -a "$RUN_LOG"
    if [ "$REVERT_ON_FAIL" = 1 ]; then git checkout -- "$page" && c_ylw "    reverted $page"; fi
    if [ "$HALT_ON_FAIL" = 1 ]; then
      c_red "HALTING run (HALT_ON_FAIL=1). Fix the issue, then re-run to resume." | tee -a "$RUN_LOG"
      break
    fi
  fi
done

echo | tee -a "$RUN_LOG"
c_bld "Run complete: $succeeded/$processed page(s) succeeded this run." | tee -a "$RUN_LOG"
remaining=$(( ${#PENDING[@]} - succeeded ))
echo "  Approx. pending remaining: $remaining   (run again to continue; uses fresh agents)" | tee -a "$RUN_LOG"
echo "  Tip: scripts/populate-applications.sh --status"
