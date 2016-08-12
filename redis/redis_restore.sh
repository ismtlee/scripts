#!/bin/sh
# example
# sh redis_restore.sh data 6379
#filename, no extension. say data.tgz mean data.
DUMP_FILE=$1 
PORT=$2
awk '{script="redis-cli -p '$PORT'  restore "$1" 0 "$2;system(script) }' $DUMP_FILE
