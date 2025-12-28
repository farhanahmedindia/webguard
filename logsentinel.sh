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

# Load config and utils
source "$CONF"
source "$CORE/utils.sh"

# -------- helpers --------
require_root() {
  if [[ "$EUID" -ne 0 ]]; then
    echo "This command requires root. Try: sudo logsentinel $*"
    exit 1
  fi
}

usage() {
  cat <<EOF
Usage: logsentinel <command>

Commands:
  run                         Run detection immediately
  status                      Show status and blocked IP count
  stats                       Show recent detection stats

  whitelist add <IP>          Add IP to whitelist
  whitelist remove <IP>       Remove IP from whitelist
  whitelist list              List whitelisted IPs
  whitelist clear             Clear whitelist

  blocked list                List blocked IPs
  blocked count               Count blocked IPs
  blocked check <IP>          Check if IP is blocked
  blocked remove <IP>         Unblock IP immediately

  intel <IP>                  Show IP intelligence (whois-based)
EOF
}

# -------- main --------
case "$1" in

  run)
    require_root "$@"
    source "$CORE/detect_logs.sh"
    source "$CORE/parse_logs.sh"
    source "$CORE/scoring.sh"
    source "$CORE/action.sh"
    ;;

  intel)
  [[ -z "$2" ]] && {
    echo "Usage: logsentinel intel <IP>"
    exit 1
  }

  if [[ ! "$2" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address"
    exit 1
  fi

  source "$CORE/intel.sh"
  intel_lookup "$2"
  ;;

  status)
    echo "logsentinel ACTIVE"
    ipset list temp_ban 2>/dev/null | grep -c '^[0-9]'
    ;;

  stats)
    if [[ -r "$STATS" ]]; then
      tail -n 20 "$STATS"
    else
      echo "No stats available."
    fi
    ;;

  whitelist)
    case "$2" in
      add)
        require_root "$@"
        [[ -z "$3" ]] && { echo "IP required"; exit 1; }
        grep -qx "$3" "$WHITELIST" 2>/dev/null || echo "$3" >> "$WHITELIST"
        ;;
      remove)
        require_root "$@"
        [[ -z "$3" ]] && { echo "IP required"; exit 1; }
        sed -i "/^$3$/d" "$WHITELIST"
        ;;
      list)
        cat "$WHITELIST"
        ;;
      clear)
        require_root "$@"
        truncate -s 0 "$WHITELIST"
        ;;
      *)
        echo "Usage: logsentinel whitelist {add|remove|list|clear} <IP>"
        ;;
    esac
    ;;

  blocked)
    case "$2" in
      list)
        require_root "$@"
        ipset list temp_ban 2>/dev/null || echo "No blocked IPs"
        ;;
      count)
        require_root "$@"
        ipset list temp_ban 2>/dev/null | grep -c '^[0-9]'
        ;;
      check)
        require_root "$@"
        [[ -z "$3" ]] && { echo "IP required"; exit 1; }
        if ipset test temp_ban "$3" 2>/dev/null; then
          echo "BLOCKED"
        else
          echo "NOT BLOCKED"
        fi
        ;;
      remove)
        require_root "$@"
        [[ -z "$3" ]] && { echo "IP required"; exit 1; }
        ipset del temp_ban "$3" 2>/dev/null || true
        ;;
      *)
        echo "Usage: logsentinel blocked {list|count|check|remove} <IP>"
        ;;
    esac
    ;;

  help|"")
    usage
    ;;

  *)
    echo "Unknown command: $1"
    usage
    exit 1
    ;;
esac
