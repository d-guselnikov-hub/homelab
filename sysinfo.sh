#!/bin/bash
source /home/denis/scripts/.env
echo "Сервер: $(hostname)"
date
uptime
df -h /
DISK_USED=$(df --output=pcent / | tail -n 1 | tr -d ' %')
echo "Диск занят: $DISK_USED%"
LIMIT=80
if [ "$DISK_USED" -gt "$LIMIT" ]; then
	echo "ВНИМАНИЕ: диск занят на $DISK_USED%"
	curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="ВНИМАНИЕ! Сервер $(hostname). Диск занят: $DISK_USED%." > /dev/null
else
	echo "Диск в норме"
fi

echo $(date '+%F %T') "диск" $DISK_USED% >> ~/scripts/disk.log
