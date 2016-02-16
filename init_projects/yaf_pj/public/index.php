<?php
define('APP_PATH', dirname(dirname(__FILE__)));
define('CONFIG_INI', APP_PATH . '/conf/application.ini');
$app  = new Yaf_Application(CONFIG_INI);
$app->bootstrap() //call bootstrap methods defined in Bootstrap.php
	->run();