#!/bin/bash
# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

shopt -s nullglob

LOG_FILES=()

# User-defined log paths (highest priority)
if [[ -n "$LOG_PATHS" ]]; then
  for pattern in $LOG_PATHS; do
    for f in $pattern; do
      [[ -f "$f" ]] && LOG_FILES+=("$f")
    done
  done

  # If user provided paths but none exist → clean exit
  [[ ${#LOG_FILES[@]} -eq 0 ]] && exit 0

  export LOG_FILES
  exit 0
fi

# Auto-detect Apache logs (fallback)
APACHE_DIRS=("/var/log/apache2" "/var/log/httpd")

for d in "${APACHE_DIRS[@]}"; do
  files=("$d"/*access.log)
  if [[ ${#files[@]} -gt 0 ]]; then
    LOG_FILES=("${files[@]}")
    export LOG_FILES
    exit 0
  fi
done

# No logs found → clean exit (not a failure)
exit 0
