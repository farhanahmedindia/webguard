# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

ipset create temp_ban hash:ip timeout $BAN_TIME -exist

BLOCKED=0
SEEN=0

for IP in "${!SCORE[@]}"; do
  ((SEEN++))
  if (( SCORE[$IP] >= 40 )); then
    ipset add temp_ban "$IP" timeout "$BAN_TIME"
    log "BLOCK $IP score=${SCORE[$IP]}"
    ((BLOCKED++))
  fi
done

echo "$(date) seen=$SEEN blocked=$BLOCKED" >> "$STATS"

# ----------------------------
# Stats logging
# ----------------------------

NOW=$(date '+%Y-%m-%d %H:%M:%S')

SEEN_IPS=$(awk '{print $1}' "$TMP_HITS" | sort -u | wc -l)
BLOCKED_IPS=$(ipset list temp_ban 2>/dev/null | grep -c '^[0-9]' || echo 0)

echo "$NOW seen=$SEEN_IPS blocked=$BLOCKED_IPS" >> "$STATS"
