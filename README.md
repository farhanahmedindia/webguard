# webguard
Lightweight, offline-first, behavior-based web traffic defender for Apache/Nginx

# Core Design Summary
systemd timer (every 1 min)
        ↓
webguard.sh (CLI entry)
        ↓
detect logs → parse → score → act → log → stats

# Repository Structure
webguard/
├── install.sh
├── uninstall.sh
├── webguard.sh
├── core/
│   ├── detect_logs.sh
│   ├── parse_logs.sh
│   ├── scoring.sh
│   ├── action.sh
│   ├── intel.sh
│   └── utils.sh
├── systemd/
│   ├── webguard.service
│   └── webguard.timer
├── etc/
│   └── webguard.conf.example
├── README.md
├── LICENSE
└── .gitignore

# How to Install
# webguard

Lightweight, offline-first web traffic defender.

## Install
curl -fsSL https://raw.githubusercontent.com/<you>/webguard/main/install.sh | sudo bash

## Status
webguard status

## Stats
webguard stats

## Whitelist
webguard whitelist add 1.2.3.4
webguard whitelist list

## Uninstall
sudo ./uninstall.sh
