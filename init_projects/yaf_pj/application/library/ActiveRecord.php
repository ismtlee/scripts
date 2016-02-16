<?php
/**
 * 
 * CRUD
 *
 * PHP 5.3.0 or newer
 *
 * @package		Library
 * @author		Smart Lee <ismtlee@gmail.com>
 * @copyright	Copyright (c) 2008 - 2012, Smt, Inc.
 * @since		Version 2.0
 * @filesource
 */
// ------------------------------------------------------------------------
/**
 * 
 * ActiveRecord
 *
 * 封装db的crud操作。
 * 
 * @package Library
 * @author Smart Lee <ismtlee@gmail.com>
 * @version $Revision 2.0 2016/01/07 09:30:08 
 */
class ActiveRecord {
	/**
	 * Contains model values as column_name => value
	 *
	 * @var array
	 */
	private $attributes = array();
	
	/**
	 * Flag that determines if a call to save() should issue an insert or an update sql statement
	 *
	 * @var boolean
	 */
	private $__new_record = true;
	
	/**
	 * Flag whether or not this model's attributes have been modified since it will either be null or an array of column_names that have been modified
	 *
	 * @var array
	 */
	private $__dirty = null;
	
	public function __construct(array $attributes=array(), $instantiating_via_find=false, $new_record=true) {
		$this->__new_record = $new_record;
		if (!$instantiating_via_find) {
			$this->attributes = self::meta();	
			return;		
		}
		$this->attributes = $attributes;
	}
	
	public function __get($name) {
		if(array_key_exists($name, $this->attributes)) {
			return $this->attributes[$name];
		}
		throw new Exception("undefined proerty " . $name);
	}
	
	public function __set($name, $value) {
		if(array_key_exists($name, $this->attributes)) {
			$this->assign_attribute($name, $value);
			return;
		}
		throw new Exception("undefinded property " . $name);
	}
	
	public function assign_attribute($name, $value) {
		if(array_key_exists($name, $this->attributes)) {
			if (!$this->__dirty) {
				$this->__dirty = array();
			}
			$this->attributes[$name] = $value;
			$this->__dirty[$name] = true;
		}
	}
	
	public static function create($attributes) {
		$class_name = get_called_class();
		$model = new $class_name($attributes, true, true);
		if($model->save()) {
			return $model;
		}
		return null;
	}
	
	public function save() {
		return $this->__new_record ? $this->insert() : $this->update();
	}
	
	private function insert() {
		$count = count($this->attributes);
		if($count <= 0) {
			return false;
		}
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		
		$sql = "insert into ${tab_name} (";
		$values = "values (";
		foreach ($this->attributes as $key => $e) {
			$sql .= "${key},";
			$values .= "?,";
			$params[] = $e;
		}
		$sql = substr($sql, 0, -1);
		$values = substr($values, 0, -1);
		
		$sql = $sql . ") " . $values . ")";
		

		#echo $sql;


		$stmt = $conn->prepare($sql);
		if($stmt->execute($params)) {
			if (!isset($this->attributes['id']) || $this->attributes['id'] <= 0) {
				$this->attributes['id'] = $conn->lastInsertId();
			}
			$this->__new_record = false;
			return true;
		} else {
			SmtDb::exception($stmt);
		}
		return false;
	}
	
	private function update() {
		$count = count($this->__dirty);
		if($count <= 0 || count($this->attributes) <= 0) {
			return false;
		}
		
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		
		$sql = "update $tab_name set ";
		foreach ($this->__dirty as $key => $e) {
			$sql .= "$key=?,";
			$params[] = $this->attributes[$key];
		}
		$sql = substr($sql, 0, -1);
		$sql .= " where id = ?";
		
		$params[] = $this->attributes['id'];
		
		$this->reset_dirty();
		
		$stmt = $conn->prepare($sql);
		if($stmt->execute($params)) {
			return true;
		} else {
			SmtDb::exception($stmt);
		}
		return false;
	}
	
	public static function delete_all($conditions = null) {
		$id_list = self::id_list($conditions);
		if(!$id_list) {
			return 0;
		}
		return self::delete_many($id_list);
	}
	
	/**
	 * delete many record.
	 * @param $id_list
	 * @return int affected rows' count.
	 */
	public static function delete_many($id_list) {
		$cond = "id in(?";
		for($i = 1; $i < count($id_list); $i++) {
			$cond .= ',?';
		}
		$cond .= ")";
		
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		
		$sql = "delete from $tab_name where $cond";
		$stmt = $conn->prepare($sql);
		if($stmt->execute($id_list)) {
			return $stmt->rowCount();
		} else {
			SmtDb::exception($stmt);
		}
		
		return 0;
	}
	
	public function delete() {
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		
		$sql = "delete from $tab_name where id = ?";
		$stmt = $conn->prepare($sql);
		if($stmt->execute(array($this->attributes['id']))) {
			return true;
		} else {
			SmtDb::exception($stmt);
		}
		
		return false;
	}
	
	public function reset_dirty() {
		$this->__dirty = null;
	}
	
	public static function find($pk, $return_model = true) {
		if(is_array($pk)) {
			$cond = "id in(?";
			for($i = 1; $i < count($pk); $i++) {
				$cond .= ',?';
			}
			$cond .= ")";
			array_unshift($pk, $cond);
			return self::all(array('conditions' => $pk));
		} 
		
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		$sql = "select * from $tab_name where id = ?";
		$stmt = $conn->prepare($sql);
		if($stmt->execute(array($pk))) {
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
		} else {
			SmtDb::exception($stmt);
		}
		if(isset($result) && $result) {
			return $return_model ? new $class($result, true, false) : $result;
		}
		return null;
	}
	
	public static function update_by(array $where, array $new_value) {
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		$sql = "update $tab_name set ";
		foreach ($new_value as $key => $e) {
			$sql .= "$key=?,";
			$params[] = $e;
		}
		$sql = substr($sql, 0, -1) . ' where ';
		$i = 0;
		foreach($where as $key => $e) {
			$sql .= $i++ > 0 ? " and $key = ? " : " $key = ? ";
			$params[] = $e;
		}
		$stmt = $conn->prepare($sql);
		if($stmt->execute($params)) {
			return true;
		} else {
			SmtDb::exception($stmt);
		}
		return false;
	}
	
	/**
	* @param array $mixture
	*/
	public static function delete_by(array $mixture) {
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		$sql = "delete from $tab_name where ";
		$i = 0;
		foreach($mixture as $key => $e) {
			$sql .= $i++ > 0 ? " and $key = ? " : " $key = ? ";
			$param[] = $e;
		}
		$stmt = $conn->prepare($sql);
	
		if($stmt->execute($param)) {
			return true;
		} else {
			SmtDb::exception($stmt);
		}
		return false;
	}
	
	/**
	 * @param array $mixture
	 * @see ModelBase::produce_by()
	 */
	public static function find_by(array $mixture, $return_model = true) {
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		$sql = "select * from $tab_name where ";
		$i = 0;
		foreach($mixture as $key => $e) { 
			$sql .= $i++ > 0 ? " and $key = ? " : " $key = ? ";
			$param[] = $e;
		}
		$stmt = $conn->prepare($sql);
		
		if($stmt->execute($param)) {
			$result = $stmt->fetch(PDO::FETCH_ASSOC);
		} else {
			SmtDb::exception($stmt);
		}
		
		if(isset($result) && $result) {
			return $return_model ? new $class($result, true, false) : $result;
		}
		return null;
	}
	
	/**
	 * find all by conditions.
	 * @param $conditions 'conditions'
	 * 	'limit','offset','order','select',
	 * 	'group','having', 'joins' would come in future.
	 *  return an array that contains all objects,
	 * or an array that contains arrays when 'select' is set.
	 * @return  return null or association array.
	 */
	public static function all($conditions = null, $return_model = true) {
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$conn = SmtDb::getInstance();
		$content = null;
		
		if($conditions) {
			$select = isset($conditions['select']) ? $conditions['select'] : '*';
			$sql = "select $select from $tab_name ";
			
			if(isset($conditions['conditions'])) {
				$content = $conditions['conditions'];
				$sql .= " where $content[0] ";
				array_shift($content);	
			}
			
			if(isset($conditions['order'])) {
				$order = $conditions['order'];
				$sql .= " order by $order ";
			}
			
			if(isset($conditions['limit'])) {
				$limit = $conditions['limit'];
				$sql .= " limit  $limit ";
			}
		} else {
			$sql = "select * from $tab_name ";
		}
		$stmt = $conn->prepare($sql);
		if($stmt->execute($content)) {
			$result = $stmt->fetchAll(PDO::FETCH_ASSOC);
			if(isset($conditions['select'])||!$return_model) {
				return $result;
			}
			if($result) {
				foreach ($result as $e) {
					$list[] = new $class($e, true, false);
				}
				return $list;
			}
			
		} else {
			SmtDb::exception($stmt);
		}
		return null;
	}
	
	public static function meta() {
		$class = get_called_class();
		$tab_name = substr(strtolower($class), 0, -5);
		$sql = "show columns from $tab_name";
		$conn = SmtDb::getInstance();
		
		$stmt = $conn->prepare($sql);
		if($stmt->execute()) {
			$raw_column_data = $stmt->fetchAll(PDO::FETCH_ASSOC);
			foreach($raw_column_data as $array) {
				$attributes[$array['Field']] = $array['Default'];
			}
		} else {
			SmtDb::exception($stmt);
		}
		return $attributes;
	}
	
	static function exception($stmt) {
		$info_array = $stmt->errorInfo();
// 		throw new Exception("PDO ERROR: " . $info_array[2]);
		error_log("PDO ERROR: " . $info_array[2]);
	}
	
	/**
	 * do saveOnly() before save() can only save specify attributes.
	 * @param $only_save {$attr1_name:1, $attr2_name:2}
	 * @return void
	 */
	public function saveOnly($only_save, $update = false) {
		if (!isset($this->__dirty)) {
			return;
		}
		foreach ($this->__dirty as $key => $e) {
			if (isset($only_save[$key])) {
				continue;
			}
			unset($this->__dirty[$key]);
		}
		$this->save();
		if ($update) {
			$object = static::produce($this->id);
			foreach ($this->attributes as $key => &$e) {
				$e = $object->$key;
			}
		}
	}
	
	/**
	 * 
	 * @param $conditions
	 * @return null or array
	 */
	public static function id_list($conditions = null) {
		$conditions['select'] = 'id';
		$id_list = self::all($conditions);
		if(!$id_list) {
			return null;
		}
		foreach ($id_list as &$e) {
			$e = $e['id'];
		}
		return $id_list; 
	}
	
	public function has($attribute_name) {
		return isset($this->attributes[$attribute_name]);
	}
	
	public function serialize() {
		return json_decode(json_encode($this->attributes), false);
	}
	
	/**
	 * 
	 * @param array $clude 
	 * @param boolean $is_include 1 $clude为指定的属性集 0 $clude为排除的属性集。
	 * @return array 关联数组
	 */
	public function serializeToArray(array $clude = null, $is_include = true) {
		if(!$clude) {
			return $this->attributes;
		}
		
		if($is_include) {
			foreach ($clude as $e) {
				$result[$e] = $this->attributes[$e];
			}
		} else {
			$result = $this->attributes;
			foreach ($clude as $e) {
				unset($result[$e]);
			}
		}
		return $result;
	}
	
}
