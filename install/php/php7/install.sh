#!/bin/sh
source ../../header.sh
source ./version.sh

dependencies() {
	yum -y install libxml2 libxml2-devel 
	yum -y install openssl openssl-devel
	yum -y install bzip2  bzip2-devel
	yum -y install libcurl-devel 
	yum -y install gmp-devel 
	yum -y install sqlite-devel 
	yum -y install oniguruma-devel
	yum -y install recode-devel 
	yum -y install libxslt-devel 
	yum -y install gd-devel
	yum -y install glibc-headers
	yum -y install gcc-c++
	yum -y install ncurses-devel
	yum -y install postgresql-devel 
	yum -y install autoconf 
	yum -y install make
}

download() {
	php_tgz=php-${PHP_V}.tar.gz
  #mcrypt_tgz=libmcrypt-2.5.8.tar.gz

	if [ ! -f $download/$php_tgz ];
	then
		#wget http://www.php.net/get/$php_tgz/from/us1.php.net/mirror -O $php_tgz
        wget http://cn.php.net/distributions/$php_tgz  -O $php_tgz
		tar zxvf $php_tgz
	fi

	#if [ ! -f $download/$mcrypt_tgz ];
	#then
		#wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz -O libmcrypt-2.5.8.tar.gz
	#	wget http://211.79.60.17//project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz -O libmcrypt-2.5.8.tar.gz
	#	tar zxvf libmcrypt-2.5.8.tar.gz
	#fi

}

install() {
	#cd $download/libmcrypt-2.5.8/
	#./configure;make;make install
	#cd $download/libmcrypt-2.5.8/libltdl
	#./configure --enable-ltdl-install
	#make;make install
	yum -y install libicu libicu-devel

	cd $download/php-${PHP_V}

  #./configure  --prefix=${prefix}/php$suffix --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-libxml-dir --with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --with-gettext --enable-mbstring --with-mcrypt --with-mysql=/opt/mysql --with-pdo-mysql=/opt/mysql/bin/mysql_config --with-mysqli=/opt/mysql/bin/mysql_config --enable-zip --with-bz2 --enable-soap --with-pear --with-pcre-dir --with-openssl --with-config-file-path=/usr/local/etc --enable-shmop --enable-intl
 ./configure --prefix=${prefix}/php$suffix --disable-debug --disable-phpdbg --enable-mysqlnd --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif --enable-fpm --with-freetype-dir --enable-ftp --with-gd --enable-gd-jis-conv --enable-gd-native-ttf --with-gettext --with-gmp --with-iconv --enable-intl --with-jpeg-dir --enable-mbstring --with-mcrypt --with-openssl --enable-pcntl --with-pdo-mysql=mysqlnd --with-pdo-pgsql --with-png-dir --with-recode --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --with-xmlrpc --with-xsl --with-zlib --enable-zip --with-mysqli --with-config-file-path=/usr/local/etc

  make;make install
}

usergroup() {
	groupadd www
	useradd -g www www
}

config() {
  cp $root/php.ini /usr/local/etc/
  cp $root/php-fpm.conf $prefix/php${suffix}/etc/
  cp $root/www.conf $prefix/php${suffix}/etc/php-fpm.d/
  mkdir -p /logs/php
  chown -R www:www /logs

  ln -s $prefix/php${suffix}/bin/php /usr/local/bin/php$suffix
  ln -s $prefix/php${suffix}/bin/phpize /usr/local/bin/phpize$suffix

  if [ ! -d $sysctl_dir ];
  then
    cp $root/php-fpm /etc/init.d/
	chmod +x /etc/init.d/php-fpm
	/etc/init.d/php-fpm restart
    chkconfig php-fpm on
  else #centos 7
    cp $root/php-fpm.service $sysctl_dir
    sed -i ''s/php71/"php$suffix"/'' $sysctl_dir/php-fpm.conf 
    systemctl daemon-reload 
    systemctl restart php-fpm 
    systemctl enable php-fpm
  fi

}

reload() {
	/etc/init.d/php-fpm reload
}


main $1
