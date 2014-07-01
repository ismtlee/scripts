#!/bin/sh

#update first
yum update -y

bit=`getconf LONG_BIT`

#file descriptor limits
echo "* soft nofile 655360" >> /etc/security/limits.conf  
echo "* hard nofile 655360" >> /etc/security/limits.conf  

if [ $bit == 32 ]; then
	echo "session required /lib/security/pam_limits.so" >> /etc/pam.d/login 
else
	echo "session required /lib64/security/pam_limits.so" >> /etc/pam.d/login 
fi




