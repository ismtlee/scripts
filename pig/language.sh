#!/bin/sh
source /etc/profile
root=`dirname $0`
lastday=`date -d yesterday +%Y%m%d`
logfile=/usr/deploy/jmmq/logs/log2_${lastday}_*  
output=$root/output/language_$lastday
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/language.pig 

#mail -s ountry_$lastday -c "he.hq@joymeng.com" ismtlee@gmail.com < $output/part-r-00000
mail -s language_$lastday  he.hq@joymeng.com < $output/part-r-00000

find $root/output -type f -mtime +6 -exec rm {} \;
