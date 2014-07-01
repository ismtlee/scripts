#!/bin/sh
#status 'a-5|a-4|..' added by boss is to check connections status.
#the scritp is to static how many users fail.
source /etc/profile
root=`dirname $0`
lastday=`date -d yesterday +%Y%m%d`
logfile=/usr/deploy/jmmq/logs/log2_${lastday}_* 
output=$root/output/a_5_$lastday
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/a_5.pig 

#mail -s download_$lastday he.hq@joymeng.com -- -f li.jun@joymeng.com < $output/part-r-00000
#echo "send mail..."
find $root/output -type f -mtime +6 -exec rm {} \;
