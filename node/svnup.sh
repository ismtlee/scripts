#!/bin/sh
update() {
 /usr/bin/svn cleanup /usr/deploy$1
 /usr/bin/svn up /usr/deploy$1
}

sync() {
	/usr/bin/rsync -avz  --delete --force --exclude=".svn/***" --password-file=/etc/rsyncd/rsync.password www@$1::andplus   /usr/deploy/andplus/androidplus
}

update $1
sync 192.168.1.13
