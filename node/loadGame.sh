#!/bin/sh
/usr/bin/svn cleanup /usr/deploy/orange_dev /usr/docs/orange
/usr/local/cellar/php53/bin/php /usr/deploy/orange_dev/scripts/rexcel.php json
/usr/local/cellar/php53/bin/php /usr/deploy/orange_dev/scripts/rexcel.php xml 
/etc/init.d/php-fpm restart
