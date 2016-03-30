#!/bin/sh
envdir=$(dirname $0)
source $envdir/env.sh

if [ -z "$1" ]; then
    echo "请输入待打包的文件夹!"
    exit
fi

echo "Begin generating apk files, it may take a while..."
buildApk $1 ./ 


