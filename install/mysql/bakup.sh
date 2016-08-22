#!/bin/sh
# This script is to dump mysql all databases,
# &remove expired files which are more than 6 days regularly.
#
# @author: Smart Lee
# @gmail: ismtlee@gmail.com
# To restore the db, for example:
# gunzip < /data/bakup/mysql/all_2011_10_12_10_57_12.gz |mysql -p
# if u wanna restore one single table data from a big huge dump file, try
# gunzip < all_20160821_210001.gz |sed -n -e '/CREATE TABLE.*`rp_accounts`/,/UNLOCK TABLES/p' > 1.dump, rp_accounts's a table name.

#PATH=/usr/local/mysql/bin:/usr/bin:/bin
PATH=/opt/mysql/bin:/usr/bin:/bin
TO_DIR=/data/bakup/mysql/
#dump
mysqldump -pspvfLy --all-databases|gzip > ${TO_DIR}all_`date +%Y%m%d_%H%M%S`.gz
#mysqldump -pspvfLy lt_androidplus --ignore-table lt_androidplus.plus_reg|gzip > ${TO_DIR}lt_androidplus_`date +%Y%m%d_%H%M%S`.gz
#check&remove
find $TO_DIR -type f -mtime +6 -exec rm {} \;
