<?php
class TypesModel extends ActiveRecord {
	public static function showList() {
		$list = TypesModel::all(null, false);
		foreach ($list as $e) {
			$rs[$e['name']] = $e['value'];
		}
		return $rs;
	}
}