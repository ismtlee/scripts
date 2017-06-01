#!/bin/bash
#cron -e  
#00 00 * * * /bin/bash  /usr/local/nginx/sbin/NginxLogCut.sh

logs_path=/logs/nginx/
LASTYEAR=`date -d '-1 day' +%Y`
LASTDAY=`date -d '-1 day' +%Y%m%d`
save_path=${logs_path}$LASTYEAR/


mkdir -p ${save_path}


mv ${logs_path}error.log ${save_path}/error_$LASTDAY.log
mv ${logs_path}access.log ${save_path}/access_$LASTDAY.log

#/etc/init.d/nginx reload
systemctl reload nginx

#remove 
find ${save_path} -type f -mtime +6 -exec rm {} \;
