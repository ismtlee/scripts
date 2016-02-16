<?php

class SmtManager{
	/**
	 * 验证是否已登录.
	 */
	public static function authLogined() {
		if(!($username = Yaf_Session::getInstance()->get('username'))
		 ||!($department_id = Yaf_Session::getInstance()->get('department_id'))
		 ||!($role = Yaf_Session::getInstance()->get('role'))) {
			return "";
		}
		return array($username, $role);
	}
	
	/**
	 * 验证是否管理员 
	 */
	public static function authAdmin() {
		if(Yaf_Session::getInstance()->get('role') !=  SmtConst::$role['admin']) {
			exit(json_encode(array('status' => 0, 'msg' => 'auth invalid!')));
		}
	}

	public static function analytics($username, $role) {
		$data = array('status' => SmtConst::CODE_SUCCESS,
				'data' => array('username' => $username, 'role' => $role, 
					'earnings' => 10000, 'dau_apps' => 1000000, 'dau_games' => 564901, 'dau_games' => 93994003));
		return $data;
	}
	


}
