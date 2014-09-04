#!/bin/sh
source ../header.sh

PPTPD_VERSION=1.4.0-1

dependencies() {
	echo 'no need';
}

download() {
	echo 'no need';
}

install() {
	yum -y install ppp
	rpm -Uhv http://poptop.sourceforge.net/yum/stable/packages/pptpd-${PPTPD_VERSION}.el6.x86_64.rpm

}

usergroup() {
	echo 'no need.';
}

config() {
  cp $root/pptpd.conf /etc/
  cp $root/options.pptpd /etc/ppp/
	sed -i s/'net.ipv4.ip_forward = 0'/'net.ipv4.ip_forward = 1'/g /etc/sysctl.conf 
	sysctl -p
  #/etc/init.d/vsftpd restart
	#iptables
  #check the rules at /etc/sysconfig/iptables. Make sure that the POSTROUTING rules is above any REJECT rules. 
	iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
	service iptables save
	service iptables restart
  #turn on at startup	
	chkconfig pptpd on
}

reload() {
	/etc/init.d/vsftpd restart
}

main $1
