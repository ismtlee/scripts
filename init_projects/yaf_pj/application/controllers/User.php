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
	
}	
