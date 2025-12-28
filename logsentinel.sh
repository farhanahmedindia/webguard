#!/bin/bash
# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

set -o pipefail

CONF="/etc/logsentinel/logsentinel.conf"
CORE="/var/lib/logsentinel/core"
LOGFILE="/var/log/logsentinel/logsentinel.log"
STATS="/var/log/logsentinel/stats.log"
WHITELIST="/etc/logsentinel/ignored_ips.txt"

source "$CONF"
source "$CORE/utils.sh"

case "$1" in
  run)
    source "$CORE/detect_logs.sh"
    source "$CORE/parse_logs.sh"
    source "$CORE/scoring.sh"
    source "$CORE/action.sh"
    ;;
  status)
    echo "logsentinel ACTIVE"
    ipset list temp_ban 2>/dev/null | grep -c "^[0-9]"
    ;;
  stats)
    tail -n 20 "$STATS"
    ;;
  whitelist)
  if [[ "$EUID" -ne 0 ]]; then
    echo "This action requires root. Try: sudo logsentinel whitelist $2 $3"
    exit 1
  fi

  case "$2" in
    add)
      echo "$3" >> "$WHITELIST"
      ;;
    list)
      cat "$WHITELIST"
      ;;
    *)
      echo "Usage: logsentinel whitelist {add|list} [IP]"
      ;;
  esac
  ;;
esac
