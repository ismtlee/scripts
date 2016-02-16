<?php

class SmtUtil{
	/*
	 * 获得访问者IP
	 */
	public static function getIp() {
		if(isset($_COOKIE['Real_IP'])) {
			$ip = $_COOKIE['Real_IP'];
		} else if(getenv('HTTP_X_FORWARDED_FOR')) {
			$ip = getenv("HTTP_X_FORWARDED_FOR");
		} else if(getenv("HTTP_CLIENT_IP")) {
			$ip = getenv("HTTP_CLIENT_IP");
		} else {
			$ip = getenv("REMOTE_ADDR");
		}
		return $ip;
	}

	public static function getSvrIp() {
		return gethostbyname($_SERVER["SERVER_NAME"]);
	}

	/**
	 * 取得系统时间
	 * @param $showInt 1|0 13位，精确至毫秒|String
	 * @return unknown_type
	 */
	public static function getSysTime($showInt = false) {
		if ($showInt) {
			$rs = microtime(1);
			return intval($rs*1000);
		}
		$now = date("Y-m-d H:i:s");
		return $now;
	}

	/**
	 * 取得规定格式的时间。
	 * @param $int_time
	 * @return string
	 */
	public static function getTime($int_time) {
		return date("Y-m-d H:i:s", $int_time);
	}

	/**
	 * 两个时间的天数差。
	 * @param $date1
	 * @param $date2 null 表示今天
	 * @return int 天数
	 */
	public static function getDateDiff($date1, $date2 = null) {
		$date1 = strtotime(date("Y-m-d", strtotime($date1)));
		if (!$date2) {
			$date2 = strtotime(date("Y-m-d"));
		} else {
			$date2 = strtotime(date("Y-m-d", strtotime($date2)));
		}
// 		return round(abs($date2 - $date1)/86400);
		return round(($date2 - $date1)/86400);
	}

	/**
	 * 两个时间(整型)的天数差。
	 * @param $int_date1 秒
	 * @param $int_date2 秒
	 * @return unknown_type
	 */
	public static function getDayDiff($int_date1, $int_date2 = null) {
		$int_date1 = strtotime(date("Y-m-d", $int_date1));
		if (!$int_date2) {
			$int_date2 = strtotime(date("Y-m-d"));
		} else {
			$int_date2 = strtotime(date("Y-m-d", $int_date2));
		}
		return round(abs($int_date1 - $int_date2)/86400);
	}

	/**
	 * 两个时间的时差.
	 * @param $time1
	 * @param $time2 null 表示今天凌晨
	 * @return unknown_type
	 */
	public static function getTimeDiff($time1, $time2 = null) {
		if (!$time2) {
			$time2 = "0:0";
		}
		return strtotime($time1) - strtotime($time2);
	}

	/**
	 * 当前时刻是不是在所规定的区间
	 * @param unknown_type $begin_time
	 * @param unknown_type $end_time
	 */
	public static function timeAmong($begin_time, $end_time) {
		$int_now = time();
		if ($int_now > strtotime($begin_time)
		&& $int_now < strtotime($end_time)) {
			return true;
		}
		return false;
	}
	/**
	 * 按要求格式化时间 （今天和昨天显示文字）
	 * @param $int_time
	 */
	public static function formatTime_need($int_time){
		$t = self::getDayDiff($int_time);
		if($t == 0){
			return '今天 '.date("H:i:s",$int_time);
		}
		if($t == 1){
			return '昨天 '.date("H:i:s",$int_time);
		}
		return self::getTime($int_time);
	}
	/**
	 * 获取当天的开始和结束时间戳
	 */
	public static function getBegainAndEndOfDay(){
		$year = date("Y");
		$month = date("m");
		$day = date("d");
		$dayBegin = mktime(0,0,0,$month,$day,$year);//当天开始时间戳
		$dayEnd = mktime(23,59,59,$month,$day,$year);//当天结束时间戳
		return array($dayBegin,$dayEnd);
	}
	/**
	 * 返回一个概率数组的索引
	 * @param $prob_array 概率数组。该数组的索引通常都有特定的含义。
	 * @return int
	 */
	public static function getKeyByProbArray($prob_array, $max = 100) {
		$rand = rand(1, $max);
		$min = 1;
		foreach ($prob_array as $key => $e) {
			if($rand >= $min && $rand < ($max = $min + $e)) {
				return $key;
			}
			$min = $max;
		}
	}
	/**
	 * 获得关联数组中某个属性=$id的数量
	 * @param  $array 数组
	 * @param  $attr 属性
	 * @param  $id  数值
	 */
	public static function getNumArray($array,$attr,$id){
		$total=0;
		foreach ($array as $m){
			if($m[$attr]==$id){
				$total++;
			}
		}
		return $total;
	}

	/**
	 * 从一个数组中随机取出指定数量的元素。
	 * @param array $input
	 * @param $num
	 * @return array
	 */
	public static function getRandArrayElements(array $input, $num = 1) {
		$num > ($len = count($input)) && $num = $len;
		$keys = array_rand($input, $num);
		if ($num == 1) {
			return array($keys=>$input[$keys]);
		}
		foreach ($keys as $e) {
			$output[$e] = $input[$e];
		}
		return $output;
	}
	/**
	 * 从一个数组中随机取出单个元素，并返回该元素的值(不关注下标，默认返回单个元素)。
	 * @param array $arr
	 * @return elements  or array
	 */
	public static function getRandMemberByArray(array $input, $num = 1) {
		$num > ($len = count($input)) && $num = $len;
		$keys = array_rand($input, $num);
		if ($num == 1) {
			return $input[$keys];
		}
		foreach ($keys as $e) {
			$output[] = $input[$e];
		}
		return $output;
	}

	/**
	 * 概率
	 * @param $num 分子值
	 * @param $type  0表示百分制，1表示千分制
	 * @return boolean
	 */
	public static function prob($num, $type = 0) {
		if ($type == 0) {
			if (rand(1, 100) <= $num)
			return true;
		} else if ($type == 1) {
			if (rand(1, 1000) <= $num)
			return true;
		}
		return false;
	}

	/**
	 * 概率
	 * @param $decimal
	 * @return boolean
	 */
	public static function probility($decimal) {
		$num = $decimal * 10000;
		if(rand(1, 10000) <= $num) {
			return true;
		}
		return false;
	}

	//public static function json_encode($value) {
	//	return json_encode($value);
	//}

	//public static function json_decode($json) {
	//	return json_decode($json, true);
	//}

	public static function serialize($value){
		return igbinary_serialize($value);
	}

	public static function unserialize($value){
		return igbinary_unserialize($value);
	}
	/**
	 * 数组取反
	 * @param $array
	 * @return array
	 */
	public static function array_negative($array) {
		foreach ($array as &$e) {
			$e = -$e;
		}
		return $array;
	}

	public static function explode($delimiter, $str) {
		if(!$str) {
			return null;
		}
		return explode($delimiter, $str);
	}

	/**
	 * 产生随机字符
	 * @param $length
	 * @return string
	 */
	public static function random_str($length) {
		if($length > 0) {
			$str = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
			$tmp = '';
			for($i=0; $i<$length; $i++) {
				$r = rand(0,strlen($str)-1);
				$tmp .= $str[$r];
			}
			return $tmp;
		}
	}

	/**
	 * 格式化时间
	 * @param $old_time
	 * @return string
	 */
	public static function format_time($old_time) {
		$curr = self::getSysTime(true);
		$old_time = strtotime($old_time);
		$str = '';
		$time = ($curr-$old_time)/3600;
		if($time > 24) {
			$str = date('m月d日 H:i',$old_time);
		}
		else {
			$str = date('H:i',$old_time);
		}
		return $str;
	}

	/**
	 *
	 * @return unknown_type
	 */
	public static function send_mail() {

	}

	/**
	 * 根据时间的先后顺序排序数组
	 * @param $array1
	 * @param $array2
	 * @return array
	 */
	public static function cmp_array($array1,$array2) {
		$array = array_merge($array1,$array2);
		for($i = 0; $i < count($array); $i++) {
			for($j = $i+1; $j < count ( $array ); $j ++) {
				if ($array [$i] ['send_time'] < $array [$j] ['send_time']) {
					$tmp = $array [$j];
					$array [$j] = $array [$i];
					$array [$i] = $tmp;

				}
			}
		}
		return $array;
	}

	/**
	 * 过滤敏感字符
	 * @param $str
	 * @return string | false
	 */
	public static function filter_str($str) {
		include_once 'str.php';
		foreach($arr as $e) {
			if(@eregi($e,$str)) {
				return $e;
			}
		}
		return false;
	}

	/**
	 * 删除给定
	 * @param $needle
	 * @param $arr
	 * @return unknown_type
	 */
	public static function array_remove($needle, array &$arr) {
		foreach ($arr as $key=>$e) {
			if ($e == $needle) {
				unset($arr[$key]);
			}
		}
	}

	/**
	 * 随机一个不等于$exclude的数字
	 * @param int $min
	 * @param int $max
	 * @param int $exclude [$min, $max]
	 */
	public static function rand($min, $max, $exclude = 0) {
		/*
		 if (!$exclude
		 || $exclude < $min
		 || $exclude > $max
		 || $min > $max) {
			return rand($min, $max);
			}
			if (self::prob(50)) {
			return rand($min, $exclude - 1);
			}
			return rand($exclude + 1, $max);
			*/
		if (!$exclude
		|| $exclude < $min
		|| $exclude > $max) {
			return rand($min, $max);
		}
		if ($exclude == $min) {
			return rand($min + 1, $max);
		}
		if ($exclude == $max) {
			return rand($min, $max - 1);
		}
		if (self::prob(50)) {
			return rand($min, $exclude - 1);
		}
		return rand($exclude + 1, $max);
	}
	/**
	 * 二维数组排序，类似于 order by ...
	 * @param array $ArrayData
	 * @param $KeyName 例如 $KeyName 值为  "id","SORT_ASC","SORT_STRING","name","SORT_ASC"....	 *
	 *
	 * 排序顺序标志：
	 * SORT_ASC - 按照上升顺序排序
	 * SORT_DESC - 按照下降顺序排序
	 * 排序类型标志：
	 * SORT_REGULAR - 将项目按照通常方法比较
	 * SORT_NUMERIC - 将项目按照数值比较
	 * SORT_STRING - 将项目按照字符串比较
	 */
	public static function multisortArray($ArrayData,$KeyName){
		if(!is_array($ArrayData)){
			return $ArrayData;
		}
		// Get args number.
		$ArgCount = func_num_args();
		// Get keys to sort by and put them to SortRule array.
		for($I = 1;$I < $ArgCount;$I ++){
			$Arg = func_get_arg($I);
			if(substr($Arg,0,5) != 'SORT_'){
				$KeyNameList[] = $Arg;
				$SortRule[] = '$'.$Arg;
			} else {
				$SortRule[] = $Arg;
			}
		}
		// Get the values according to the keys and put them to array.
		foreach($ArrayData AS $Key => $Info){
			foreach($KeyNameList AS $KeyName){
				${$KeyName}[$Key] = $Info[$KeyName];
			}
		}
		// Create the eval string and eval it.
		$EvalString = 'array_multisort('.join(",",$SortRule).',$ArrayData);';
		eval ($EvalString);
		return $ArrayData;
	}

	/**
	 * "hello_kitty" -> "Hello_Kitty"
	 */
	public static function ucwords_all($str) {
		$str_ar = explode('_', $str);
		foreach ($str_ar as &$e) {
			$e = ucwords($e);
		}
		$str = implode('_', $str_ar);
		return $str;
	}

	/**
	 * 取得目录下所有文件
	 * @param String $dir
	 * @param String $extension ex: xml or js etc.
	 */
	public static function files($dir, $extension = null) {
      $files = array();
      if(!is_dir($dir)) {
          return $files;
      }
      $handle = opendir($dir);
      if($handle) {
        while(false !== ($file = readdir($handle))) {
          if ($file != '.' && $file != '..') {
            $filename = $dir . "/"  . $file;
            if(is_file($filename)) {
              if($extension) {
                if(pathinfo($filename, PATHINFO_EXTENSION) == $extension) {
                  $files[] = $filename;
                }
              } else {
                $files[] = $filename;
              }
            }else {
               $files = array_merge($files, self::files($filename, $extension));
            }
          }
        }
        closedir($handle);
      }
      return $files;
	}
	/**
	 *
	 * Enter description here ...
	 * @param unknown_type $file
	 */
	public static function file_extension($file) {
	  return pathinfo($file, PATHINFO_EXTENSION);
	}

	public static function returnValue($num_1,$num_2,$operator){
		$op = array('==', '>=', '>', '<', '<=');
		if(!in_array($operator, $op)) {
			return false;
		}
		if(!$num_1 ||!$num_2) {
			return false;
		}
		if(self::is_date($num_1)) {
			$num_1 = strtotime($num_1);
		}
		if(self::is_date($num_2)) {
			$num_2 = strtotime($num_2);
		}
		
// 		error_log("begin..\n");
// 		error_log("num1:". $num_1);
// 		error_log("\n");
// 		error_log("num2:".$num_2);
// 		error_log("\n");
// 		error_log("op:". $operator);
// 		error_log("\n");
		
		eval("\$value = '$num_1' $operator '$num_2';");
		return $value;
	}
	
	/**
	 * 匹配
	 * 0000-00-00,0000/00/00,0000-00-00 00,0000/00/00 00,0000-00-00 00:00,0000/00/00 00:00,0000-00-00 00:00:00,0000/00/00 00:00:00
	 */
	public static function is_date($time) {
		$reg = "/^[0-9]{4}(\-|\/)[0-9]{1,2}(\\1)[0-9]{1,2}(|\s+[0-9]{1,2}(:[0-9]{1,2}){0,2})$/";
		if (preg_match($reg,$time)){
			return true;
		}
		return false;
	}
}
