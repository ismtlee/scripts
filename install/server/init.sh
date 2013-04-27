#!/bin/sh

#update first
yum update -y

#file descriptor limits
echo "* soft nofile 655360" >> /etc/security/limits.conf  
echo "* hard nofile 655360" >> /etc/security/limits.conf  
echo "session required pam_limits.so" >> /etc/pam.d/login 

