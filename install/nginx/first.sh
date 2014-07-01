#!/bin/sh
# WARNING: Please excute this script only for first installation!
source ../header.sh

echo "The script only for first installation. This may cover your configuration."
echo "Do you wish to proceed <y or n> ?"
read WISH

if [ x$WISH = "xn" ];then
	echo bye
	exit
fi

if [ x$WISH != "xy" ];then
	echo "invalid option, bye"
	exit
fi

cp $root/nginx.conf.init $prefix/nginx/conf/nginx.conf
cp $root/sites.conf.init $prefix/nginx/conf/sites.conf
