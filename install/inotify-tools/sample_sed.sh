#!/bin/sh
#wordpress 同步

#-- nohup sh sample.sh& --
host=50.7.52.66

src=/usr/deploy/wordpress/
dst=wordpress


sync() {
        for file  in `ls $src/news_*.html`
        do
        if grep -q "wp.barleypublish.com" $file

        then    /bin/sed -i s/"wp.barleypublish.com"/"newstoday.barleypublish.com"/g $file
                rsync -avz  --delete  --force --exclude=".svn/***" --password-file=/etc/rsyncd/rsync.password  $src www@$1::$dst
        fi
        done
}

/usr/local/cellar/inotify/bin/inotifywait --exclude=".svn/***" -mrq  --timefmt '%d/%m/%y %H:%M' --format '%T %w%f%e' -e modify,delete,create,attrib $src | wh
ile read files;
do
 sync $host
done
