#!/bin/sh
serverName=`uname -n`
THRESHOLD=80
MAILER="/usr/bin/mailx"
MAIL="arun@example.com"
# totalRAM variable must be defined in MB(Megabyte). Use command prtdiag |grep "Memory size" |awk '{print $3}'` to get value in MB
totalRAM=65536 #in MB
# calculating Memory usage
freeRAMpages=`sar -r 1 10|tail -1|awk '{print $2 }'`             # in pages
freeRAM=`expr $freeRAMpages \* 8192 / 1024 / 1024 \* 100`    # enable this line if the server running on SPARC hardware
# freeRAM=`expr $freeRAMpages \* 4096 / 1024 / 1024 \* 100`  # enable this line if the server running on x86 platform
freeRAM_PERCENT=`expr $freeRAM / $totalRAM`
usedRAM_PERCENT=`expr 100 - $freeRAM_PERCENT`
messageBody="Hi Team,

This is to notify that memory usage on server $serverName has crossed the configured threshold. Please take necessary action to control the usage

Thanks,
UNIX Team "

if [ $usedRAM_PERCENT -ge $THRESHOLD ]
then
echo "$messageBody"|$MAILER -s "Total Memory usage exceeds $THRESHOLD% threshold for server $serverName. Current usage: $usedRAM_PERCENT%" $MAIL
fi
