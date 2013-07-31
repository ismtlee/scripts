#!/bin/sh
source ../header.sh
core_version=3.4.3
plugin_version=1.4.15
nrpe_version=2.14

dependencies() {
	yum install -y wget httpd php gcc glibc glibc-common gd gd-devel make net-snmp
}

download() {
  core_tgz=nagios-$core_version.tar.gz
	if [ ! -f $download/$core_tgz ];
	then
		wget http://prdownloads.sourceforge.net/sourceforge/nagios/$core_tgz
		tar zxvf $core_tgz 
	fi

  plugin_tgz=nagios-plugins-$plugin_version.tar.gz
	if [ ! -f $download/$plugin_tgz ];
	then
		wget http://sourceforge.net/projects/nagiosplug/files/nagiosplug/$plugin_version/$plugin_tgz
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
	#core
	cd $download/nagios
	./configure --with-command-group=nagcmd
	make all;make install;make install-init;make install-config;make install-commandmode;make install-webconf
	cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
  chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
  /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

	#plugin
	cd $download/nagios-plugins-$plugin_version
  ./configure --with-nagios-user=nagios --with-nagios-group=nagios 
	make;make install

	#nrpe
	cd $download/nrpe-$nrpe_version
	./configure
	make all
	make install-plugin

}

usergroup() {
	useradd nagios
	groupadd nagcmd
	usermod -a -G nagcmd nagios
}

config() {
	htpasswd –c /usr/local/nagios/etc/htpasswd.users nagiosadmin
	/etc/init.d/nagios start
	/etc/init.d/httpd start
	chkconfig --add nagios
	chkconfig --level 35 nagios on
	chkconfig --add httpd
	chkconfig --level 35 httpd on
}

reload() {
	/etc/init.d/rsyncd restart
}


main $1
