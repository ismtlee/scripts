<?php
class Login_RecordModel extends ActiveRecord {
	public static function showList($count = 50) {
		$db = JoyDb::getInstance();
		$sql = 'select t1.id id, t2.username username, t1.login_time login_time,
		 t1.login_ip login_ip
		 from login_record t1, user t2
		  where t1.user_id = t2.id order by id desc limit '. $count;
		$stmt = $db->prepare($sql);
		if($stmt->execute()) {
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
		} else {
			JoyDb::exception($stmt);
		}
		return $result;
	}
}