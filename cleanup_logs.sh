#!/bin/bash
HOSTNAME=$(hostname -f)
for i in aev-syslog messages ; do
USAGE=$(ls -l /var/log/$i |awk '{print $5}')
USAGEMB=$(echo "${USAGE}/1024/1024"|bc)
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/opt/local/bin
export PATH
#if [ $USAGE -gt 524288000 ]
if [ $USAGE -gt 209715200 ]
then
    printf "\narchiving /var/log/$i on server $HOSTNAME as the file grown to more than 500Mb, current usage is $USAGEMB MB"
    sudo tar -zcvf /tmp/${i}_$(date +"%Y-%m-%d").tar.gz /var/log/${i} 2&>/dev/null
    #tar -zcvf /tmp/${i}_$(date +"%Y-%m-%d").tar.gz /var/log/${i} 2&>/dev/null
    if [ -f /tmp/${i}_$(date +"%Y-%m-%d").tar.gz ]
    then
       sudo truncate -s0  /var/log/${i}
       printf "\narchiving done for $HOSTNAME \n"
    else
       printf "\narchiving failed for $HOSTNAME \n"
       exit 1
    fi
fi
done
