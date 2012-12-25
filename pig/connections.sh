#!/bin/sh
source /etc/profile
root=`dirname $0`
lastday=`date -d yesterday +%Y%m%d`
logfile=/usr/deploy/jmmq/logs/log2_${lastday}_08  
output=$root/output/connections_$lastday
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/connections.pig 

mail -s country_$lastday -c "he.hq@joymeng.com" ismtlee@gmail.com < $output/part-r-00000

find $root/output -type f -mtime +6 -exec rm {} \;
