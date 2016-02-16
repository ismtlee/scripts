<?php
class UserModel extends ActiveRecord {
	public static function showList() {
		$db = JoyDb::getInstance();
		$sql = 'select t1.id id, t1.role role, t1.username username, t1.last_login_time last_login_time, 
		  t2.name department, t3.name company_name 
		  from (user t1 left join department t2 on t1.department_id = t2.id) 
		  left join company t3 on t1.company_id = t3.id 
		  order by id asc';
		$stmt = $db->prepare($sql);
		if($stmt->execute()) {
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
		} else {
			JoyDb::exception($stmt);
		}
		return $result;
		
		
	}
	
}