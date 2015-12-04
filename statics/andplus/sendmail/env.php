<?php
define('APP_PATH', dirname(__FILE__));
define('CONFIG_INI', APP_PATH . '/config.ini');

/*
set_include_path(APP_PATH . "/google-api-php-client/src" . PATH_SEPARATOR .
  APP_PATH . "/library" . PATH_SEPARATOR .
  APP_PATH . "/googleads-adsense-examples/php-clientlib-1.x/v1.x/". PATH_SEPARATOR. get_include_path());
*/

spl_autoload_register(function($class){
   require_once($class.'.php');
});
