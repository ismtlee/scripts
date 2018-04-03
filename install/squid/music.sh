#!/bin/sh
#先安装node/centos7.sh squid/install.sh
# sh music.sh
APIDIR=/usr/deploy/NeteaseCloudMusicApi
mkdir $APIDIR
git clone https://github.com/Binaryify/NeteaseCloudMusicApi.git --depth 1 $APIDIR
npm install apicache --prefix $APIDIR
npm install express --prefix $APIDIR
npm install big-integer --prefix $APIDIR
npm install request --prefix $APIDIR

forever start $APIDIR/app.js
