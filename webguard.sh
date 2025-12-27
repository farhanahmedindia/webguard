#!/bin/bash
# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

set -e

CONF="/etc/webguard/webguard.conf"
CORE="/var/lib/webguard/core"
LOGFILE="/var/log/webguard/webguard.log"
STATS="/var/log/webguard/stats.log"
WHITELIST="/etc/webguard/ignored_ips.txt"

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
    echo "webguard ACTIVE"
    ipset list temp_ban 2>/dev/null | grep -c "^[0-9]"
    ;;
  stats)
    tail -n 20 "$STATS"
    ;;
  whitelist)
  if [[ "$EUID" -ne 0 ]]; then
    echo "This action requires root. Try: sudo webguard whitelist $2 $3"
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
      echo "Usage: webguard whitelist {add|list} [IP]"
      ;;
  esac
  ;;
esac
