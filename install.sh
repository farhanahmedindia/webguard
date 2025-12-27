#!/bin/bash
# Copyright 2025 Farhan Ahmed
# Licensed under the Apache License, Version 2.0
# See LICENSE file for details

set -e

echo "[+] Checking and installing dependencies..."

# -----------------------------
# Package mappings
# -----------------------------

# Debian / Ubuntu packages
APT_DEPS=(
  bash
  coreutils        # provides sort, uniq
  grep
  mawk             # provides awk
  ipset
  whois
  jq
  curl
  mailutils        # provides mail
  msmtp
)

# RHEL / CentOS / Rocky / Alma packages
DNF_DEPS=(
  bash
  coreutils        # provides sort, uniq
  grep
  gawk             # provides awk
  ipset
  whois
  jq
  curl
  mailx            # provides mail
  msmtp
)

install_deps_apt() {
  apt update
  apt install -y "${APT_DEPS[@]}"
}

install_deps_dnf() {
  dnf install -y "${DNF_DEPS[@]}"
}

install_deps_yum() {
  yum install -y "${DNF_DEPS[@]}"
}

# -----------------------------
# Detect package manager
# -----------------------------
if command -v apt >/dev/null 2>&1; then
  install_deps_apt
elif command -v dnf >/dev/null 2>&1; then
  install_deps_dnf
elif command -v yum >/dev/null 2>&1; then
  install_deps_yum
else
  echo "[!] Unsupported package manager."
  echo "Please install the following commands manually:"
  echo "  bash awk grep sort uniq ipset whois jq curl mail/msmtp"
  exit 1
fi

# -----------------------------
# Verify dependencies (command-level check)
# -----------------------------
echo "[+] Verifying installed dependencies..."

REQUIRED_CMDS=(
  bash
  awk
  grep
  sort
  uniq
  ipset
  whois
  jq
  curl
)

for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "[!] Dependency verification failed: $cmd"
    exit 1
  fi
done

# Verify mail capability
if ! command -v mail >/dev/null 2>&1 && ! command -v msmtp >/dev/null 2>&1; then
  echo "[!] Neither mail nor msmtp found"
  exit 1
fi

echo "[✓] All dependencies installed and verified"

echo "[+] Installing webguard..."

# Paths
BIN="/usr/local/bin/webguard"
ETC="/etc/webguard"
LOG="/var/log/webguard"
LIB="/var/lib/webguard"
SYSTEMD="/etc/systemd/system"

# Create directories
mkdir -p "$ETC" "$LOG" "$LIB"

# Install main CLI
install -m 755 webguard.sh "$BIN"

# Install core modules (INCLUDING utils.sh)
mkdir -p "$LIB/core"
cp core/*.sh "$LIB/core/"
chmod 755 "$LIB/core/"*.sh

# Install default config (do not overwrite existing)
if [[ ! -f "$ETC/webguard.conf" ]]; then
  cp etc/webguard.conf.example "$ETC/webguard.conf"
fi

# Create whitelist file if missing
touch "$ETC/ignored_ips.txt"
chmod 640 "$ETC/ignored_ips.txt"

# Install systemd units
cp systemd/webguard.service "$SYSTEMD/"
cp systemd/webguard.timer "$SYSTEMD/"

# Reload systemd and enable timer
systemctl daemon-reload
systemctl enable webguard.timer
systemctl start webguard.timer

echo
echo "[✓] webguard installed successfully"
echo
echo "Useful commands:"
echo "  webguard status"
echo "  webguard stats"
echo "  webguard whitelist list"
