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
<img width="590" height="572" alt="image" src="https://github.com/user-attachments/assets/d46e9468-975c-413e-8f32-2ce73211d873" />



## Project Structure

- The GitHub repository contains source files and installer scripts.
- After installation, webguard follows standard Linux filesystem layout.
- Users do not need to interact with source files after installation.

See the "Runtime Layout" section for installed paths.

# How to Install
# webguard

Lightweight, offline-first web traffic defender.

## Install
git clone https://github.com/farhanahmedindia/webguard.git
cd webguard
chmod +x install.sh
sudo ./install.sh

## Status
webguard status

## Stats
webguard stats

## Whitelist
webguard whitelist add 1.2.3.4
webguard whitelist list

## Uninstall
sudo ./uninstall.sh
