#!/bin/bash
# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

TMP="/tmp/webguard_hits.tmp"
> "$TMP"

NOW_EPOCH=$(date +%s)
WINDOW=120   # seconds (2 minutes)

for f in "$LOG_DIR"/*access.log; do
  awk -v now="$NOW_EPOCH" -v win="$WINDOW" '
  {
    # Remove leading [
    gsub(/\[/, "", $4)

    # Split Apache timestamp
    split($4, t, ":")
    split(t[1], d, "/")

    # Month conversion
    month = "JanFebMarAprMayJunJulAugSepOctNovDec"
    mon = (index(month, d[2]) + 2) / 3

    # Convert to epoch
    ts = mktime(d[3]" "mon" "d[1]" "t[2]" "t[3]" "t[4])

    # Sliding window check
    if (now - ts <= win)
      print $1
  }
  ' "$f"
done | sort | uniq -c > "$TMP"

export TMP_HITS="$TMP"
