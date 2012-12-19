#!/bin/sh
source /etc/profile
root=`dirname $0`
lastday=`date -d yesterday +%Y%m%d`
logfile=/usr/deploy/jmmq/logs/pluginlog_${lastday}_*  
output=$root/output/detail_$lastday
rm -rf $output
pig -x local -param out_dir=$output -param logfile=$logfile $root/detail.pig 

#add report header
sed -i '1i'图片\t状态(1)\t强弹(imei)\t强弹(ip)\t状态(2)\t点击(imei)\t点击(ip)\t点击/强弹(imei)\t点击/强弹(ip)'' $output/part-r-00000

mail -s report_$lastday -c "he.hq@joymeng.com" ismtlee@gmail.com < $output/part-r-00000

find $root/output -type f -mtime +6 -exec rm {} \;
