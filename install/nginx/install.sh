#!/bin/sh
source ../header.sh
version=1.2.2

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
	cp nginx /etc/init.d/
	cp nginx.conf $prefix/nginx/conf
	cp sites.conf $prefix/nginx/conf
	chmod +x /etc/init.d/nginx
	mkdir -p /logs/nginx
	chown -R www /logs
	/etc/init.d/nginx restart
}

usergroup() {
	groupadd www 
	useradd -g www www 
}

create_link() {
}

main
