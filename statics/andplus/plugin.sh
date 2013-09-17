#!/bin/sh
log_path=/logs/nginx/2013/rsyncd/
LASTDAY=`date -d '-1 day' +%Y%m%d`
src=${log_path}access_andplus_all_${LASTDAY}.log
dst=${log_path}plugin_${LASTDAY}
grep a=request $src |grep operator|awk '{print $1, $2, $7}'|awk -F '&' '{print $1, $2, $3, $4, $5}'> $dst
sed -i 's/\w*= /_ /g' $dst
sed -i 's/\w*=//g' $dst
