#!/bin/sh
source ../header.sh
version=1.0.4

dependencies() {
	echo 'no dependencies...'
}

download() {
  tgz=hadoop-$version.tar.gz

	if [ ! -f $download/$tgz ];
	then
		wget http://www.us.apache.org/dist/hadoop/common/hadoop-$version/$tgz
		mkdir /usr/local/cellar
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
	hadoop_home=$prefix/hadoop-$version
	cd $hadoop_home
	sed -i '1i'"export JAVA_HOME=$JAVA_HOME"'' conf/hadoop-env.sh
	echo "export PATH=\$PATH:$hadoop_home/bin" >> /etc/profile
	source /etc/profile
}

reload() {
	echo 'no need'
}

main $1
