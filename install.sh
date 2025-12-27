#!/bin/bash
set -e

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
