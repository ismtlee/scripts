#!/bin/sh
source /etc/profile
root=`dirname $0`
lastday=`date -d yesterday +%Y%m%d`
logfile=/usr/deploy/jmmq/logs/pluginlog_$lastday_*  
output=$root/output/detail_$lastday
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/detail.pig 
