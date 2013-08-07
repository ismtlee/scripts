#!/bin/sh
YAF_V=2.2.9
IG_V=1.1.1
CMD_PHPIZE=/usr/local/cellar/php54/bin/phpize
CMD_PHPCONFIG=/usr/local/cellar/php54/bin/php-config
SRC_DIR=~/Downloads

yaf() {
	cd $SRC_DIR
  wget http://pecl.php.net/get/yaf-$YAF_V.tgz 
	tar zxvf yaf-$YAF_V.tgz
	cd yaf-$YAF_V
	$CMD_PHPIZE 
	./configure --with-php-config=$CMD_PHPCONFIG;make;make install
}

zmq() {
	cd $SRC_DIR
	#libzeromq
	git clone https://github.com/zeromq/zeromq2-x.git
	cd zeromq2-x
	yum install libtool -y
	./autogen.sh
	yum -y install libuuid-devel
	./configure --with-pgm;make;make install
	#php-zmq
	cd $SRC_DIR
	git clone git://github.com/mkoppanen/php-zmq.git
	cd php-zmq
	$CMD_PHPIZE
	./configure --with-php-config=$CMD_PHPCONFIG;make;make install
}

iginary() {
	cd $SRC_DIR
	wget https://github.com/igbinary/igbinary/archive/$IG_V.tar.gz 
	tar zxvf $IG_V
	cd igbinary-$IG_V
  $CMD_PHPIZE 
	./configure --with-php-config=$CMD_PHPCONFIG;make;make install
}

redis() {
	cd $SRC_DIR
	git clone git://github.com/nicolasff/phpredis.git
	cd phpredis
	$CMD_PHPIZE
	./configure --enable-redis-igbinary --with-php-config=$CMD_PHPCONFIG;make;make install
}

all() {
	yaf
	zmq
	igbinary
	redis
}

case $1 in
   yaf)
		 yaf
    ;;
   zmq)
		 zmq
    ;;
	 igbinary)
		 igbinary
		;;
	 redis)
		 redis
		 ;;
	 all)
		all
		;;
   *)
    echo 'yaf|zmq|igbinary|yaf|all'
    ;;
esac
	


