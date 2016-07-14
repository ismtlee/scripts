#!/bin/sh
APPTYPE=$1
APPID=$2
PKG=$3

if [ -z "$1" ]; then
    echo "请选择应用类型!"
    exit
fi
if [ -z "$2" ]; then
    echo "请输入3位数字ID!"
    exit
fi
if [ -z "$3" ]; then
    echo "请输入包名!"
    exit
fi

cd /home/build/tools
#java -jar server/ProcessBuild.jar /home/build apps 110 com.nicescreen.screenlock.ak47HD
java -jar server/ProcessBuild.jar /home/build $APPTYPE  $APPID $PKG 
