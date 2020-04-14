#!/bin/sh
host=204.45.0.66

src=/usr/deploy/statics/adpic/ #说明:目录的最后一个/加和不加，对rsync区别很大.
#被同步服，也就是这个脚本的执行服务器加/，同步服在配置文件的module里不加

dst=adpic


sync() {
        #rsync -avz  --delete  --force --exclude=".svn/***" --password-file=/etc/rsyncd/rsync.password  $src www@$1::$dst
        rsync -avz -u   --force --exclude=".svn/***" --password-file=/etc/rsyncd/rsync.password  $src www@$1::$dst
}

/usr/local/bin/inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' -e modify,delete,create,attrib $src | while read files;
do
 sync $host
done
