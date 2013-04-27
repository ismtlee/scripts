#!/bin/sh

#update first
bit=`getconf LONG_BIT`

if [ $bit == 32 ]; then
	  pkgname=jdk-7u17-linux-i586.rpm
	else
		  pkgname=jdk-7u17-linux-x64.rpm
		fi

		echo $pkgname
