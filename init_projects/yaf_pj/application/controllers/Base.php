<?php
class BaseController extends Yaf_Controller_Abstract {
	protected $username = "";
	protected $role = 0;

	public function init() {
		$user = IvyManager::authLogined();
		if(!$user) {
			exit(json_encode(array(
				'status' => IvyConst::CODE_ERROR_OFFLINE,
				'msg' => 'not login!'
			)));
		} 
		$this->username = $user[0];
		$this->role = $user[1];
	}
	
}
