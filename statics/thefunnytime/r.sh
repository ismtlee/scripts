#!/bin/sh
DAYS=7
BASE_DATE=`date -d '-'$DAYS'day' +%Y%m%d`
TOP_DATE=`date -d '-1 day' +%Y%m%d`
LOG_PATH=/logs/thefunnytime.bak/

for i in $(seq $DAYS -1 1)
do 
  REG=`date -d '-'$i'day' +%Y%m%d`
  REG_LOGS[$i]=$LOG_PATH'reg_'$REG.log
  ACTIVE_LOGS[$i]=$LOG_PATH'active_'$REG.log
done

for ary in ${REG_LOGS[@]}
do 
	b=`sort -u $ary |wc -l`
  for ary1 in ${ACTIVE_LOGS[@]}
	do
    a=`/usr/bin/join < (/bin/cat /logs/thefunnytime.bak/reg_20130613.log|/bin/sort -u) < (/bin/cat /logs/thefunnytime.bak/active_20130614.log|/bin/sort -u )|wc -l`
	done	
done

