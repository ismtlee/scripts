#!/bin/sh
source ../header.sh
version=3.2

DB_HOST=localhost
DB_USR=root
DB_PWD=spvfLy
basedir=`dirname $0`
SQL=$basedir/init.sql

dependencies() {
}

download() {
   redmine_dir=redmine-$version

	if [ ! -d $download/$redmine_dir];
	then
        svn co https://svn.redmine.org/redmine/branches/${version}-stable $redmine_dir
	fi
}

install() {
    /usr/local/bin/mysql -h$DB_HOST -u$DB_USR -p$DB_PWD < $SQL
}

usergroup() {
	groupadd www 
	useradd -g www www 
}

config() {
	#cp $root/nginx /etc/init.d/
    echo "config"
}

reload() {
	/etc/init.d/nginx reload
}

main $1
