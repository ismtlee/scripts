#!/bin/sh
root=$PWD
download=~/Downloads
prefix=/usr/local/cellar


main() {
	if [ ! -d $download ];
	then
	  mkdir $download
	fi
	cd $download

	if [ x$1 = "xinstall" ];then
	  dependencies
	  download
	  usergroup
	  install
	  config

		exit
	fi

	if [ x$1 != "xupdate" ];then
		echo "invalid option.quit."
		exit
	fi

	update
}	

update() {
	cd $download
  download
	install
	reload
}
