#!/bin/sh
#二进制包安装centos7 nodejs
source ../header.sh

dependencies() {
	echo ""
}

download() {
  echo ""
}

install() {
  curl --silent --location https://rpm.nodesource.com/setup_9.x | sudo bash -
  yum install nodejs -y
  npm install forever -g
}

usergroup() {
	echo "no user&group need..."
}

config() {
	echo "no configure need..."
}

reload() {
	echo "no reload need..."
}

main $1
