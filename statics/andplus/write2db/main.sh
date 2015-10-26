#!/bin/sh
HOST=192.168.10.18
USR=dev
PWD=linker.boom147
LASTDAY=`date -d '-1 day' +%Y%m%d`
basedir=`dirname $0`
SQL=$basedir/log.sql

/bin/sed -i "s/[0-9]\{8\}/$LASTDAY/g" $SQL

/usr/local/bin/mysql -h$HOST -u$USR -p$PWD < $SQL
