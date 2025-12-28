#!/bin/bash
set -e

echo "[*] Uninstalling logsentinel..."

# Stop and disable systemd units
systemctl stop logsentinel.timer 2>/dev/null || true
systemctl disable logsentinel.timer 2>/dev/null || true
systemctl stop logsentinel.service 2>/dev/null || true

# Remove systemd files
rm -f /etc/systemd/system/logsentinel.service
rm -f /etc/systemd/system/logsentinel.timer
systemctl daemon-reload

# Remove binary
rm -f /usr/local/bin/logsentinel

# Remove config (ask before deleting logs)
rm -rf /etc/logsentinel
rm -rf /var/lib/logsentinel

echo
read -p "Do you want to remove logs (/var/log/logsentinel)? [y/N]: " yn
case "$yn" in
  y|Y )
    rm -rf /var/log/logsentinel
    echo "[+] Logs removed"
    ;;
  * )
    echo "[!] Logs preserved at /var/log/logsentinel"
    ;;
esac

# Cleanup ipset if exists
ipset destroy temp_ban 2>/dev/null || true

echo "[✓] logsentinel successfully uninstalled"
