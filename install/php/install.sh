#!/bin/sh
source ../header.sh
version=5.4.5

dependencies() {
	yum -y install libxml2 libxml2-devel
	yum -y install openssl openssl-devel
	yum -y install bzip2  bzip2-devel
	yum -y install libcurl-devel 
	yum -y install gd-devel
	yum -y install glibc-headers
	yum -y install gcc-c++
	yum -y install ncurses-devel
	yum -y install make
}

#download source archive.
download() {
	php_tgz=php-$version.tar.gz
  mcrypt_tgz=libmcrypt-2.5.8.tar.gz

	if [ ! -f $download/$php_tgz ];
	then
		wget http://cn2.php.net/get/$php_tgz/from/this/mirror
		tar zxvf $php_tgz
	fi

	if [ ! -f $download/$mcrypt_tgz ];
	then
		wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
		tar zxvf libmcrypt-2.5.8.tar.gz
	fi

}

install() {
	cd $download/libmcrypt-2.5.8/
	./configure;make;make install
	cd $download/libmcrypt-2.5.8/libltdl
	./configure --enable-ltdl-install
	make;make install
	yum -y install libicu libicu-devel

	cd $download/php-$version

  ./configure  --prefix=${prefix}/php54 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-libxml-dir --with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --with-gettext --enable-mbstring --with-mcrypt --with-mysql=/opt/mysql --with-pdo-mysql=/opt/mysql/bin/mysql_config --with-mysqli=/opt/mysql/bin/mysql_config --enable-zip --with-bz2 --enable-soap --with-pear --with-pcre-dir --with-openssl --with-config-file-path=/usr/local/etc --enable-shmop --enable-intl
  make;make install

	cp $root/php.ini /usr/local/etc/
	cp $root/php-fpm /etc/init.d/
	cp $root/php-fpm.conf $prefix/php54/etc/
	chmod +x /etc/init.d/php-fpm

	mkdir -p /logs/php
  chown -R www:www /logs
	/etc/init.d/php-fpm restart
}

usergroup() {
	groupadd www
	useradd -g www www
}

#create user&group
#adduser2group() {
#	GROUP=`cat /etc/group|grep $1`
#	if [ -z $GROUP ] 
#	then
		#groupadd $1
#	fi
		
#	USER=`cat /etc/passwd|grep $2`
#	if [ -z $USER ] 
#	then
		#useradd -g $1 $2
#	fi

#}

create_link() {
	ln -s $prefix/php54/bin/php /usr/local/bin/php54
	ln -s $prefix/php54/bin/phpize /usr/local/bin/phpize54
}

main
