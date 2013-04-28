#!/bin/sh
games=`ls -l  /usr/deploy/statics/apps/*|awk '{print $9, $5}'`
logfile=/usr/local/nginx/logs/2013/access_`date -d yesterday +%Y%m%d`
declare -A array
declare -A result

for game in $games
do		

  if echo $game|grep -E "^[0-9]+$" > /dev/null 2>&1;  then
	array[$last_apk]=$game
  else	
	last_apk=${game##*/}
  fi
done


for key in ${!array[@]}
do
    #echo "$key -> ${array[$key]}"
   result[$key]=`grep $key $logfile |grep ${array[$key]}|awk '{print $1}'|sort -u|wc -l`
   echo "$key -> ${result[$key]}"
done

