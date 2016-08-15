#!/bin/sh
# example
# sh redis_restore.sh data 6379
#filename, no extension. say data.tgz mean data.
DUMP_FILE=$1
PORT=$2
tar zxvf $DUMP_FILE.tgz
list=`ls $DUMP_FILE`
for k in $list 
do 
  cat $DUMP_FILE/$k|redis-cli -p $PORT -x restore $k 0
done

