#!/bin/sh
source /etc/profile
fieldname=$1
fieldnum=$2
root=`dirname $0`
logfile=$dst
output=$log_path/output/$fieldname_$LASTDAY
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile -param fieldnum=$fieldnum $root/common.pig
#mail -s country_$lastday -c "he.hq@joymeng.com" ismtlee@gmail.com < $output/part-r-00000

