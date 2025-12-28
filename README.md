# LogSentinel
LogSentinel is a lightweight, offline-first web traffic sentinel that detects abusive request patterns from access logs and temporarily blocks offending IPs using ipset.

It is designed to be simple, transparent, reversible, and low-resource, without requiring external APIs or complex configuration.

## What LogSentinel Is

LogSentinel is a:

- Log-based traffic anomaly detector

- Burst / flood detector (per-IP)

- Temporary IP blocker using ipset

- Periodic (timer-based) security tool

- Offline-first (no external services required)

It works by reading access logs, counting requests per IP within a sliding time window, and blocking IPs that exceed a configurable threshold.

## What LogSentinel Is NOT

LogSentinel is not:

- A Web Application Firewall (WAF)

- A packet-level firewall

- A real-time request interceptor

- A replacement for IDS/IPS systems

- A permanent IP banning system

- A log shipper or SIEM

It does not inspect payloads, URLs, headers, or attack signatures.


## Supported Log Sources

LogSentinel supports Apache/Nginx-style access logs where:

- Client IP is the first field

- Timestamp is enclosed in square brackets [ ]

### Supported (out of the box)

- Apache access logs

- Nginx access logs

- Custom app access logs (same format)

### Not supported (currently)

- JSON logs

- Structured logs (ELK format)

- Logs without timestamps

- Logs without IP as first field


## How It Works (High Level)

1. Runs every minute via systemd timer

2. Reads configured access logs
 
3. Extracts client IPs from recent requests

4. Counts requests per IP in a sliding time window

5. Scores IPs against a threshold

6. Temporarily blocks abusive IPs using ipset

7. Automatically unblocks IPs after timeout

8. Writes simple stats for auditing

No daemon runs continuously.
No state is permanently stored.

====
# Directory Layout:
<img width="412" height="164" alt="image" src="https://github.com/user-attachments/assets/5b854342-c1a1-4171-bb49-b4f38a3d364d" />

# Configuration
Edit:
```/etc/logsentinel/logsentinel.conf```
<img width="404" height="138" alt="image" src="https://github.com/user-attachments/assets/ba135600-d580-4c6b-926f-9ddf31391ae0" />

### Custom log paths (Nginx, custom apps)
``` LOG_PATHS="/var/log/nginx/access.log" ```

### Multiple Logs:
```LOG_PATHS="/var/log/nginx/*.log /srv/apps/*/access.log"```
LOG_PATHS="/var/log/nginx/*.log /srv/apps/*/access.log"

# How to Install

## Dependencies

logsentinel installs and requires the following system packages:

- bash
- awk, grep, sort, uniq
- systemd
- ipset
- whois
- jq
- curl
- msmtp

### Email alerts

logsentinel uses `msmtp` for email alerts.
It does not install or manage a mail server.

Users can configure SMTP settings manually if alerts are needed.

All dependencies are installed automatically during installation.


# logsentinel

Lightweight, offline-first web traffic defender.

## Install
git clone https://github.com/farhanahmedindia/logsentinel.git

cd logsentinel

chmod +x install.sh

sudo ./install.sh

# Commands
```
Core:

logsentinel run
logsentinel status
logsentinel stats

Whitelist management:

logsentinel whitelist add <IP>
logsentinel whitelist remove <IP>
logsentinel whitelist list
logsentinel whitelist clear

Blocked IP management:

logsentinel blocked list
logsentinel blocked count
logsentinel blocked check <IP>
logsentinel blocked remove <IP>


Uninstall
sudo ./uninstall.sh

```

## Whitelist Behavior

Whitelisted IPs are never blocked

Stored in:
```
/etc/logsentinel/ignored_ips.txt
```

One IP per line

Takes effect immediately

Does not retroactively unblock already-blocked IPs

To unblock immediately:
```
sudo logsentinel blocked remove <IP>
```

## Blocking Behavior

Uses ipset (temp_ban set)

All blocks are temporary

No permanent bans

Blocks automatically expire after BAN_TIME

Reboot clears all blocks

This design minimizes lockout risk.


## IP Intelligence (Optional)

LogSentinel provides a manual IP intelligence command for investigation:

logsentinel intel <IP>

This command shows contextual information such as:
- Country
- Network / ISP
- Organization (when available)

Notes:
- This feature is informational only
- It does not affect blocking decisions
- No external APIs or keys are required



# Performance Characteristics

CPU: negligible (short awk runs)

Memory: minimal

Disk I/O: read-only logs + small stats writes

No long-running processes

Safe for small VMs and shared hosts


# Security Model

Requires root for blocking operations

Read-only operations allowed for non-root users (where permitted)

No external network calls required

No credentials required

No data exfiltration


# Known Limitations

Log format must be compatible

Not real-time (runs periodically)

No per-URL or per-path analysis

No user-agent analysis

No permanent ban feature

No JSON log parsing (yet)

# When to Use LogSentinel

LogSentinel is ideal if you want:

Simple traffic flood detection

Temporary mitigation for noisy IPs

A lightweight alternative to Fail2Ban

Transparent, auditable behavior

No dependency on cloud APIs



# When NOT to Use LogSentinel

Do not use if you need:

Full WAF protection

Payload inspection

Bot fingerprinting

Advanced behavioral analysis

Real-time blocking at request level


# License

Apache License 2.0
See LICENSE file for details


# Final Notes

LogSentinel is intentionally simple by design.

It aims to:

Reduce noise

Protect resources

Avoid complexity

Stay predictable

If you understand what it does — and what it does not do — it will serve you well.
