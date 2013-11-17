#!/bin/sh
source /etc/profile
root=`dirname $0`
logfile=$dst
output=$log_path/output/packname_imei_$LASTDAY
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/packname_imei.pig
#mail -s country_$lastday -c "he.hq@joymeng.com" ismtlee@gmail.com < $output/part-r-00000

