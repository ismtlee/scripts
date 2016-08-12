#!/bin/sh
source ../header.sh

config() {
 if [ x$1 = "x" ];then
   echo "pls tell me port." 
   exit
 fi

 port=$1


	cp $root/redis_init /etc/init.d/redis_$port
	sed -i s/6379/$port/g /etc/init.d/redis_$port

  if [ x$2 = "xdb" ];then
    cp $root/redis_db.conf /usr/local/etc/redis/$port.conf
  else
    cp $root/redis.conf /usr/local/etc/redis/$port.conf
  fi
  sed -i s/6379/$port/g /usr/local/etc/redis/$port.conf
  chmod +x /etc/init.d/redis_$port
  #mkdir -p /opt/redis/var/$port
  mkdir -p /home/data/redis/$port
  chown -R www /logs
  /etc/init.d/redis_$port stop 
  /etc/init.d/redis_$port start
}


config $1
