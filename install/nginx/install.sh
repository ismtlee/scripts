#!/bin/sh
source ../header.sh
version=1.16.1
#sysctl_dir=/usr/lib/systemd/system/

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
	./configure --prefix=${prefix}/nginx --user=www --group=www  --with-http_stub_status_module --with-http_ssl_module
	make;make install
}

usergroup() {
	groupadd www 
	useradd -g www www 
}

config() {
  cp $root/nginx.conf $prefix/nginx/conf
  cp $root/sites.conf $prefix/nginx/conf
  cp $root/NginxLogCut.sh $prefix/nginx/sbin/
  mkdir -p /logs/nginx
  chown -R www /logs

  if [ ! -d $sysctl_dir ];
  then
    cp $root/nginx /etc/init.d/
    chmod +x /etc/init.d/nginx
    /etc/init.d/nginx restart
	chkconfig nginx on
  else #centos 7
    cp $root/nginx.service $sysctl_dir
    systemctl restart nginx
    systemctl enable nginx
  fi
}

reload() {
	/etc/init.d/nginx reload
}

main $1
