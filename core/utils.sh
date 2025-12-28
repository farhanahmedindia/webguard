#!/bin/bash

LOG_FILE="/var/log/logsentinel/logsentinel.log"

# Timestamp helper
timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Logger
log() {
  local msg="$1"
  echo "$(timestamp) $msg" >> "$LOG_FILE"
}

# Safe command check
require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "[!] Required command '$1' not found"
    exit 1
  }
}

# Check if IP is private/bogon
is_private_ip() {
  local ip="$1"
  [[ "$ip" =~ ^10\. ]] && return 0
  [[ "$ip" =~ ^192\.168\. ]] && return 0
  [[ "$ip" =~ ^172\.(1[6-9]|2[0-9]|3[0-1])\. ]] && return 0
  [[ "$ip" =~ ^127\. ]] && return 0
  return 1
}

# Check whitelist
is_whitelisted() {
  local ip="$1"
  grep -qx "$ip" /etc/logsentinel/ignored_ips.txt 2>/dev/null
}

# Minimal IP validation
valid_ip() {
  local ip="$1"
  [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]
}
