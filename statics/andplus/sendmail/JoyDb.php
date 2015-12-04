<?php
class JoyDb {
	private static $conn = null;

	private static function init() {
		$opt = array (PDO::ATTR_PERSISTENT => true);
		$config = parse_ini_file(CONFIG_INI, true);
		self::$conn = new PDO ($config['database']['uri'], 
			$config['database']['username'], $config['database']['password'], $opt);
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
    
    
    //sample,  cannot callerd!
	/*    
    function insert() {
    	$conn = JoyDb::getInstance();
    	$sql = "insert into tab_name (column_1, column_2) values(?, ?)";
    	$stmt = $conn->prepare($sql);
    	$params = array(1, "a");
    	if($stmt->execute($params)) {
    		echo $conn->lastInsertId();//如果想取自增长id
    	} else {
    		JoyDb::exception($stmt);
    	}
    	
    }
    
	function update() {
		$conn = JoyDb::getInstance();
		$sql = "update tab_name set col1 = ?, col2 = ? where id = ?";
		$stmt = $conn->prepare($sql);
		$params = array(2, "b", 1);
		if($stmt->execute($params)) {
			return true;
		} else {
			JoyDb::exception($stmt);
		}
	}
	
	function query() {
		$sql = "select col1, col2 from tab_name where id = ? ";
		$conn = JoyDb::getInstance();
		$stmt = $conn->prepare($sql);
		$params = array(1);
		if($stmt->execute($params)) {
			//$result = $stmt->fetch(PDO::FETCH_ASSOC); //fetchOne
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC); //fetchAll
			print_r($result);
		} else {
			JoyDb::exception($stmt);
		}
			
	}
    
	public function delete() {
		$conn = JoyDb::getInstance();
		$sql = "delete from tab_name where id = ?";
		$stmt = $conn->prepare($sql);
		$params = array(1);
		if($stmt->execute($params)) {
			return true;
		} else {
			JoyDb::exception($stmt);
		}
	}
    */
}
