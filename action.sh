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
