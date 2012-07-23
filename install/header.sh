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
	usergroup
	install
	create_link
}	
