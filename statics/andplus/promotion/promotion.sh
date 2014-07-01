#!/bin/sh
#交叉推广打开|确认下载统计
YEAR=`date -d '-1 day' +%Y`
LASTDAY=`date -d '-1 day' +%Y%m%d`
log_path=/logs/nginx/${YEAR}/
src=${log_path}access_statics_${LASTDAY}.log
dst=${log_path}promotion_${LASTDAY}
basedir=`dirname $0`
egrep "/open/?|/yes/?"  $src |awk '{print $1, $5}'|awk -F '&' '{print $1, $2, $3, $4, $5, $8}'> $dst
sed -i 's/\w*= /_ /g' $dst
sed -i 's/\w*=//g' $dst

#source $basedir/users.sh 

#find $log_path/output -type f -mtime +15 -exec rm {} \;
