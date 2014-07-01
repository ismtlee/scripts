YEAR=`date -d '-1 day' +%Y`
LASTDAY=`date -d '-1 day' +%Y%m%d`
grep -oE "uuid=(\w|-)*" /logs/nginx/${YEAR}/rsyncd/access_andplus_all_${LASTDAY}.log|sort -u|wc -l

