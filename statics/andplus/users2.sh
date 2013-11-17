grep -oE "uuid=(\w|-)*" /logs/nginx/2013/rsyncd/access_andplus_all_20130928.log|sort -u|wc -l

