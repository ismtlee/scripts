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
#这个脚本不建议reload
#kill -USR1 = nginx -s reopen
#kill -USR2 = nginx -s reload 
#reopen 和reload行为相差很大,reopen只检查日志文件,reload会重载配置, 并启动新worker, 关闭旧worker
#日志回滚,后面统一用logrotate处理
systemctl reload nginx

#remove 
find ${save_path} -type f -mtime +6 -exec rm {} \;
