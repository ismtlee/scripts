#!/bin/sh
source ../header.sh
version=1.18

dependencies() {
  echo "no dependencies.." 
}

download() {
  tgz=vnstat-$version.tar.gz

	if [ ! -f $download/$tgz ];
	then
    wget http://humdi.net/vnstat/$tgz
		tar zxvf $tgz 
	fi
}

install() {
	cd $download/vnstat-$version
	#./configure --prefix=${prefix}/rsync 
	./configure 
	make;make install
}

usergroup() {
	echo 'no need'
}

config() {
  wget http://humdi.net/vnstat/init.d/redhat/vnstat -P /etc/init.d/
  chmod +x /etc/init.d/vnstat
  /etc/init.d/vnstat restart
  ln -s /usr/local/sbin/vnstatd /usr/sbin/vnstatd
  chkconfig vnstat on
}

reload() {
	/etc/init.d/vnstat restart
}


main $1
