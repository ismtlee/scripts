#!/bin/sh
update() {
 /usr/bin/svn cleanup /usr/deploy$1
 /usr/bin/svn up /usr/deploy$1
}

sync() {
	rsync -avz  --delete  --force --exclude=".svn/***" --password-file=/etc/rsyncd/rsync.password  /usr/deploy/andplus/androidplus/ www@$1::andplus 
}

update $1
sync 192.168.1.13
