<?php
class IndexController extends BaseController {

	
	public function indexAction() {
	}

	/**
	 * 默认进入Analytics页面
	 */
	public function analyticsAction() {
		//若未登录已由Base进行验证
		//获取登录后analytics数据
		exit(json_encode(IvyManager::analytics($this->username, $this->role)));
	}
	public function testAction() {
		echo "bbb";
	}

	public function totalRevAction() {

		
		$data = array(
			array('2016-01-01', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-02', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-03', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-04', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-05', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-06', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-07', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-08', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-09', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-10', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66'),
			array('2016-01-11', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66', '5.66')
		);
		$result = array(
			'sEcho' => 1,
			'recordsTotal' => count($data),
			'recordsFiltered' => count($data),
			'data' => $data
			
		);
		exit(json_encode($result));
	}

	
}
