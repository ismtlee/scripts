#!/bin/sh
source ../header.sh
port=6379
version=5.0.8

dependencies() {
	yum install gcc gcc-c++ -y
}

download() {
  redis_tgz=redis-$version.tar.gz

	if [ ! -f $download/$redis_tgz ];
	then
		wget http://download.redis.io/releases/$redis_tgz
		tar zxvf $redis_tgz -C $prefix
	fi
}

install() {
	cd $prefix/redis-$version
	make;make install
}

usergroup() {
	groupadd www
  useradd -g www www
}

config() {
	cp $root/redis_init /etc/init.d/redis_$port
	sed -i s/6379/$port/g /etc/init.d/redis_$port
  mkdir -p /usr/local/etc/redis 
  cp $root/redis.conf /usr/local/etc/redis/$port.conf
	sed -i s/6379/$port/g /usr/local/etc/redis/$port.conf
  chmod +x /etc/init.d/redis_$port
  mkdir -p /logs/redis
  #mkdir -p /opt/redis/var/$port
  mkdir -p /home/data/redis/$port
  chown -R www /logs
  /etc/init.d/redis_$port stop 
  /etc/init.d/redis_$port start
}

reload() {
	#warning: data would be disappear!
  /etc/init.d/redis_$port stop 
  /etc/init.d/redis_$port start
}

main $1
