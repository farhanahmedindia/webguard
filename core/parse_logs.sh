# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

NOW=$(date +"%d/%b/%Y:%H:%M")
TMP="/tmp/webguard_hits.tmp"
> "$TMP"

for f in "$LOG_DIR"/*access.log; do
  awk -v t="$NOW" '$4 ~ t {print $1}' "$f"
done | sort | uniq -c > "$TMP"
