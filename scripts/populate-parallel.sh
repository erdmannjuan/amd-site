#!/usr/bin/env bash
#
# populate-parallel.sh
# -------------------------------------------------------------------
# Run MULTIPLE fresh Claude Code agents at once — each populating a
# DIFFERENT application page — coordinated by an atomic claim board.
#
# The board (your 1/2/3 ranking):
#   1 = finished        (frontmatter status: complete + indexable)
#   2 = being worked on (page claimed via a lock in locks/)
#   3 = pending start   (stub, unclaimed)
#
# A worker may only start a page after ATOMICALLY claiming it (mkdir is
# atomic at the OS level) — i.e. every bot "changes the number" BEFORE
# working, and two bots can never grab the same page. The live board is
# printed every few seconds and exported to logs/status-board.csv
# (open that in Excel/Numbers as a read-only view).
#
# Contention safety:
#   - git commits and site builds are serialized behind a global lock
#     (build.py regenerates output/ wholly; two builds would clobber).
#   - builds retry up to 3x — another worker mid-write can transiently
#     break a build; it resolves in seconds.
#   - any failure -> STOP is created -> all workers wind down cleanly.
#
# Stopping safely: same guarantees as the serial runner.
#   touch STOP  -> workers finish their current page, then exit.
#   Ctrl-C      -> workers restore their in-flight pages + release claims.
#   kill -9     -> next run's stale-lock sweep restores + unlocks.
#
# Usage:
#   scripts/populate-parallel.sh --board            # show the board, do nothing
#   scripts/populate-parallel.sh --dry-run          # show the plan
#   scripts/populate-parallel.sh --workers 3 --yes  # run 3 bots over all pending
#   scripts/populate-parallel.sh --workers 4 --limit 8 --yes
#
# NOTE: parallel workers consume your Claude plan limits N× faster.
# 2–4 workers is the sweet spot; more mostly burns your rate limit.
# -------------------------------------------------------------------
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

APP_DIR="content/applications"
LOCK_ROOT="locks"
GLOBAL_LOCK="$LOCK_ROOT/git-build.lock"
PROMPT_TEMPLATE="$SCRIPT_DIR/application-page-prompt.md"
VALIDATOR="$SCRIPT_DIR/validate_application_page.py"
LOG_DIR="$REPO_ROOT/logs"
STOP_FILE="$REPO_ROOT/STOP"
BOARD_CSV="$LOG_DIR/status-board.csv"
QUEUE_FILE="$LOG_DIR/.parallel-queue"

WORKERS="${WORKERS:-3}"
LIMIT="${LIMIT:-0}"                 # 0 = all pending
MAX_TURNS="${MAX_TURNS:-60}"
TIMEOUT_SECS="${TIMEOUT_SECS:-1800}"
MODEL="${MODEL:-}"
PERMISSION_MODE="${PERMISSION_MODE:-acceptEdits}"
BOARD_REFRESH="${BOARD_REFRESH:-12}"
CLAUDE_EXTRA_ARGS="${CLAUDE_EXTRA_ARGS:-}"
export MIN_WORDS="${MIN_WORDS:-550}"
export MAX_WORDS="${MAX_WORDS:-1600}"
export MIN_INTERNAL_LINKS="${MIN_INTERNAL_LINKS:-5}"
export MIN_FAQ="${MIN_FAQ:-4}"
export MIN_FIGURES="${MIN_FIGURES:-2}"
export MIN_TABLES="${MIN_TABLES:-1}"
export MIN_GLANCE="${MIN_GLANCE:-5}"

DRY_RUN=0; BOARD_ONLY=0; ASSUME_YES=0; DO_PUSH="${AUTOPUSH:-0}"

c_red() { printf '\033[31m%s\033[0m\n' "$*"; }
c_grn() { printf '\033[32m%s\033[0m\n' "$*"; }
c_ylw() { printf '\033[33m%s\033[0m\n' "$*"; }
c_bld() { printf '\033[1m%s\033[0m\n' "$*"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --workers) WORKERS="${2:-3}"; shift ;;
    --limit) LIMIT="${2:-0}"; shift ;;
    --board|--status) BOARD_ONLY=1 ;;
    --dry-run) DRY_RUN=1 ;;
    --push) DO_PUSH=1 ;;
    --yes|-y) ASSUME_YES=1 ;;
    -h|--help) sed -n '2,40p' "$0"; exit 0 ;;
    *) c_red "Unknown arg: $1"; exit 2 ;;
  esac
  shift
done

# ---------- helpers ----------
is_pending() { # file -> 0 if status!=complete or noindex true
  python3 - "$1" <<'PY'
import sys, yaml
raw = open(sys.argv[1], encoding="utf-8").read()
fm = {}
if raw.startswith("---"):
    p = raw.split("---", 2)
    if len(p) >= 3:
        try: fm = yaml.safe_load(p[1]) or {}
        except Exception: fm = {}
complete = str(fm.get("status", "")).lower() == "complete" and fm.get("noindex") in (False, None, "false", "False")
sys.exit(0 if not complete else 1)
PY
}

pending_slugs() {
  local f slug
  for f in "$APP_DIR"/*.md; do
    slug="$(basename "$f" .md)"
    [ "$slug" = "index" ] && continue
    if is_pending "$f"; then echo "$slug"; fi
  done
}

is_locked() { [ -d "$LOCK_ROOT/$1.lock" ]; }

claim() { # slug wid -> 0 if claimed
  local d="$LOCK_ROOT/$1.lock"
  mkdir "$d" 2>/dev/null || return 1
  echo "$$" > "$d/pid"
  echo "W$2" > "$d/worker"
  echo "$APP_DIR/$1.md" > "$d/page"
  date '+%H:%M:%S' > "$d/at"
  return 0
}
release() { rm -rf "$LOCK_ROOT/$1.lock" 2>/dev/null; }

acquire_global() {
  local waited=0
  until mkdir "$GLOBAL_LOCK" 2>/dev/null; do
    sleep 2; waited=$((waited + 2))
    [ "$waited" -ge 300 ] && return 1
  done
  echo "$$" > "$GLOBAL_LOCK/pid"
  return 0
}
release_global() { rm -rf "$GLOBAL_LOCK" 2>/dev/null; }

stale_sweep() { # recover from kill -9 / crash: dead-pid locks -> restore page, unlock
  local d pid page
  for d in "$LOCK_ROOT"/*.lock; do
    [ -d "$d" ] || continue
    pid="$(cat "$d/pid" 2>/dev/null)"
    if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then
      page="$(cat "$d/page" 2>/dev/null)"
      if [ -n "$page" ] && [ -f "$page" ] && ! git diff --quiet -- "$page" 2>/dev/null; then
        git checkout -- "$page" 2>/dev/null || true
        c_ylw "Recovered stale claim: restored '$page' to last committed state."
      fi
      rm -rf "$d"
    fi
  done
  if [ -d "$GLOBAL_LOCK" ]; then
    pid="$(cat "$GLOBAL_LOCK/pid" 2>/dev/null)"
    if [ -z "$pid" ] || ! kill -0 "$pid" 2>/dev/null; then rm -rf "$GLOBAL_LOCK"; fi
  fi
}

board() {
  python3 - "$APP_DIR" "$LOCK_ROOT" "$BOARD_CSV" <<'PY'
import sys, os, glob, yaml, datetime
app, lockroot, csvpath = sys.argv[1:4]
rows = []
for f in sorted(glob.glob(os.path.join(app, "*.md"))):
    slug = os.path.splitext(os.path.basename(f))[0]
    if slug == "index":
        continue
    raw = open(f, encoding="utf-8").read(); fm = {}
    if raw.startswith("---"):
        p = raw.split("---", 2)
        if len(p) >= 3:
            try: fm = yaml.safe_load(p[1]) or {}
            except Exception: fm = {}
    complete = str(fm.get("status", "")).lower() == "complete" and fm.get("noindex") in (False, None, "false", "False")
    lock = os.path.join(lockroot, slug + ".lock")
    worker = ""
    if os.path.isdir(lock):
        try: worker = open(os.path.join(lock, "worker")).read().strip()
        except Exception: worker = "?"
    if complete: rank, status = 1, "finished"
    elif worker: rank, status = 2, "in progress"
    else:        rank, status = 3, "pending"
    rows.append((rank, slug, status, worker))
rows.sort()
now = datetime.datetime.now().strftime("%H:%M:%S")
c1 = sum(1 for r in rows if r[0] == 1); c2 = sum(1 for r in rows if r[0] == 2); c3 = sum(1 for r in rows if r[0] == 3)
print(f"  [{now}] BOARD — finished: {c1} · in progress: {c2} · pending: {c3}")
for rank, slug, status, worker in rows:
    if rank == 2:
        print(f"           {worker:<4} → {slug}")
os.makedirs(os.path.dirname(csvpath), exist_ok=True)
with open(csvpath, "w") as fh:
    fh.write("rank,page,status,worker,updated\n")
    for rank, slug, status, worker in rows:
        fh.write(f"{rank},{slug},{status},{worker},{now}\n")
PY
}

# ---------- worker ----------
worker_loop() {
  local wid="$1" slug page log rc page_ok try brc s
  WCUR=""; WSLUG=""
  w_trap() {
    if [ -n "${WCUR:-}" ]; then git checkout -- "$WCUR" 2>/dev/null || true; fi
    [ -n "${WSLUG:-}" ] && release "$WSLUG"
    exit 130
  }
  trap w_trap INT TERM

  while :; do
    [ -f "$STOP_FILE" ] && break
    slug=""
    while IFS= read -r s; do
      [ -z "$s" ] && continue
      is_locked "$s" && continue
      is_pending "$APP_DIR/$s.md" || continue
      if claim "$s" "$wid"; then slug="$s"; break; fi
    done < "$QUEUE_FILE"
    [ -z "$slug" ] && break

    page="$APP_DIR/$slug.md"; log="$LOG_DIR/$slug.log"
    WCUR="$page"; WSLUG="$slug"
    echo "[W$wid] ▶ $(date '+%H:%M:%S') started: $slug   (log: $log)"

    PROMPT="$(sed -e "s#{{PAGE}}#$page#g" -e "s#{{SLUG}}#$slug#g" "$PROMPT_TEMPLATE")"
    cargs=(-p "$PROMPT" --max-turns "$MAX_TURNS" --permission-mode "$PERMISSION_MODE"
           --allowedTools "Read,Edit,Write,Grep,Glob,WebSearch,WebFetch,Bash")
    [ -n "$MODEL" ] && cargs+=(--model "$MODEL")
    # shellcheck disable=SC2206
    [ -n "$CLAUDE_EXTRA_ARGS" ] && cargs+=($CLAUDE_EXTRA_ARGS)

    ( timeout "$TIMEOUT_SECS" claude "${cargs[@]}" >"$log" 2>&1 ) &
    wait $!
    rc=$?

    page_ok=0
    if [ "$rc" -eq 0 ] && python3 "$VALIDATOR" "$page" >>"$log" 2>&1; then
      if acquire_global; then
        try=1; brc=1
        while [ "$try" -le 3 ]; do
          if python3 build.py >>"$log" 2>&1; then brc=0; break; fi
          sleep 15; try=$((try + 1))
        done
        if [ "$brc" -eq 0 ]; then
          git add "$page" >/dev/null 2>&1
          git add -A output >/dev/null 2>&1
          git commit -q -m "Populate application page: $slug" && page_ok=1
        fi
        release_global
      fi
    fi

    if [ "$page_ok" -eq 1 ]; then
      echo "[W$wid] ✔ $(date '+%H:%M:%S') PASSED + committed: $slug"
    else
      echo "[W$wid] ✖ $(date '+%H:%M:%S') FAILED: $slug (rc=$rc; see $log) — halting all workers."
      touch "$STOP_FILE"
    fi
    WCUR=""; WSLUG=""
    release "$slug"
  done
  echo "[W$wid] ░ no more claimable pages — worker exiting."
}

# ---------- main ----------
command -v python3 >/dev/null 2>&1 || { c_red "Missing python3"; exit 2; }
command -v git >/dev/null 2>&1 || { c_red "Missing git"; exit 2; }
[ -f "$PROMPT_TEMPLATE" ] || { c_red "Missing $PROMPT_TEMPLATE"; exit 2; }
[ -f "$VALIDATOR" ] || { c_red "Missing $VALIDATOR"; exit 2; }
mkdir -p "$LOCK_ROOT" "$LOG_DIR"
stale_sweep

if [ "$BOARD_ONLY" = 1 ]; then board; exit 0; fi

# Build this run's queue: pending, unclaimed, not dirty (protects manual edits)
PENDING=()
while IFS= read -r l; do
  [ -z "$l" ] && continue
  if ! git diff --quiet -- "$APP_DIR/$l.md" 2>/dev/null; then
    c_ylw "Skipping $l (uncommitted changes — commit or git checkout it first)."
    continue
  fi
  PENDING+=("$l")
done < <(pending_slugs)

TOTAL="${#PENDING[@]}"
[ "$LIMIT" -gt 0 ] 2>/dev/null && [ "$TOTAL" -gt "$LIMIT" ] && TOTAL="$LIMIT"

if [ "$TOTAL" -eq 0 ]; then c_grn "Nothing to do — all application pages are complete. 🎉"; exit 0; fi
[ "$WORKERS" -gt "$TOTAL" ] && WORKERS="$TOTAL"

c_bld "AMD parallel populator — $WORKERS workers over $TOTAL page(s)"
: > "$QUEUE_FILE"
i=0
for s in "${PENDING[@]}"; do
  [ "$i" -ge "$TOTAL" ] && break
  echo "$s" >> "$QUEUE_FILE"; i=$((i + 1))
done
sed 's/^/  - /' "$QUEUE_FILE"
echo "  Guards: MAX_TURNS=$MAX_TURNS  TIMEOUT=${TIMEOUT_SECS}s per page · failure halts all workers"
echo "  Board:  refreshed every ${BOARD_REFRESH}s + exported to $BOARD_CSV"
c_ylw "  Note: $WORKERS parallel agents draw down your Claude plan limits ${WORKERS}x faster."

if [ "$DRY_RUN" = 1 ]; then c_ylw "[dry-run] no agents launched."; exit 0; fi
command -v claude >/dev/null 2>&1 || { c_red "Missing 'claude' CLI."; exit 2; }

if [ "$ASSUME_YES" != 1 ]; then
  printf "Launch %s parallel workers? [y/N] " "$WORKERS"; read -r ans
  case "$ans" in y|Y|yes|YES) ;; *) echo "Aborted."; exit 0 ;; esac
fi

WPIDS=()
for w in $(seq 1 "$WORKERS"); do
  worker_loop "$w" &
  WPIDS+=($!)
done

main_trap() {
  echo
  c_ylw "Interrupted — asking all workers to stop safely…"
  touch "$STOP_FILE"
  for p in "${WPIDS[@]:-}"; do [ -n "$p" ] && kill -TERM "$p" 2>/dev/null; done
  sleep 2
  stale_sweep
  rm -f "$STOP_FILE" "$QUEUE_FILE"
  board
  c_grn "Stopped. Completed pages are committed; in-flight pages were restored. Re-run to resume."
  exit 130
}
trap main_trap INT TERM

while :; do
  alive=0
  for p in "${WPIDS[@]}"; do kill -0 "$p" 2>/dev/null && alive=1; done
  [ "$alive" -eq 0 ] && break
  sleep "$BOARD_REFRESH"
  board
done
wait 2>/dev/null

echo
board
if [ -f "$STOP_FILE" ]; then
  c_red "Run halted (a page failed or STOP was requested). Failed page left for inspection — see its log."
  rm -f "$STOP_FILE"
fi
rm -f "$QUEUE_FILE"
c_bld "Parallel run complete."

if [ "$DO_PUSH" = 1 ]; then
  echo "Pushing all committed work to production…"
  pushed=0
  for i in 1 2 3; do
    if git push origin main; then pushed=1; break; fi
    echo "push failed (attempt $i/3) — retrying in 30s…"; sleep 30
  done
  if [ "$pushed" = 1 ]; then c_grn "✔ Pushed to production — Cloudflare deploys in ~1–2 min."
  else c_red "✖ Push failed 3x — run 'git push origin main' manually."; fi
else
  echo "Deploy with: git push origin main   (or use --push next time to do it automatically)"
fi
