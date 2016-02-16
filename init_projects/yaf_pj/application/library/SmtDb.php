<?php
class SmtDb {
	private static $conn = null;

	private static function init() {
		$opt = array (PDO::ATTR_PERSISTENT => true);
		$config = new Yaf_Config_Ini(CONFIG_INI, 'product');
		self::$conn = new PDO ($config->database->uri, 
			$config->database->username, $config->database->password, $opt);
    }

	/**
	 * @return PDO
	 */
	public static function getInstance() {
        if (self::$conn === null) {
            self::init();
        }
        return self::$conn;
    }

    static function exception($stmt) {
    	$info_array = $stmt->errorInfo();
//     	throw new Exception("PDO ERROR: " . $info_array[2]);
    	error_log("PDO ERROR: " . $info_array[2]);
    }
    
    
    //sample,  cannot called!
	/*    
    function insert() {
    	$conn = SmtDb::getInstance();
    	$sql = "insert into tab_name (column_1, column_2) values(?, ?)";
    	$stmt = $conn->prepare($sql);
    	$params = array(1, "a");
    	if($stmt->execute($params)) {
    		echo $conn->lastInsertId();//如果想取自增长id
    	} else {
    		SmtDb::exception($stmt);
    	}
    	
    }
    
	function update() {
		$conn = SmtDb::getInstance();
		$sql = "update tab_name set col1 = ?, col2 = ? where id = ?";
		$stmt = $conn->prepare($sql);
		$params = array(2, "b", 1);
		if($stmt->execute($params)) {
			return true;
		} else {
			SmtDb::exception($stmt);
		}
	}
	
	function query() {
		$sql = "select col1, col2 from tab_name where id = ? ";
		$conn = SmtDb::getInstance();
		$stmt = $conn->prepare($sql);
		$params = array(1);
		if($stmt->execute($params)) {
			//$result = $stmt->fetch(PDO::FETCH_ASSOC); //fetchOne
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC); //fetchAll
			print_r($result);
		} else {
			SmtDb::exception($stmt);
		}
			
	}
    
	public function delete() {
		$conn = SmtDb::getInstance();
		$sql = "delete from tab_name where id = ?";
		$stmt = $conn->prepare($sql);
		$params = array(1);
		if($stmt->execute($params)) {
			return true;
		} else {
			SmtDb::exception($stmt);
		}
	}
    */
}
