#!/bin/sh
source ../header.sh
version=v0.8.5

dependencies() {
	echo ""
}

download() {
  node_tgz=node-$version.tar.gz

	if [ ! -f $download/$node_tgz ];
	then
		wget http://nodejs.org/dist/$version/$node_tgz
		tar zxvf $node_tgz 
	fi
}

install() {
	cd $download/node-$version
	./configure 
	make;make install
	#make doc
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
