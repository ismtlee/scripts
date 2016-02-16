<?php
/**
 * 
 * 帐号及人员统一管理
 * 
 *
 * Use Yaf framework for PHP 5.3.0 or newer
 *
 * @package		Yaf
 * @subpackage   Controller
 * @author		Smart Lee <ismtlee@gmail.com>
 * @copyright	Copyright (c) 2008 - 2012, Pig, Inc.
 * @since		Version 2.0
 * @filesource
 */
// ------------------------------------------------------------------------
/**
 * 
 * UserController
 *
 * 帐号管理
 * 
 * @package Yaf
 * @subpackage Controller
 * @author Smart Lee <ismtlee@gmail.com>
 * @version $Revision 2.0 2012-12-13 下午11:17:45
 */
class UserController extends Yaf_Controller_Abstract {
	public function init() {
		//Yaf_Dispatcher::getInstance()->disableView();
	}
	
	public function indexAction() {
		JoyManager::authLogined();
	}
	
	public function loginAction() {
		Yaf_Dispatcher::getInstance()->disableView();
		
	}

	/**
	 * 用户登录
	 * 
	 * <p>/user/auth?username=wm1@gmail.com&password=e10adc3949ba59abbe56e057f20f883e
	 * <br>密码为md5加密后的形式</p>
	 * @return 
	 */
	public function authAction() {
		if(!isset($_REQUEST['username']) || !isset($_REQUEST['password'])) {
			exit(json_encode(array('status' => IvyConst::CODE_FAILURE)));
		}
		$username = urldecode(trim($_REQUEST['username']));
		$password = md5(urldecode(trim($_REQUEST['password'])));
		if(empty($username) || empty($password)){
			exit(json_encode(array('status' => IvyConst::CODE_FAILURE)));
		}
	
		$user = UserModel::find_by(array('username' => $username));

		if(!$user) {
			exit(json_encode(array('status' => IvyConst::CODE_FAILURE)));
		}
		if ($user->password != $password) {
			exit(json_encode(array('status' => IvyConst::CODE_FAILURE)));
		}
		$curtime = IvyUtil::getSysTime();
		$ip = IvyUtil::getIp();
		//登录日志
		Login_RecordModel::create(array('user_id' => $user->id, 'login_time' => $curtime, 'login_ip' => $ip));
		//最后一次登录记录
		$user->last_login_time = $curtime;
		$user->last_login_ip = $ip;
		$user->save();
		Yaf_Session::getInstance()->set('username', $username);
		Yaf_Session::getInstance()->set('department_id', $user->department_id);
		//Yaf_Session::getInstance()->set('company_id', $user->company_id);
		Yaf_Session::getInstance()->set('role', $user->role);
		if ($user->role == IvyConst::$role['admin']
			|| $user->role == IvyConst::$role['reader']) {
			//TODO: 调用同index/analytics同样的接口，返回数据相同
			exit(json_encode(IvyManager::analytics($user->username, $user->role)));
		}else {
			exit(json_encode(array('status' => IvyConst::CODE_FAILURE,
				'msg' => 'auth failure!')));
		}
	}
	
	/**
	 * 退出登录
	 * 
	 */
	public function logoutAction() {
		Yaf_Dispatcher::getInstance()->disableView();
		Yaf_Session::getInstance()->del('username');
		Yaf_Session::getInstance()->del('department_id');
		Yaf_Session::getInstance()->del('role');
		$this->redirect('/user/login');
	}
	
	/**
	 * 添加帐户
	 * <p>/user/addUser?username=wm1&password=123456&department_id=2<br>
	 * username string 帐号名<br>
	 * password string 密码<br>
	 * department_id int 村居ID<br>
	 * 仅管理员帐号有权限操作</p>
	 */
	public function addUserAction() {
		JoyManager::authLogined();
		if(!isset($_REQUEST['username'])
		  || !($username = trim($_REQUEST['username']))
		  || !isset($_REQUEST['password'])
		  || !($password = trim($_REQUEST['password']))
		  || !isset($_REQUEST['role'])
		  || !($role = trim($_REQUEST['role']))) {
			exit(json_encode(array('status' => 0, 'msg' => '请按要求提交表单信息！')));
		}
		JoyManager::authAdmin();
		$department_id = '';
		if(isset($_REQUEST['department_id'])) {
			$department_id = $_REQUEST['department_id'];
		} 
		if(isset($_REQUEST['company_id'])) {
			$company_id = $_REQUEST['company_id'];
			$company = CompanyModel::find($company_id);
			if($company) {
				$department_id = $company->department_id;
			}
		}
		if($role == JoyConst::$role['admin']) {
			$department_id = JoyConst::ADMIN_DEPARTMENT;
		}
		$attributes = array('username' => $username,
		  'password' => md5($password),
		  'department_id' => $department_id,
		  'company_id' => isset($company_id) ? $company_id:'', 
		  'role' => $role,
		  'created_at' => JoyUtil::getSysTime());
		if(UserModel::create($attributes)) {
			exit(json_encode(array('status' => 1, 'msg' => '添加成功!')));
			return;
		}
		echo json_encode(array('status' => 0, 'msg' => '该用户名已存在，请换一个用户名!'));
	}
	
   /**
	* 删除帐户
	* <p>/user/delUser?id=2<br>
	* id int 帐户ID<br>
	* 仅管理员帐号有权限操作</p>
	*/
	public function delUserAction() {
		JoyManager::authLogined();
		if(!isset($_REQUEST['id'])
		 || !($user_id = $_REQUEST['id'])) {
			exit(json_encode(array('status' => 0, 'msg' => '参数错误!')));
		}
		if($user_id == 1) {//默认分配的管理员帐号不能删除
			exit(json_encode(array('status' => 0, 'msg' => '默认管理员不可删除!')));
		}
		JoyManager::authAdmin();
		if(UserModel::delete_by(array('id' => $user_id))) {
			exit(json_encode(array('status' => 1, 'msg' => 'success!')));
		}
		echo json_encode(array('status' => 0, 'msg' => 'failure!'));
	}
	
   /**
	* 更新帐户
	* 
	* 无法对管理员密码进行修改。
	* 企业帐号department_id传-1
	* <p>/user/modUser?id=2&username=wm1&password=123456&department_id=2<br>
	* username string 帐号名<br>
	* password string 密码<br>
	* department_id int 村居ID<br>
	* 仅管理员帐号有权限操作</p>
	*/
	public function modUserAction() {
		JoyManager::authLogined();
		if(!isset($_REQUEST['id'])
	    || !($id = $_REQUEST['id'])
		|| !isset($_REQUEST['username'])
		|| !($username = trim($_REQUEST['username']))
		|| !isset($_REQUEST['role'])
		|| !($role = trim($_REQUEST['role']))) {
			exit(json_encode(array('status' => 0, 'msg' => '请按要求提交表单信息！')));
		}
		JoyManager::authAdmin();
		if(isset($_REQUEST['department_id'])) {
			$department_id = $_REQUEST['department_id'];
		} 
		if(isset($_REQUEST['company_id'])) {
			$company_id = $_REQUEST['company_id'];
			$company = CompanyModel::find($company_id);
			if($company) {
				$department_id = $company->department_id;
			}
		}
		
		//非站北社区帐号不能设置为管理员
		$user = UserModel::find($id);
		if($role == JoyConst::$role['admin'] && $user->department_id != JoyConst::ADMIN_DEPARTMENT) {
			echo json_encode(array('status' => 0, 'msg' => '非站北社区帐号不能被设置管理员！'));
			return;
		}
		
		$attributes = array('username' => $username,
			  'role' => $role);
		if(isset($department_id)) {
			$attributes['department_id'] = $department_id;
			$attributes['company_id'] = '';//将企业信息删除
		} 
		if(isset($company_id)) {
			$attributes['company_id'] = $company_id;
		}
		if($id != 1   //默认分配的管理员密码不能修改
		 && isset($_REQUEST['password'])
		 &&($password = $_REQUEST['password'])) {
			$attributes['password'] = md5($password);
		}
		if(UserModel::update_by(array('id'=>$id), $attributes)) {
			exit(json_encode(array('status' => 1, 'msg' => '修改成功！')));
		}
		echo json_encode(array('status' => 0, 'msg' => '修改失败！'));
	}
	
   /**
	* 修改密码
	*
	* <p>/user/updatePass?old_pass=1234&new_pass=123456
	* 任何帐户都可以修改自己的密码</p>
	*
	*/
	public function updatePassAction() {
		$username = JoyManager::authLogined();
		if(!isset($_REQUEST['old_pass']) || !($old_pass = trim($_REQUEST['old_pass']))) {
			exit(json_encode(array('status' => JoyConst::STATUS_FAILURE, 'msg' => '请输入旧密码！')));
		}
		if(!isset($_REQUEST['new_pass']) || !($new_pass = trim($_REQUEST['new_pass']))) {
			exit(json_encode(array('status' => JoyConst::STATUS_FAILURE, 'msg' => '请输入新密码！')));
		}
		$user = UserModel::find_by(array('username' => Yaf_Session::getInstance()->get('username')));
		if($user && $user->password == md5($old_pass)) {
			$user->password = md5($new_pass);
			if ($user->save()) {
				exit(json_encode(array('status' => JoyConst::STATUS_SUCCESS)));
			}
		}
		echo json_encode(array('status' => JoyConst::STATUS_FAILURE, 'msg' => '原登录密码输入错误！'));

	}
		
	public function editUserAction() {
		Yaf_Dispatcher::getInstance()->enableView();
		JoyManager::authAdmin();
		$roles = JoyConst::$role_tag;
		$result = array('roles' => $roles,
		 'company_list' => CompanyModel::showList(),
		 'departments' => DepartmentModel::showList());
		$user = null;
		if(isset($_REQUEST['id'])

		 && ($id = $_REQUEST['id']) > 0) {
			//填充表单
			$user = UserModel::find($id);
		}
		
		$result['user'] = $user;
		$this->getView()->assign($result);
	}				
	
	/**
	 * 登录日志
	 * 默认最近50条
	 * 登录信息的表格字段有
	 * username:用户
	 * login_time:登录时间
	 * login_ip:登录IP
	 * 
	 */
	public function loginLogAction() {
// 		Yaf_Dispatcher::getInstance()->enableView();
		$list = Login_RecordModel::showList();
// 		$this->getView()->assign(array('list' => $list));
		foreach ($list as $e) {
// 			echo implode("\t", $e)."<br>";
			echo $e['login_time']."\t".$e['username']."\t".$e['login_ip']."<br>";
		}
	}
	
}