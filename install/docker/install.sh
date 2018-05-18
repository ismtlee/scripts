#!/bin/sh
source ../header.sh

dependencies() {
  yum install -y yum-utils device-mapper-persistent-data lvm2
  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  yum-config-manager --disable docker-ce-edge
}

download() {
  :
}

install() {
  yum makecache fast
  yum install docker-ce
  #install compose
  pip3 install docker-compose
}

usergroup() {
  :
}

config() {
  systemctl enable docker
  systemctl start docker
}

reload() {
 : 
}				


main $1
