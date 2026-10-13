#!/bin/bash
echo "Сервер: $(hostname)"
date
uptime
df -h /
DISK_USED=$(df --output=pcent / | tail -n 1 | tr -d ' %')
echo "Диск занят: $DISK_USED%"
LIMIT=80
if [ "$DISK_USED" -gt "$LIMIT" ]; then
	echo "ВНИМАНИЕ: диск занят на $DISK_USED%"
else
	echo "Диск в норме"
fi

echo $(date '+%F %T') "диск" $DISK_USED% >> ~/scripts/disk.log
