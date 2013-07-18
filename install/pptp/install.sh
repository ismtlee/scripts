#!/bin/sh
source ../header.sh

dependencies() {
	echo 'no need';
}

download() {
	echo 'no need';
}

install() {
	yum -y install ppp
	rpm -Uhv http://poptop.sourceforge.net/yum/stable/packages/pptpd-1.3.4-2.el6.x86_64.rpm

}

usergroup() {
	echo 'no need.';
}

config() {
  #cp $root/vsftpd.conf /etc/vsftpd/
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
