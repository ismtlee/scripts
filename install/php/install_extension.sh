#!/bin/sh
YAF_V=2.2.9
CMD_PHPIZE=/usr/local/cellar/php54/bin/phpize
cd ~/Downloads

yaf() {
  wget http://pecl.php.net/get/yaf-$YAF_V.tgz
	tar zxvf yaf-$YAF_V.tgz
	cd yaf-$YAF_V
	$CMD_PHPIZE 
	./configure;make;make install
}

case $1 in
   yaf)
		 yaf
    ;;
   zmq)
		 zmq
    ;;
	 igbinary)
		;;
	 yaf)
		yaf
		;;
	 all)
		all
		;;
   *)
    echo 'yaf|zmq|igbinary|yaf|all'
    ;;
esac
	


