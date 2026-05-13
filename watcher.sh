#!/bin/bash
set -e

git config user.name "github-actions[bot]"
git config user.email "github-actions[bot]@users.noreply.github.com"
git pull origin main

last_hash=""
while true; do
  if [ -f command.txt ]; then
    current_hash=$(md5sum command.txt | cut -d' ' -f1)
    if [ "$current_hash" != "$last_hash" ]; then
      command=$(cat command.txt)
      last_hash="$current_hash"
      echo "----------------------------------------" >> output.txt
      echo "[$(date -u +'%Y-%m-%d %H:%M:%S UTC')] $ $command" >> output.txt
      eval "$command" >> output.txt 2>&1
      echo "" >> output.txt
      git add output.txt
      git commit -m "Execute: $command" || true
      git push https://soheilditf3-droid:${PAT}@github.com/soheilditf3-droid/cs.git main
    fi
  fi
  sleep 3
done
