# Homelab

A learning home server running Ubuntu Server. This repository contains scripts for server administration, monitoring and automation.

The goal of the project is hands-on practice with Linux, bash scripting and infrastructure automation.

## Stack

- Ubuntu Server 26.04 LTS
- Bash
- cron
- Telegram Bot API
- Tailscale (remote access)

## Repository structure

- `sysinfo.sh` - server status and disk usage check
- `.env.example` - configuration template
- `.gitignore` - files excluded from the repository

## sysinfo.sh

- Prints hostname, date, uptime and root disk usage
- Checks disk usage against a threshold (`LIMIT` variable, 80% by default)
- Sends a Telegram alert when the threshold is exceeded
- Appends a timestamped record to `disk.log`
- Designed to run on a schedule via cron

## Installation

1. Clone the repository:
```bash
   git clone https://github.com/d-guselnikov-hub/homelab.git
   cd homelab
```
2. Create the config file from the template:
```bash
   cp .env.example .env
```
3. Fill in `TOKEN` and `CHAT_ID` in `.env`
4. Restrict access to the config file:
```bash
   chmod 600 .env
```
5. Make the script executable:
```bash
   chmod +x sysinfo.sh
```
6. Run it manually to test:
```bash
   ./sysinfo.sh
```
7. Schedule it with cron (`crontab -e`), for example every hour:
```
   0 * * * * /path/to/homelab/sysinfo.sh
```

## Getting a Telegram token and chat ID

- Token: message `@BotFather`, send `/newbot` and follow the instructions
- Chat ID: send any message to your bot, then run:
```bash
  curl "https://api.telegram.org/bot<TOKEN>/getUpdates"
```
  and look for `"chat":{"id": ...}` in the response

## Security

- `.env` contains secrets and is excluded from git
- `.env` permissions are restricted to the owner only (`600`)

## Roadmap

- [ ] Memory, CPU load and service health checks
- [ ] Initial server setup script (`bootstrap.sh`)
- [ ] Samba Active Directory deployment
- [ ] Monitoring with Zabbix and Grafana
- [ ] Application deployment with Docker Compose
- [ ] Migration to Ansible
