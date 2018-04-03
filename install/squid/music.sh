#!/bin/sh
#先安装node/centos7.sh squid/install.sh
# sh music.sh
mkdir /usr/deploy
cd /usr/deploy/
git clone https://github.com/Binaryify/NeteaseCloudMusicApi.git --depth 1
cd NeteaseCloudMusicApi
npm install apicache
npm install express
npm install big-integer
npm install request

forever start app.js
