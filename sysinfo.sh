#!/bin/bash
# shellcheck source=/dev/null
FULL_PATH="$(realpath "$0")"
SCRIPT_DIR="$(dirname "$FULL_PATH")"
source "$SCRIPT_DIR/.env"
DISK_LIMIT=80
MEM_LIMIT=90
SERVICES=(ssh.socket samba-ad-dc tailscaled cockpit.socket)


send_tg () {
	curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$1" > /dev/null
}

show_info () {
	echo "Сервер: $(hostname)"
	date
	uptime
	df -h /
}


check_disk () {
	DISK_USED=$(df --output=pcent / | tail -n 1 | tr -d ' %')
	echo "Диск занят: $DISK_USED%"
	if [ "$DISK_USED" -gt "$DISK_LIMIT" ]; then
		echo "ВНИМАНИЕ: диск занят на $DISK_USED%"
		send_tg "ВНИМАНИЕ: $(hostname), диск занят на $DISK_USED% (лимит $DISK_LIMIT%)"
	else
		echo "Диск в норме"
	fi
	echo "$(date '+%F %T') диск $DISK_USED%" >> "$SCRIPT_DIR/disk.log"
}

check_mem () {
	MEM_TTL=$(free -m | awk  '/Mem:/ {print $2}')
	MEM_AVL=$(free -m | awk '/Mem:/ {print $7}')
	MEM_USED=$(( ((MEM_TTL - MEM_AVL) * 100) / MEM_TTL ))
	if [ "$MEM_USED" -gt "$MEM_LIMIT" ]; then
		echo "ВНИМАНИЕ: использовано $MEM_USED% памяти"
		send_tg "ВНИМАНИЕ: $(hostname), использовано $MEM_USED% ОЗУ"
	else
		echo "$MEM_AVL ОЗУ мегабайт доступно"
	fi
	echo "$(date '+%F %T') $MEM_USED% использовано" >> "$SCRIPT_DIR/disk.log"
}

check_srvc () {
	for SERVICE in "${SERVICES[@]}"; do
		STATUS=$(systemctl is-active "$SERVICE")
		if [ "$STATUS" != active ]; then
			echo "ВНИМАНИЕ: служба $SERVICE не активна." 
			send_tg "ВНИМАНИЕ: служба $SERVICE не активна."
		else
			echo "Служба $SERVICE активна."
		fi
			echo "$(date '+%F %T') Служба $SERVICE $STATUS" >> "$SCRIPT_DIR/disk.log"
	done
}

show_info
check_disk
check_mem
check_srvc
