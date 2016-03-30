#!/bin/sh
envdir=$(dirname $0)
source $envdir/env.sh

SRC=$1
NEWPKG=$2

if [ -z "$1" ]; then
    echo "请输入待换包的文件夹名称!"
    exit
fi

if [ -z "$2" ]; then
    echo "请输入新的包名!"
    exit
fi

modPkg() {
    if [ ! -d $TEMP/$SRC ]; then
       echo $TEMP/$SRC
       echo "错误: 目标项目不存在,请检查Temp目录!"
       exit
    fi
    TMP_PKG=$TEMP/${SRC}_PKG
    rm -rf $TMP_PKG
    cp -r $TEMP/$SRC $TMP_PKG

    OLDPKG=`xml sel -t -m "/manifest" -v "@package" $TMP_PKG/AndroidManifest.xml`
    echo "The old package name: $OLDPKG"

    OLDDIR=`echo $OLDPKG|tr . /`
    NEWDIR=`echo $NEWPKG|tr . /`

    # 更名原包名的目录
    mkdir -p $TMP_PKG/smali/$NEWDIR
    cp -r $TMP_PKG/smali/$OLDDIR/* $TMP_PKG/smali/$NEWDIR/ 
    rm -rf $TMP_PKG/smali/$OLDDIR

    # 所有文件oa/ob/oc 替换成 na/nb/nc 
    #OLDTXT=`echo $OLDPKG|gsed  's#\.#\\\/#g'`
    #NEWTXT=`echo $NEWPKG|gsed  's#\.#\\\/#g'`
    #grep -e "$OLDTXT" -rl $TMP_PKG |xargs gsed -i "s/$OLDTXT/$NEWTXT/g"

    # 所有文件oa.ob.oc 替换成 na.nb.nc
    #OLDTXT=`echo $OLDPKG|gsed  's#\.#\\.#g'`
    #NEWTXT=`echo $NEWPKG|gsed  's#\.#\\.#g'`
    #grep -e $"OLDTXT" -rl $TMP_PKG |xargs gsed -i "s/$OLDTXT/$NEWTXT/g"

    # Do not include binary files(-I)|not showing files(-h)
    # search all special characters
    OLDTXT=`echo $OLDPKG|gsed  's#\.#\\\(.*\\\)#g'`
    split_char=`grep -e "$OLDPKG" -r -o -h -I $TMP_PKG|sort -u|gsed "s/$OLDTXT/\1/g"`
    for x in $split_char
    do
        replaceTxt $x $OLDPKG $NEWPKG
    done 

    #grep -e "$OLDPKG" -r -o $TMP_PKG|gsed "s/$OLDTXT/\1/"

    echo "Begin generating apk files, it may take a while..."
    buildApk $TMP_PKG $PKGAPK
    echo "packaged apk files:"
    ls -l $PKGAPK/
}

# 所有文件oa{tag}ob{tag}oc 替换成 na{tag}nb{tag}nc 

replaceTxt() {
    #OLDTXT=`echo $OLDPKG|gsed  's#\.#\\\/#g'`
    #NEWTXT=`echo $NEWPKG|gsed  's#\.#\\\/#g'`
    tag=$1
    OLDPKG=$2
    NEWPKG=$3
    #fucking / in sed! /会导致无法取变量值
    if [ "$tag"x = "#x" ]; then
        OLDTXT=`echo $OLDPKG|gsed  "s/\./+$tag/g"|tr + '\'`
        NEWTXT=`echo $NEWPKG|gsed  "s/\./+$tag/g"|tr + '\'`
    else
        OLDTXT=`echo $OLDPKG|gsed  "s#\.#+$tag#g"|tr + '\'`
        NEWTXT=`echo $NEWPKG|gsed  "s#\.#+$tag#g"|tr + '\'`
    fi
    grep -e "$OLDTXT" -rl $TMP_PKG |xargs gsed -i "s/$OLDTXT/$NEWTXT/g"
}

modPkg


