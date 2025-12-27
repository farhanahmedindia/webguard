# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

APACHE_DIRS=("/var/log/apache2" "/var/log/httpd")

for d in "${APACHE_DIRS[@]}"; do
  if ls $d/*access.log &>/dev/null; then
    LOG_DIR="$d"
    break
  fi
done

[[ -z "$LOG_DIR" ]] && exit 1
