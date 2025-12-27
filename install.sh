#!/bin/bash
set -e

echo "[+] Installing webguard..."

# Paths
BIN="/usr/local/bin/webguard"
ETC="/etc/webguard"
LOG="/var/log/webguard"
LIB="/var/lib/webguard"

mkdir -p $ETC $LOG $LIB

cp webguard.sh $BIN
chmod +x $BIN

cp etc/webguard.conf.example $ETC/webguard.conf
touch $ETC/ignored_ips.txt

cp -r core $LIB/

cp systemd/webguard.service /etc/systemd/system/
cp systemd/webguard.timer /etc/systemd/system/

systemctl daemon-reload
systemctl enable webguard.timer
systemctl start webguard.timer

echo "[✓] webguard installed"
echo "Run: webguard status"
