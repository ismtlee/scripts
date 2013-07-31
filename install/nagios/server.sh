#!/bin/sh
source ../header.sh
version=3.0.9

dependencies() {
	echo 'no need'
}

download() {
  tgz=rsync-$version.tar.gz

	if [ ! -f $download/$tgz ];
	then
		wget ftp://ftp.samba.org/pub/rsync/$tgz 
		wget ftp://216.83.154.106/pub/rsync/$tgz 
		tar zxvf $tgz 
	fi
}

install() {
  installed=`rpm -qa|grep rsync`
  if [ -n $installed ]
    then
	     echo "old rsync exists, deleted..."
       rpm -e $installed --nodeps
  fi

	cd $download/rsync-$version
	./configure --prefix=${prefix}/rsync 
	make;make install
	ln -s ${prefix}/rsync/bin/rsync /usr/local/bin/rsync
}

usergroup() {
	echo 'no need'
}

config() {
	mkdir /etc/rsyncd
	cp $root/rsyncd /etc/init.d/
  cp $root/rsyncd.conf /etc/rsyncd/
	sed -i ''s/inner_ip/"$inner_ip"/'' /etc/rsyncd/rsyncd.conf 
  cp $root/rsyncd.secrets /etc/rsyncd/
  cp $root/rsyncd.motd /etc/rsyncd/
  cp $root/rsync.password /etc/rsyncd/
	chmod 600 /etc/rsyncd/rsyncd.secrets
	chmod 600 /etc/rsyncd/rsync.password
  chmod +x /etc/init.d/rsyncd
  /etc/init.d/rsyncd restart
}

reload() {
	/etc/init.d/rsyncd restart
}

 
if [ x$1 = "xinstall" ];then
  if [ x$2 = "x" ];then
    echo 'Pls specify the role, server|client'
    exit
  fi
fi
role=$2	

main $1
