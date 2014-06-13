<?php
#source 1: HT 2: PEK
if(isset($_REQUEST['from']) && $_REQUEST['from']) {
  $source = $_REQUEST['from'];
} else {
  $source = 2;
}
if(isset($_REQUEST['date']) && $_REQUEST['date']) {
  $date = $_REQUEST['date'];
} else {
  $date = date('Ymd' , strtotime('-1 day')); 
}
$file = "/logs/nginx/2014/promotion_$date";

$a = `awk '{print $2,$3,$7}' $file |sort |uniq -c`;
$a = explode("\n", $a);
foreach($a as $e) {
  $b = explode(" ", $e);
  if(count($b) == 7 && substr($b[4], -1) == $source) {
    $c = array('carrier' => $b[5], 
      'promotion' => $b[6],
      'total' => $b[3],
      'func' => $b[4]);
    $d[] = $c;
  }
}

foreach($d as &$e) {
  $e['ip'] = `grep ${e['carrier']} $file |grep ${e['promotion']} |grep ${e['func']}|awk '{print $1}'|sort -u|wc -l`; 
  $e['imei'] = `grep ${e['carrier']} $file |grep ${e['promotion']} |grep ${e['func']}|awk '{print $4}'|sort -u|wc -l`; 
  $e['imsi'] = `grep ${e['carrier']} $file |grep ${e['promotion']} |grep ${e['func']}|awk '{print $5}'|sort -u|wc -l`; 
  $e['uuid'] = `grep ${e['carrier']} $file |grep ${e['promotion']} |grep ${e['func']}|awk '{print $6}'|sort -u|wc -l`; 
}

print_r($d);
