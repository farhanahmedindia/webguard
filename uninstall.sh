#!/bin/bash
set -e

echo "[*] Uninstalling webguard..."

# Stop and disable systemd units
systemctl stop webguard.timer 2>/dev/null || true
systemctl disable webguard.timer 2>/dev/null || true
systemctl stop webguard.service 2>/dev/null || true

# Remove systemd files
rm -f /etc/systemd/system/webguard.service
rm -f /etc/systemd/system/webguard.timer
systemctl daemon-reload

# Remove binary
rm -f /usr/local/bin/webguard

# Remove config (ask before deleting logs)
rm -rf /etc/webguard
rm -rf /var/lib/webguard

echo
read -p "Do you want to remove logs (/var/log/webguard)? [y/N]: " yn
case "$yn" in
  y|Y )
    rm -rf /var/log/webguard
    echo "[+] Logs removed"
    ;;
  * )
    echo "[!] Logs preserved at /var/log/webguard"
    ;;
esac

# Cleanup ipset if exists
ipset destroy temp_ban 2>/dev/null || true

echo "[✓] webguard successfully uninstalled"
