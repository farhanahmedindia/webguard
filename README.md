# webguard
Lightweight, offline-first, behavior-based web traffic defender for Apache/Nginx

# Core Design Summary
systemd timer (every 1 min)
        ↓
webguard.sh (CLI entry)
        ↓
detect logs → parse → score → act → log → stats

# Repository Structure
<img width="601" height="549" alt="image" src="https://github.com/user-attachments/assets/2840039b-7bca-455b-b63f-2953eef1b7bb" />




# Runtime locations (after installation)
<img width="491" height="320" alt="image" src="https://github.com/user-attachments/assets/7511ab51-e384-490b-b330-7d160d2edff8" />



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
