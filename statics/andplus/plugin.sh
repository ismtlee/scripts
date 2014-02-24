#!/bin/sh
YEAR=`date -d '-1 day' +%Y`
LASTDAY=`date -d '-1 day' +%Y%m%d`
log_path=/logs/nginx/${YEAR}/rsyncd/
src=${log_path}access_andplus_all_${LASTDAY}.log
dst=${log_path}plugin_${LASTDAY}
basedir=`dirname $0`
grep "/androidplus/?c=null"  $src |grep operator|awk '{print $1, $2, $7}'|awk -F '&' '{print $1, $2, $3, $4, $5, $6, $10, $13, $15}'> $dst
sed -i 's/\w*= /_ /g' $dst
sed -i 's/\w*=//g' $dst


source $basedir/packname.sh 
source $basedir/operator.sh 
source $basedir/lang.sh 
source $basedir/android.sh 
source $basedir/users.sh 

find $log_path/output -type f -mtime +15 -exec rm {} \;
