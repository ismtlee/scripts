#!/bin/bash
#Pls use bash command, not sh

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
	b_date=${ary##*_}
	b_date=${b_date:0:8}
	text=${b_date}"\t"

	for (( idx=${#ACTIVE_LOGS[@]}-1 ; idx>=0 ; idx-- )) ; do
     ary1=${ACTIVE_LOGS[idx]}
     a_date=${ary1##*_}
     a_date=${a_date:0:8}
     if [ $b_date -lt $a_date ]; then
	     a=`join <(cat $ary|sort -u) <(cat $ary1|sort -u)|wc -l`
       text=$text`echo "scale=2;$a*100/$b"|bc`%"\t"
     fi
	done

	echo -e $text
done

