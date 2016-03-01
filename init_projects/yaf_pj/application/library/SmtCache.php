<?php
/**
 * 
 * 封装Cache的操作
 *
 * Use PHP 5.3.0 or newer
 *
 * @package		Library
 * @author		Smart Lee <ismtlee@gmail.com>
 * @copyright	Copyright (c) 2008 - 2016, Linkerboom, Inc.
 * @since		Version 2.0
 * @filesource
 */
// ------------------------------------------------------------------------
/**
 * 
 * JoyCache
 *
 * 封装Cache的操作
 * 
 * @package Library
 * @author Smart Lee <ismtlee@gmail.com>
 * @version $Revision 2.0 2012-11-19 上午9:10:16
 * @see https://github.com/nicolasff/phpredis
 */
class JoyCache {
	// lifetime definition.
	const FOREVER = 0;
	const DAY = 86400;
	const HALF_DAY = 43200;
	const SHORT = 180;
	const NORMAL = 480;
	const LONG = 600;

    // result code definition.
    const RES_NOTFOUND = 13;
    const RES_SUCCESS = 0;

	private static $instance;
	private $cache;

	/**
	 * @see https://github.com/nicolasff/phpredis
	 * @return Redis
	 */
	public static function getInstance() {
		if (self::$instance === null) {
			self::$instance = new JoyCache();
		}
		return self::$instance;
	}
	
	private function __construct() {
		$this->cache = new Redis();
		$config = new Yaf_Config_Ini(CONFIG_INI, 'product');
		$this->cache->connect($config->cache->uri, $config->cache->port,$config->cache->timeout);
// 		$this->cache->setOption(Redis::OPT_SERIALIZER, Redis::SERIALIZER_IGBINARY);
	}
	
	/**
	 * Set the string value in argument as value of the key.
	 * @param string $key
	 * @param string $value
	 * @param int $lifetime seconds.
	 * @return bool: true when success.
	 */
	public function set($key, $value, $lifetime=0) {
		if (is_array($value)){
			$value = json_encode($value);
		}
		if($lifetime == 0) {
			return $this->cache->set($key, $value);
		}
		return $this->cache->setex($key, $lifetime, $value);
	}
	
	/**
	 * Adds a value to the hash stored at key. If this value is already in the hash, FALSE is returned.
	 * 
	 * @param string $key
	 * @param string $subKey
	 * @param string $value
	 * @param int $lifetime
	 * @return long 1 if value didn't exist and was added successfully, 0 if the value was already present and was replaced, FALSE if there was an error.
	 */
	public function hSet($key, $subKey, $value, $lifetime = 0) {
		if (is_array($value)){
			$value = json_encode($value);
		}
		$rs = $this->cache->hSet($key, $subKey, $value);
		$lifetime > 0 && $this->cache->setTimeout($key, $lifetime);
		return $rs;
	}
	
	/**
	 * Gets a value from the hash stored at key. If the hash table doesn't exist, or the key doesn't exist, FALSE is returned.
	 * @param string $key
	 * @param string $subKey
	 * @return string
	 */
	public function hGet($key, $subKey) {
		$data = $this->cache->hGet($key, $subKey);
		$data_temp = json_decode($data,true);
		if ($data_temp){
			$data = $data_temp;
		}
		return $data;
	}
	
	/**
	 * Removes a value from the hash stored at key. If the hash table doesn't exist, or the key doesn't exist, FALSE is returned.
	 * @param string $key
	 * @param string $subKey
	 * @return bool
	 */
	public function hDel($key, $subKey) {
		return $this->cache->hDel($key, $subKey);
	}
	
	public function hDelAll($key)
	{
		return $this->cache->del($key);
	}
	/**
	 * Returns the whole hash, as an array of strings indexed by strings.
	 * @param string $key
	 * @return array
	 */
	public function hGetAll($key) {
		return $this->cache->hGetAll($key);
	}
	
	/**
	 * Adds the string value to the head (left) of the list. Creates the list if the key didn't exist. If the key exists and is not a list, FALSE is returned.
	 * @param string $key
	 * @param string $value
	 * @return long The new length of the list in case of success, FALSE in case of Failure.
	 */
	public function lPush($key, $value) {
		if (is_array($value)){
			$value = json_encode($value);
		}
		return $this->cache->lPush($key, $value);
	}
	
	/**
	 * Return and remove the first element of the list.
	 * @param string $key
	 * @return string STRING if command executed successfully BOOL FALSE in case of failure (empty list)
	 */
	public function lPop($key) {
		return $this->cache->lPop($key);
	}
	
	/**
	 * Adds the string value to the tail (right) of the list. Creates the list if the key didn't exist. If the key exists and is not a list, FALSE is returned.
	 * @param string $key
	 * @param string $value
	 * @return long The new length of the list in case of success, FALSE in case of Failure.
	 */
	public function rPush($key, $value) {
		if (is_array($value)){
			$value = json_encode($value);
		}
		return $this->cache->rPush($key, $value);
	}
	
	/**
	 * Returns and removes the last element of the list.
	 * @param string $key
	 * @return string if command executed successfully BOOL FALSE in case of failure (empty list).
	 */
	public function rPop($key) {
		return $this->cache->rPop($key);
	}
	
	/**
	 * Returns the specified elements of the list stored at the specified key in the range [start, end]. start and stop are interpretated as indices: 0 the first element, 1 the second ... -1 the last element, -2 the penultimate ...
	 * @param string $start
	 * @param string $end 
	 * @return array  containing the values in specified range.
	 */
	public function lRange($key, $start, $end) {
		// lRange('key', 0, -1) get the all elements.
		return $this->cache->lRange($key, $start, $end);
	}
	
	/**
	 * Get the value related to the specified key.
	 * @param string $key
	 * @return string|bool: If key didn't exist, FALSE is returned. 
	 * 		Otherwise, the value related to this key is returned.
	 */
	public function get($key) {
		$data = $this->cache->get($key);
		$data_temp = json_decode($data,true);
		if ($data_temp){
			$data = $data_temp;
		}
		if ($data == "[]"){
			return null;
		}
		return $data;
	}
	
	/**
	 * Remove specified key.
	 * @param string $key
	 * @return int: 1 success.
	 */
	public function delete($key) {
		return $this->cache->delete($key);
	}
	/**
	 * 
	 * @
	 * @
	 */
	public function hKeys($key) {
		return $this->cache->hKeys($key);
	}
	
	/**
	 * Verify if the specified key exists.
	 * @param string $key
	 * @return bool: If the key exists, return TRUE, otherwise return FALSE.
	 */
	public function exists($key) {
		return $this->cache->exists($key);
	}
	
	/**
	 * Increment the number stored at key by one. If the second argument is filled, it will be used as the integer value of the increment.
	 * @param string $key
	 * @param string $value value that will be added to key, default is one.
	 * @return int: The new value.
	 */
	public function incr($key, $value = 1) {
		return $this->cache->incr($key);
	}
	
	/**
	* Decrement the number stored at key by one. If the second argument is filled, it will be used as the integer value of the decrement.
	* @param string $key
	* @param string $value value that will be substracted to key, default is one.
	* @return int: The new value.
	*/
	public function decr($key, $value = 1) {
		return $this->cache->decr($key);
	}
	
	/**
	* Remove specified keys.
	* @param array $keys
	* @return long: Number of keys deleted.
	*/
	public function delMulti(array $keys) {
		return $this->cache->delete($keys);
	}
	
	/**
	 * Get the values of all the specified keys. If one or more keys dont exist, the array will contain FALSE at the position of the key.
	 * @param array $keys
	 * @return array:Array containing the values related to keys in argument.
	 */
	public function getMulti(array $keys) {
		return $this->cache->mget($keys);
	}
	
	public function info(){
		return $this->cache->info();
	}
	
	/**
	 * Sets an expiration date (a timeout) on an item.
	 * @param string $key
	 * @param int $expire_time 
	 * @return bool: TRUE in case of success, FALSE in case of failure.
	 */
	public function setExpireTime($key, $expire_time) {
		return $this->cache->setTimeout($key, $expire_time);
	}

    public function setTimeout($key, $expire_time) {
        return $this->cache->setTimeout($key, $expire_time);
    }
	
	public function getLastTime($key){
		return $this->cache->ttl($key);
	}
}
