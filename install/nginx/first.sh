#!/bin/sh
# WARNING: Please excute this script only for first installation!
source ../header.sh

cp $root/nginx.conf.init $prefix/nginx/conf/nginx.conf
cp $root/sites.conf.init $prefix/nginx/conf/sites.conf
