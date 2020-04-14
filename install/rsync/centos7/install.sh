#!/bin/sh
source ../../header.sh
version=3.1.2
inner_ip=default

dependencies() {
  echo 'no need'
}

download() {
  echo 'no need'
}

install() {
  yum install -y rsync xinetd 
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
 # cp $root/excludes /etc/rsyncd/
  cp $root/rsync /etc/xinetd.d/
	chmod 600 /etc/rsyncd/rsyncd.secrets
	chmod 600 /etc/rsyncd/rsync.password
}

reload() {
	/etc/init.d/rsyncd restart
}

inner_ip=$2	
 
if [ x$1 = "xinstall" ];then
  if [ x$2 = "x" ];then
    echo 'Pls specify the inner IP, ex, 192.168.1.10. Note, Address is not neccserry, however.'
    exit
  fi
fi
inner_ip=$2	

main $1
