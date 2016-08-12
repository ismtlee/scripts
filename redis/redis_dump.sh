#!/bin/sh
# example:
# sh redis_dump.sh MUS data 6380
PREFIX=$1
DUMP_FILE=$2
PORT=$3
keys=`redis-cli -p $PORT KEYS ${PREFIX}_*`
rm $DUMP_FILE
for k in $keys
do
  line=$k"\t"`redis-cli -p $PORT --raw dump $k|head -c-1`
  echo -e $line >> $DUMP_FILE
done
