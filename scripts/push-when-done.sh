#!/usr/bin/env bash
#
# push-when-done.sh — babysitter for an already-running populate batch.
# Watches the claim board; when the run finishes (or halts), pushes all
# committed work to origin/main so Cloudflare deploys it. Safe to Ctrl-C.
#
# Usage (in a SECOND terminal while the batch runs):
#   scripts/push-when-done.sh
#
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

APP_DIR="content/applications"
LOCK_ROOT="locks"

pending_count() {
  python3 - "$APP_DIR" <<'PY'
import sys, os, glob, yaml
n = 0
for f in sorted(glob.glob(os.path.join(sys.argv[1], "*.md"))):
    if os.path.basename(f) == "index.md":
        continue
    raw = open(f, encoding="utf-8").read(); fm = {}
    if raw.startswith("---"):
        p = raw.split("---", 2)
        if len(p) >= 3:
            try: fm = yaml.safe_load(p[1]) or {}
            except Exception: fm = {}
    complete = str(fm.get("status", "")).lower() == "complete" and fm.get("noindex") in (False, None, "false", "False")
    if not complete:
        n += 1
print(n)
PY
}

runner_alive() { pgrep -f 'populate-parallel\.sh|populate-applications\.sh' >/dev/null 2>&1; }
locks_active() { ls "$LOCK_ROOT"/*.lock >/dev/null 2>&1; }

do_push() {
  local i
  for i in 1 2 3; do
    if git push origin main; then
      printf '\033[32m%s\033[0m\n' "✔ PUSHED to production — Cloudflare deploys in ~1–2 min."
      return 0
    fi
    echo "push failed (attempt $i/3) — retrying in 30s…"
    sleep 30
  done
  printf '\033[31m%s\033[0m\n' "✖ push failed 3x — run 'git push origin main' manually."
  return 1
}

echo "Watching the run… will push to production when it finishes. (Ctrl-C cancels the watcher only — it never touches the run.)"
dead_polls=0
while :; do
  p="$(pending_count)"
  if [ "$p" -eq 0 ] && ! locks_active; then
    echo "All application pages are complete. Pushing…"
    break
  fi
  if ! runner_alive && ! locks_active; then
    dead_polls=$((dead_polls + 1))
    if [ "$dead_polls" -ge 2 ]; then
      printf '\033[33m%s\033[0m\n' "Runner stopped with $p page(s) still pending (halt or rate limit). Pushing the completed work anyway — re-run the populator later to finish the rest."
      break
    fi
  else
    dead_polls=0
  fi
  printf '  [%s] pending: %s · runner: %s\n' "$(date +%H:%M:%S)" "$p" "$(runner_alive && echo running || echo idle)"
  sleep 60
done

do_push
