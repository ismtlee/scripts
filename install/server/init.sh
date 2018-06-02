#!/bin/sh

#update first
yum update -y


bit=`getconf LONG_BIT`

#file descriptor limits
echo "* soft nofile 655360" >> /etc/security/limits.conf  
echo "* hard nofile 655360" >> /etc/security/limits.conf  
#redis warning
echo "net.core.somaxconn = 65535" >> /etc/sysctl.conf
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf
sysctl  -p

if [ $bit == 32 ]; then
	echo "session required /lib/security/pam_limits.so" >> /etc/pam.d/login 
else
	echo "session required /lib64/security/pam_limits.so" >> /etc/pam.d/login 
fi

#close default firewall
systemctl disable firewalld.service
systemctl stop firewalld.service
#close selinux
sed -i s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config 

cp  disable-transparent-hugepages /etc/init.d/

chmod 755 /etc/init.d/disable-transparent-hugepages

chkconfig --add disable-transparent-hugepages

mkdir /etc/tuned/no-thp
cp tuned.conf /etc/tuned/no-thp/
tuned-adm profile no-thp
#never is right or try to reboot the machine 
#cat /sys/kernel/mm/transparent_hugepage/enabled
#cat /sys/kernel/mm/transparent_hugepage/defrag
