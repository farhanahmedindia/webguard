# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

#!/bin/bash

shopt -s nullglob

APACHE_DIRS=("/var/log/apache2" "/var/log/httpd")
LOG_DIR=""

for d in "${APACHE_DIRS[@]}"; do
  if ls "$d"/*access.log >/dev/null 2>&1; then
    LOG_DIR="$d"
    break
  fi
done

# No logs found → clean exit (NOT a failure)
if [[ -z "$LOG_DIR" ]]; then
  exit 0
fi

export LOG_DIR
