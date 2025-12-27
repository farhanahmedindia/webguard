# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

declare -A SCORE

while read -r COUNT IP; do
  [[ $(grep -w "$IP" "$WHITELIST") ]] && continue

  S=0
  (( COUNT > THRESHOLD )) && S+=30
  (( COUNT > THRESHOLD*2 )) && S+=20

  SCORE[$IP]=$S
done < "$TMP"
