#!/bin/sh
# example:
# sh redis_dump.sh MUS data 6380
PREFIX=$1
DUMP_DIR=$2
PORT=$3
keys=`redis-cli -p $PORT KEYS ${PREFIX}_*`
#rm -rf $DUMP_DIR
mkdir -p $DUMP_DIR
for k in $keys
do
  redis-cli -p $PORT --raw dump $k|head -c-1 >> $DUMP_DIR/$k
done
tar zcvf $DUMP_DIR.tgz $DUMP_DIR
rm -rf $DUMP_DIR
