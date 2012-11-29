#!/bin/sh
source ../header.sh
version=2.6.6

dependencies() {
  echo no dependencies...
}

download() {
  redis_tgz=redis-$version.tar.gz

	if [ ! -f $download/$redis_tgz ];
	then
		wget http://redis.googlecode.com/files/$redis_tgz
		tar zxvf $redis_tgz -C $prefix
	fi
}

install() {
	cd $prefix/redis-$version
	make;make install
}

usergroup() {
  echo no user group...	
}

config() {
	cp $root/redis_6379 /etc/init.d/
  mkdir -p /usr/local/etc/redis 
  cp $root/6379.conf /usr/local/etc/redis/ 
  chmod +x /etc/init.d/redis_6379
  mkdir -p /logs/redis
  mkdir -p /opt/redis/var/6379 
  chown -R www /logs
  /etc/init.d/redis_6379 stop 
  /etc/init.d/redis_6379 start
}

reload() {
	#warning: data would be disappear!
  /etc/init.d/redis_6379 stop 
  /etc/init.d/redis_6379 start
}

main $1
