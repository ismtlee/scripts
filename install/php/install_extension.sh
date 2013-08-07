#!/bin/sh
YAF_V=2.2.9
CMD_PHPIZE=/usr/local/cellar/php54/bin/phpize
cd ~/Downloads

case $2 in
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
    echo 'Pls specify the role, server|client'
    ;;
esac
	

yaf() {
  wget http://pecl.php.net/get/yaf-$YAF_V.tgz
	tar zxvf yaf-$YAF_V.tgz
	cd yaf-$YAF_V
	$CMD_PHPIZE 
	./configure;make;make install
}
