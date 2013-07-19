#!/bin/sh
#generate logs

#dat=$(date -d y“yesterday” +%Y%m%d)
dat=`date -d '-1 day' +%Y%m%d`
src_log=access_funny_api_$dat.log
src_path=/logs/nginx/$(date -d y“yesterday” +%Y)/
dist_path=/logs/thefunnytime/$(date -d y“yesterday” +%Y)/


if [ ! -d $dist_path ];
   then
     mkdir $dist_path
fi

#new user
grep -oE "uid=0&guid=(\w|-)*" ${src_path}${src_log} |grep -oE "guid=(\w|-)*"|awk -F"=" '{print $2}'|sort -u > $dist_path/reg_$dat.log
#active user
grep -oE "uid=[0-9]*&guid=(\w|-)*" ${src_path}${src_log} |grep -oE "guid=(\w|-)*"|awk -F"=" '{print $2}'|sort -u > $dist_path/active_$dat.log
#open num
grep -oE "uid=[0-9]*&guid=(\w|-)*" ${src_path}${src_log} |wc -l > $dist_path/open_$dat.log


