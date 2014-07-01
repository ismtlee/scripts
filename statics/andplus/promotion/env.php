<?php
define('ROOT_PATH', dirname(__FILE__));
$include_path = ROOT_PATH . '/configs' . PATH_SEPARATOR . 
ROOT_PATH . '/lib' . PATH_SEPARATOR .
ROOT_PATH . '/configs';
set_include_path ($include_path);
error_reporting(E_ALL);

function __autoload($class) {
    if (class_exists($class, false) || interface_exists($class, false)) {
      return;
    }
	$file = str_replace('_', DIRECTORY_SEPARATOR, $class) . '.php';
    require $file;
}

