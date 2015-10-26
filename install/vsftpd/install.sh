#!/bin/sh
source ../header.sh

dependencies() {
	echo 'no need';
}

download() {
	echo 'no need';
}

install() {
	yum -y install vsftpd
}

usergroup() {
	echo 'need later.';
	echo 'useradd -g www -s /sbin/nologin -d /usr/deploy/lee lee';
}

config() {
  cp $root/vsftpd.conf /etc/vsftpd/
	touch /etc/vsftpd/welcome
	touch /etc/vsftpd/chroot_list
  /etc/init.d/vsftpd restart
}

reload() {
	/etc/init.d/vsftpd restart
}

main $1
