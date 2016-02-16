<?php
class Bootstrap extends Yaf_Bootstrap_Abstract {
	private $config;
	
	/*get a copy of the config*/
	public function _initBootstrap(){
		$this->_config = Yaf_Application::app()->getConfig();
	}
	
	function _initEnv() {
		Yaf_Dispatcher::getInstance()->disableView();
		set_include_path(get_include_path() . PATH_SEPARATOR . $this->_config->application->library);
	}
	
}
