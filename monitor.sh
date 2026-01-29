#!/bin/bash
cd /Users/juan_erdmann/my-site-generator
CSV="Instructions/blog_content_audit.csv"
START=$(date +%s)
INIT_PEND=$(grep -c 'Pending' "$CSV")
LAST_DEP=0

while true; do
  NOW=$(date +%s)
  ELAPSED=$((NOW-START))
  UPD=$(grep -c 'Updated 2026' "$CSV")
  UPDING=$(grep -c 'Updating' "$CSV")
  PEND=$(grep -c 'Pending' "$CSV")
  DONE=$((INIT_PEND-PEND))
  
  clear
  echo "=== MONITOR $(date '+%H:%M:%S') | ${ELAPSED}s ==="
  echo "Updated: $UPD | Updating: $UPDING | Pending: $PEND"
  echo "Done this session: $DONE"
  
  if [ $((NOW-LAST_DEP)) -ge 600 ]; then
    echo "Deploying..."
    git add -A && git commit -m "Update $DONE blogs" && git push
    LAST_DEP=$NOW
  fi
  
  if [ "$PEND" -eq 0 ]; then
    echo "DONE!"
    git add -A && git commit -m "Final" && git push
    exit 0
  fi
  
  if [ $ELAPSED -lt 60 ]; then sleep 10; else sleep 600; fi
done
