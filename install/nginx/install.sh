#!/bin/sh
source ../header.sh
version=1.12.0

dependencies() {
  yum -y install pcre pcre-devel
}

download() {
  nginx_tgz=nginx-$version.tar.gz

	if [ ! -f $download/$nginx_tgz ];
	then
		wget http://nginx.org/download/$nginx_tgz
		tar zxvf $nginx_tgz 
	fi
}

install() {
	cd $download/nginx-$version
	./configure --prefix=${prefix}/nginx --user=www --group=www  --with-http_stub_status_module 
	make;make install
}

usergroup() {
	groupadd www 
	useradd -g www www 
}

config() {
	cp $root/nginx /etc/init.d/
  cp $root/nginx.conf $prefix/nginx/conf
  cp $root/sites.conf $prefix/nginx/conf
  cp $root/NginxLogCut.sh $prefix/nginx/sbin/
  chmod +x /etc/init.d/nginx
  mkdir -p /logs/nginx
  chown -R www /logs
  /etc/init.d/nginx restart
	#start when reboot
	chkconfig nginx on
}

reload() {
	/etc/init.d/nginx reload
}

main $1
