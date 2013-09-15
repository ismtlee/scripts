#!/bin/sh
source ../header.sh
version=3.14
inner_ip=default

dependencies() {
	echo 'no need'
}

download() {
  tgz=inotify-tools-$version.tar.gz

	if [ ! -f $download/$tgz ];
	then
		wget http://github.com/downloads/rvoicilas/inotify-tools/$tgz
		tar zxvf $tgz 
	fi
}

install() {
	cd $download/inotify-tools-$version
	./configure --prefix=${prefix}/inotify
	make;make install
	#ln -s ${prefix}/rsync/bin/rsync /usr/local/bin/rsync
}

usergroup() {
	echo 'no need'
}

config() {
	 echo "export PATH=\$PATH:${prefix}/inotify/bin" >> /etc/profile
}

reload() {
	echo 'no need'
}


main $1
