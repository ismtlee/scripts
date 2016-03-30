#!/bin/sh
PATH=$PATH
ROOT=$(dirname $0)/..
PLUGDIR=$ROOT/AppPluginSdkV3WrapperV5
#APKROOT=/home/samba/plugin
APKROOT=/Library/usr/crack
CURRENT=$APKROOT/current
TEMP=$APKROOT/temp/
NEWAPK=$APKROOT/raped
PKGAPK=$APKROOT/packaged

if [ ! -d $APKROOT  ]; then
    echo "[Error]: The APKROOT directory: $APKROOT not exists."
    exit
fi

install -d $CURRENT
install -d $TEMP
install -d $NEWAPK
install -d $PKGAPK

buildApk() {
   file=$1 #待打包的文件夹
   target_dir=$2  #apk存放目录
   if [ -z "$1" ]; then
       echo "[Error]: Please input project's directory."
       exit
   fi
   if [ -z "$2" ]; then
       echo "[Error]: Please input the target directory to hold apk file."
       exit
   fi
   filedir=`basename ${file}`
   newapkfiles=$target_dir/$filedir
   apktool b $file -f -o $newapkfiles.apk > /dev/null
   jarsigner  -verbose -keystore ~/.android/debug.keystore -signedjar ${newapkfiles}_signed.apk $newapkfiles.apk  androiddebugkey -storepass android -tsa http://timestamp.digicert.com > /dev/null
   rm -rf $newapkfiles.apk
}

gap() {
    line='>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>'
    echo $line
    if [ ! -z "$1" ]; then
        echo $1
    fi
}
