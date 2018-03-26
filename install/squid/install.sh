#!/bin/sh
source ../header.sh

dependencies() {
	echo 'no need';
}

download() {
	echo 'no need';
}

install() {
	yum -y install squid httpd-tools
}

usergroup() {
	echo 'need later.';
}

config() {
  mkdir /etc/squid3/
  cp $root/squid.conf /etc/squid/
  htpasswd -cd /etc/squid3/passwords lee
  #input password here
  systemctl enable squid.service
  systemctl restart squid.service
}

reload() {
  systemctl reload squid.service
}

main $1
