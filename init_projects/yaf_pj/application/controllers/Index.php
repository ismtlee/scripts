<?php
class IndexController extends BaseController {

	public function indexAction() {
        $data = array('foo' => 'bar');
        exit(json_encode($data));
	}
	
}
