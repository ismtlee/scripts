#!/bin/sh
DAYS=7
BASE_DATE=`date -d '-'$DAYS'day' +%Y%m%d`
TOP_DATE=`date -d '-1 day' +%Y%m%d`
LOG_PATH=/logs/thefunnytime.bak/

for i in $(seq 1 1 $DAYS)
do 
  REG=`date -d '-'$i'day' +%Y%m%d`
  REG_LOGS[$i]=$LOG_PATH'REG_'$REG.log
  ACTIVE_LOGS[$i]=$LOG_PATH'ACTIVE_'$REG.log
done

for ary in ${REG_LOGS[@]}
do 
  for ary1 in ${ACTIVE_LOGS[@]}
	do
	  echo "a"	
	done	

	echo $ary
done

