#!/bin/sh
log_path=/logs/nginx/2013/rsyncd/
LASTDAY=`date -d '-1 day' +%Y%m%d`
src=${log_path}access_andplus_all_${LASTDAY}.log
dst=${log_path}plugin_${LASTDAY}
#grep "/androidplus/?c=null"  $src |grep operator|awk '{print $1, $2, $7}'|awk -F '&' '{print $1, $2, $3, $4, $5, $6, $10, $13, $15}'> $dst
#sed -i 's/\w*= /_ /g' $dst
#sed -i 's/\w*=//g' $dst


source ./packname.sh 
source ./operator.sh 
source ./lang.sh 
source ./android.sh 

find $log_path/output -type f -mtime +15 -exec rm {} \;
