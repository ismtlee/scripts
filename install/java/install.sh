#!/bin/sh
root=$PWD
download=~/Downloads
#prefix=/usr/local/cellar
cd $download
rpm -qa|grep java
yum -y remove java

#wget http://download.oracle.com/otn-pub/java/jdk/7u3-b04/jdk-7u3-linux-x64.rpm
#32 bit
#wget http://download.oracle.com/otn-pub/java/jdk/7u17-b02/jdk-7u17-linux-i586.rpm --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com"
#64 bit
wget http://download.oracle.com/otn-pub/java/jdk/7u17-b02/jdk-7u17-linux-x64.rpm --no-check-certificate --no-cookies --header "Cookie: gpw_e24=http%3A%2F%2F
www.oracle.com"
mkdir /usr/java
rpm -ivh jdk-7u5-linux-x64.rpm  
echo "export JAVA_HOME=/usr/java/jdk1.7.0_05/" >> /etc/profile
echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /etc/profile
source /etc/profile

