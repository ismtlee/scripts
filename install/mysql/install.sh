#!/bin/sh
source ../header.sh
version=5.5.48

dependencies() {
	yum -y install openssl openssl-devel
	yum -y install glibc-headers
	yum -y install gcc-c++
  yum -y install ncurses-devel
	yum -y install make
	yum -y install cmake
}

download() {
	mysql_tgz=mysql-${version}.tar.gz
	if [ ! -f $download/$mysql_tgz ];
	then
  	wget http://cdn.mysql.com/Downloads/MySQL-5.5/${mysql_tgz} -P $download
		tar zxvf $mysql_tgz
	fi
}

install() {
	cd $download/mysql-$version
	mysql_installed=`rpm -qa|grep mysql`
	if [ -n $mysql_installed ]  
	then
		echo "old mysql exists, deleted..."
		rpm -e $mysql_installed --nodeps
	fi
    #centos 7默认mariadb
    mysql_installed=`rpm -qa|grep mariadb`
	if [ -n $mysql_installed ]  
	then
		echo "mariadb exists, deleted..."
		rpm -e $mysql_installed --nodeps
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
		-DWITHOUT_PARTITION_STORAGE_ENGINE=1 #5.6版本此行删除
	make;make install
}

usergroup() {
	groupadd mysql 
  useradd -g mysql mysql 
}

config() {
  #initialize
  #cp /opt/mysql/support-files/my-medium.cnf /opt/mysql/etc/my.cnf
  cp $root/my.cnf /opt/mysql/etc/my.cnf
  chmod 755 scripts/mysql_install_db
  scripts/mysql_install_db --user=mysql --basedir=/opt/mysql/ --datadir=/opt/mysql/data/

  cp /opt/mysql/support-files/mysql.server /etc/init.d/mysql
  chmod +x /etc/init.d/mysql

  /etc/init.d/mysql restart

  /opt/mysql/bin/mysqladmin -u root password spvfLy
  /opt/mysql/bin/mysql -uroot -pspvfLy -e 'use mysql;delete from user where password="";flush privileges;'
	ln -s /opt/mysql/bin/mysql /usr/local/bin/mysql
}

reload() {
  /etc/init.d/mysql restart 
}				


main $1
