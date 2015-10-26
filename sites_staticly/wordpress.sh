#!/bin/sh
export PATH=/usr/bin:/bin:/usr/local/bin
SITES=funny.luheisi.com
TARGET_DIR=/usr/deploy
NEW_NAME=wordpress_funny
UPLOADS_PIC=$TARGET_DIR/$NEW_NAME/wp-content/uploads/
#retrive upload pics
rsync -avz  --delete --force --exclude=".svn/***" --password-file=/etc/rsyncd/rsync.password www@203.88.164.146::andplus $UPLOADS_PIC 
#wget -e robots=off -rmkEpnp http://funny.luheisi.com
/usr/bin/wget -e robots=off --mirror -w 2 -p --html-extension --convert-links  $SITES -P $TARGET_DIR
grep luheisi -rl $TARGET_DIR/$SITES | xargs sed -i  "s/luheisi/linkerboom/g"
\cp -rf  --remove-destination $TARGET_DIR/$SITES/* $TARGET_DIR/$NEW_NAME/
