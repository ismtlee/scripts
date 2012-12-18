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
		wget http://labs.mop.com/apache-mirror/hadoop/common/stable/$tgz
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
	sed -i '1i'"$JAVA_HOME"'' conf/hadoop-env.sh
	echo "export PATH=$PATH:$hadoop_home/bin" >> /etc/profile
}

reload() {
	echo 'no need'
}

main $1
