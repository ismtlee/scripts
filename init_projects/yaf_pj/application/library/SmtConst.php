<?php
/**
 * 
 * 常量定义
 * 
 * @author Smart Lee <ismtlee@gmail.com>
 * @version $Revision 2.0 2012-11-2 下午4:15:55
 */
class SmtConst {
	/** 权限 */	
	public static $role = array('admin' => 1, 'reader' => 2, 'company' => 3);
	/** 错误类别 - 返回客户端 */
	const CODE_FAILURE = 0;
	const CODE_ERROR_OFFLINE = -1; 
	const CODE_SUCCESS = 1;

}	

