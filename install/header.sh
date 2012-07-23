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

	if [ $1 = "install" ];then
	  dependencies
	  download
	  usergroup
	  install
	  config
	fi

	if [ $1 != "update" ];then
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
