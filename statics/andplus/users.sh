#!/bin/sh
source /etc/profile
root=`dirname $0`
logfile=$dst
output=$log_path/output/users_$LASTDAY
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/users.pig
#mail -s country_$lastday -c "he.hq@gmail.com" ismtlee@gmail.com < $output/part-r-00000

