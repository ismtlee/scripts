#!/bin/bash
#cron -e  
#00 00 * * * /bin/bash  /usr/local/nginx/sbin/NginxLogCut.sh

logs_path=/logs/nginx/
save_path=${logs_path}$(date -d y“yesterday” +%Y)/


mkdir -p ${save_path}


mv ${logs_path}error.log ${save_path}/error_$(date -d y“yesterday” +%Y%m%d).log
mv ${logs_path}access.log ${save_path}/access_$(date -d y“yesterday” +%Y%m%d).log
mv ${logs_path}access_andplus.log ${save_path}/access_andplus_$(date -d y“yesterday” +%Y%m%d).log

/etc/init.d/nginx reload
