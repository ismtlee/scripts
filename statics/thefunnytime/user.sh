#!/bin/bash
#Pls use bash command, not sh

DAYS=7
BASE_DATE=`date -d '-'$DAYS'day' +%Y%m%d`
TOP_DATE=`date -d '-1 day' +%Y%m%d`
LOG_PATH=/logs/thefunnytime/

iHeader() {
	info="统计日期\t新注册\t活跃"
	echo -e $info
}

iHeader $DAYS

for i in $(seq $DAYS -1 1)
do 
  REG=`date -d '-'$i'day' +%Y%m%d`
  REG_LOG=$LOG_PATH'reg_'$REG.log
  ACTIVE_LOG=$LOG_PATH'active_'$REG.log
  b=`sort -u $REG_LOG |wc -l`
  text=${b}"\t"
  c=`sort -u $ACTIVE_LOG |wc -l`
  text=$text${c}"\t"
	echo -e $text
done


