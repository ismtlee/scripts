#!/bin/sh
root=$PWD
download=~/Downloads
prefix=/usr/local/cellar

main() {
	dependencies
	if [ ! -d $download ];
	then
		mkdir $download 
	fi
	cd $download

	download
	adduser2group www www
	adduser2group mysql mysql
	echo "Begin install mysql..............................................................................."
#	install_mysql
	echo "Begin install nginx..............................................................................."
	install_nginx
	echo "Begin install php..............................................................................."
#	install_php
}

dependencies() {
	yum -y install libxml2 libxml2-devel
	yum -y install openssl openssl-devel
	yum -y install bzip2  bzip2-devel
	yum -y install libcurl-devel 
	yum -y install gd-devel
	yum -y install glibc-headers
	yum -y install gcc-c++
	yum -y install ncurses-devel
}

#download source archive.
download() {
	mysql_tgz=mysql-5.5.25.tar.gz
	php_tgz=php-5.4.4.tar.gz
  nginx_tgz=nginx-1.2.1.tar.gz
  mcrypt_tgz=libmcrypt-2.5.8.tar.gz

	if [ ! -f $download/$mysql_tgz ];
	then
  	wget http://dev.mysql.com/get/Downloads/MySQL-5.5/mysql-5.5.25.tar.gz/from/http://cdn.mysql.com/ -P $download
		tar zxvf mysql-5.5.25.tar.gz
	fi

	if [ ! -f $download/$php_tgz ];
	then
		wget http://cn2.php.net/get/php-5.4.4.tar.gz/from/this/mirror
		tar zxvf php-5.4.4.tar.gz
	fi

	if [ ! -f $download/$nginx_tgz ];
	then
		wget http://nginx.org/download/nginx-1.2.1.tar.gz 
		tar zxvf nginx-1.2.1.tar.gz
	fi

	if [ ! -f $download/$mcrypt_tgz ];
	then
		wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz
		tar zxvf libmcrypt-2.5.8.tar.gz
	fi

}

install_mysql() {
	cd $download/mysql-5.5.25
	mysql_installed=`rpm -qa|grep mysql`
	if [ -n $mysql_installed ]  
	then
		echo "old mysql exists, deleted..."
		rpm -e $mysql_installed --nodeps
	fi

  cmake_installed=`rpm -qa|grep cmake`
	if [ -z $cmake_installed ] 
	then
		yum -y install cmake
	else
		echo "check cmake....................yes."
	fi
	
	mkdir /opt/mysql
	mkdir /opt/mysql/data
	mkdir /opt/mysql/log
	mkdir /opt/mysql/etc
	chown -R mysql:mysql /opt/mysql/data
	cmake -DCMAKE_INSTALL_PREFIX=/opt/mysql \
		-DSYSCONFDIR=/opt/mysql/etc \
		-DMYSQL_DATADIR=/opt/mysql/data \
		-DMYSQL_TCP_PORT=3306 \
		-DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
		-DMYSQL_USER=mysql \
		-DEXTRA_CHARSETS=all \
		-DDEFAULT_CHARSET=utf8 \
		-DDEFAULT_COLLATION=utf8_general_ci \
		-DWITH_READLINE=1 \
		-DWITH_SSL=system \
		-DWITH_EMBEDDED_SERVER=1 \
		-DENABLED_LOCAL_INFILE=1 \
		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
		-DWITHOUT_PARTITION_STORAGE_ENGINE=1
	make;make install
	#initialize
  cp /opt/mysql/support-files/my-medium.cnf /opt/mysql/etc/my.cnf
	chmod 755 scripts/mysql_install_db
	scripts/mysql_install_db --user=mysql --basedir=/opt/mysql/ --datadir=/opt/mysql/data/
	
  cp /opt/mysql/support-files/mysql.server /etc/init.d/mysql
	chmod +x /etc/init.d/mysql

  /etc/init.d/mysql restart

	/opt/mysql/bin/mysqladmin -u root password spvfLy
	/opt/mysql/bin/mysql -uroot -pspvfLy -e 'use mysql;delete from user where password="";flush privileges;'
}


install_nginx() {
	cd $download/nginx-1.2.1
  yum -y install pcre pcre-devel
	./configure --prefix=${prefix}/nginx --user=www --group=www  --with-http_stub_status_module 
	make;make install
	cp $root/nginx /etc/init.d/
	cp $root/nginx.conf $prefix/nginx/conf
	cp $root/sites.conf $prefix/nginx/conf
	chmod +x /etc/init.d/nginx
	mkdir -p /logs/nginx
	chown -R www /logs
	/etc/init.d/nginx restart
}

install_php() {
	cd $download/libmcrypt-2.5.8/
	./configure;make;make install
	cd $download/libmcrypt-2.5.8/libltdl
	./configure --enable-ltdl-install
	make;make install
	yum -y install libicu libicu-devel

	cd $download/php-5.4.4

  ./configure  --prefix=${prefix}/php54 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-libxml-dir --with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --with-gettext --enable-mbstring --with-mcrypt --with-mysql=/opt/mysql --with-pdo-mysql=/opt/mysql/bin/mysql_config --with-mysqli=/opt/mysql/bin/mysql_config --enable-zip --with-bz2 --enable-soap --with-pear --with-pcre-dir --with-openssl --with-config-file-path=/usr/local/etc --enable-shmop --enable-intl
  make;make install

	cp $root/php.ini /usr/local/etc/
	cp $root/php-fpm /etc/init.d/
	cp $root/php-fpm.conf $prefix/etc/
	chmod +x /etc/init.d/php-fpm

	mkdir -p /logs/php
  chown -R www /logs
	/etc/init.d/php-fpm restart
}

#create user&group
adduser2group() {
	GROUP=`cat /etc/group|grep $1`
	if [ -z $GROUP ] 
	then
		groupadd $1
	fi
		
	USER=`cat /etc/passwd|grep $2`
	if [ -z $USER ] 
	then
		useradd -g $1 $2
	fi

}

create_link() {
	ln -s /opt/mysql/bin/mysql /usr/local/bin/mysql
	ln -s $prefix/php54/bin/php /usr/local/bin/php54
	ln -s $prefix/php54/bin/phpize /usr/local/bin/phpize54
}

main
