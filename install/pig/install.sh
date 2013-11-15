#!/bin/sh
source ../header.sh
version=0.10.1

dependencies() {
	echo 'no dependencies...'
}

download() {
  tgz=pig-$version.tar.gz

	if [ ! -f $download/$tgz ];
	then
#		wget http://www.us.apache.org/dist/pig/pig-$version/$tgz 
		wget https://archive.apache.org/dist/pig/pig-$version/$tgz
		tar zxvf $tgz -C ${prefix}
	fi
}

install() {
	echo 'no need'
}

usergroup() {
	echo 'no need'
}

config() {
	pig_home=$prefix/pig-$version
	cd $pig_home
	sed -i '1i'pig.temp.dir=/opt/pig/tmp'' conf/pig.properties
	sed -i '1i'pig.logfile=/logs/pig.log'' conf/pig.properties
	mkdir /opt/pig/tmp
	mkdir /logs
	echo "export PATH=\$PATH:$pig_home/bin" >> /etc/profile
	source /etc/profile
}

reload() {
	echo 'no need'
}

main $1
