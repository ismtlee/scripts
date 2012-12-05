#!/bin/sh
source /etc/profile
root=`dirname $0`
lastday=`date -d yesterday +%Y%m%d`
logfile=/usr/deploy/jmmq/logs/pluginlog_${lastday}_*  
output=$root/output/detail_$lastday
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/detail.pig 

#mail -s report_$lastday he.hq@joymeng.com -- -f li.jun@joymeng.com < $output/part-r-00000
mail -s report_$lastday he.hq@joymeng.com < $output/part-r-00000

find $root/output -type f -mtime +6 -exec rm {} \;
