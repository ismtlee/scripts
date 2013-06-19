#!/bin/sh
DAYS=7
BASE_DATE=`date -d '-'$DAYS'day' +%Y%m%d`
TOP_DATE=`date -d '-1 day' +%Y%m%d`
LOG_PATH=/logs/thefunnytime.bak/

for i in $(seq $DAYS -1 1)

do 
  REG=`date -d '-'$i'day' +%Y%m%d`
  b=`sort -u reg_$REG.log|wc -l`
  ACTIVE=1; 
  while [ $REG -lt $BASE_DATE ] 
  do
    a=`join <(cat $LOG_PATH/reg_$REG.log|sort -u) <(cat $LOG_PATH/active_$ACTIVE.log|sort -u )|wc -l`
    $ACTIVE
  done  

done
