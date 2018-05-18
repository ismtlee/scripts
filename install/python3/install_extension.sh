#!/bin/sh
ext=("pip 1" "scrapy 1" "pymysql 1" "requests 1" "redis 1" "psycopg2 1" "pymongo 0" "googleads 0" "geoip2 0" "mobile_codes 0")
for i in "${ext[@]}"; do 
  b=($i)
  if [ ${b[1]} = 0 ]
  then
    echo "${b[0]} disabled"
  else 
    pip3 install --upgrade ${b[0]}
    echo "${b[0]} enabled"
  fi
done

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>"

for i in "${ext[@]}"; do 
  b=($i)
  if [ ${b[1]} = 1 ]
  then
    echo "${b[0]} installed."
  fi
done
