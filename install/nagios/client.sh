#!/bin/sh
source ../header.sh
#plugin_version=1.4.15
plugin_version=1.5
nrpe_version=2.14
moniter_server=204.45.38.42

dependencies() {
	yum install -y xinetd
}

download() {
  plugin_tgz=nagios-plugins-$plugin_version.tar.gz
	if [ ! -f $download/$plugin_tgz ];
	then
		wget https://www.nagios-plugins.org/download/$plugin_tgz
		#wget http://sourceforge.net/projects/nagiosplug/files/nagiosplug/$plugin_version/$plugin_tgz
		tar zxvf $plugin_tgz 
	fi

  nrpe_tgz=nrpe-$nrpe_version.tar.gz
	if [ ! -f $download/$nrpe_tgz ];
	then
		#wget http://nchc.dl.sourceforge.net/project/nagios/nrpe-2.x/nrpe-$nrpe_version/$nrpe_tgz
		wget http://211.79.60.17/project/nagios/nrpe-2.x/nrpe-$nrpe_version/$nrpe_tgz
		tar zxvf $nrpe_tgz
	fi
}

install() {
	#plugin
	cd $download/nagios-plugins-$plugin_version
  ./configure --with-nagios-user=nagios --with-nagios-group=nagios 
	make;make install
  chown nagios.nagios /usr/local/nagios
	chown -R nagios.nagios /usr/local/nagios/libexec

	#nrpe
	cd $download/nrpe-$nrpe_version
	./configure
	make all
	make install-plugin
  make install-daemon
	make install-daemon-config
	make install-xinetd
}

usergroup() {
	useradd nagios
	#passwd nagios
}

config() {
	#cp $root/htpasswd.users /usr/local/nagios/etc/htpasswd.users
	echo -e "nrpe\t5666/tcp\t#nrpe" >> /etc/services
	/etc/init.d/xinetd restart
	chkconfig --level 35 xinetd on

	sed -i s/"only_from.*"/"only_from=$moniter_server 127.0.0.1"/g /etc/xinetd.d/nrpe
	echo "+++++++++++++++++++++++++++++++++++++++++++++++++"
	echo "/usr/local/nagios/etc/nrpe.cfg your's command"
}

reload() {
	/etc/init.d/xinetd restart
}


main $1
