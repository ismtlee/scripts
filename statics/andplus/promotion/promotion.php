<?php
include_once 'env.php';
#source 1: HT 2: PEK
if(isset($_REQUEST['from']) && $_REQUEST['from']) {
  $source = $_REQUEST['from'];
} else {
  $source = 2
}
#func open|yes
if(isset($_REQUEST['func']) && $_REQUEST['func']) {
  $func = $_REQUEST['func'];
} else {
  $func = 'open'; 
}
$func_grep = "/$func/?";
#date
$last_day = `date -d '-1 day' +%Y%m%d`;
$file = '/logs/nginx/2014/promotion_'.$last_day;
if(isset($_REQUEST['date']) && $_REQUEST['date']) {
  $date = $_REQUEST['date'];
} else {
  $date = $last_day; 
}
if(!check_date($date)) {
  exit('wrong date!');
}

$a = `awk '{print $2,$3,$7}' /logs/nginx/2014/promotion_20140612|sort |uniq -c`;
$a = explode("\n", $a);

$total_requests = `grep $funs$source $file|wc -l`;

$list = array();
foreach ($accounts as $usr) {
	$rs = false;
	$count = 0;
	while(!$rs && $count++ < $retry_times) {
		$rs = fetch_from_admob(trim($usr['email']), trim($usr['password']), trim($usr['client_key']), $start_date, $end_date);
	}
	if($rs) {
		$list = array_merge($list, $rs);
	}
			
	
}

foreach ($list as $e) {
  #$new_list[$e['date'] = array('name' => $e['name'], 'revenue' => $e['revenue']);
}
$list = wrapList($list);
$sum = getSum($list);
#print_r($sum);

$curtime = date('Ymd');
#print_r($list);
write2Excel($list, $sum, $curtime);

function check_date($date) {
  if (preg_match("/^[0-9]{4}(0[1-9]|1[0-2])([0-9]{2})$/",$date)) {
        return true;
  }else{
        return false;
  }
}

function fetch_from_admob($email, $pwd, $key, $start_date, $end_date) {
	try {
		$api = new AdMobApiClient($key);
		$api->login($email, $pwd);
		$appList = $api->getData('site', 'search', array(), false);
		foreach ($appList as $app) {
			$site_id_array[] = $app['id'];
			$appName[$app['id']] = $app['name'];
		}
		#print_r($appName);
		$params = array(
				'site_id' => $site_id_array,
			    'start_date' => $start_date,
			    'end_date' => $end_date,
			    'time_dimension' => AdMobApiClient::DIMENSION_DAY,
			    'object_dimension' => AdMobApiClient::OBJECT_SITE
		);
		$stats = $api->getData('site', 'stats', $params, false);

		foreach($stats as &$e) {
		  $e['name'] = $appName[$e['site_id']];
		  $e['email'] = $email;
	        }
		/*

		for($i = 0; $i < count($appList); $i++) {
			$stats[$i]['url'] = $appList[$i]['url'];
			$stats[$i]['name'] = $appList[$i]['name'];
		} */

                #print_r($stats);
		return $stats;
	} catch (AdMobApiException $e) {
		// 		echo $e->getMessage();
	}
	return false;
}

function initExcel($objPHPExcel) {
  $objPHPExcel->getProperties()->setCreator("Lee")
            ->setLastModifiedBy("Lee")
            ->setTitle("station")
            ->setSubject("revenue")
            ->setDescription("")
            ->setCategory("safety ledger");
  $objActSheet = $objPHPExcel->setActiveSheetIndex(0);
  $objActSheet->setTitle("月收入");
  return $objActSheet;
}

function writeCell($objActSheet, $value, $x, $y, $back_color) {
  $objActSheet->setCellValue($x.$y, $value);  
  $objActSheet->getStyle($x.$y)->applyFromArray(
     array('fill' => array(
        'type' => PHPExcel_Style_Fill::FILL_SOLID,
        'color' => array('rgb' => $back_color))));
}

function writeHead($objActSheet, $list) {
 $ledger_tabname = array(
     'account' => '开发者/ADMOB/PAYPAL帐号',
     'name'=>'应用名称',
  );
  $tab_color = 'B2A1C7';
  $CHAR_ADD = 'A';
  foreach ($ledger_tabname as $e) {
    writeCell($objActSheet, $e, $CHAR_ADD++, 1, $tab_color);
  } 
  foreach($list as $e) {
    foreach($e as $k => $ee) {
      writeCell($objActSheet, substr($k, 5), $CHAR_ADD++, 1, $tab_color);
    }
    break;
  }
}

function writeSum($objActSheet, $sum) {
  $CHAR_ADD = 'A';
  $tab_color = 'CCCCCC';
  writeCell($objActSheet, '合', $CHAR_ADD++, 2, $tab_color);
  writeCell($objActSheet, '计', $CHAR_ADD++, 2, $tab_color);
  foreach($sum as $e) {
    writeCell($objActSheet, $e, $CHAR_ADD++, 2, $tab_color);
  }
}

function writeData($objActSheet, $list) {
  $i = 3;
  $old_email = '';
  $colors = array('CCCCCC', '999999');
  $color_index = 0;
  foreach($list as $e) {
    $CHAR_ADD = 'C';
    foreach($e as $ee) {
      if($CHAR_ADD == 'C') {
        if($old_email != $ee['email']) {
      	  $color_index = !$color_index;
	}
        $old_email = $ee['email'];
      } 
      writeCell($objActSheet, $ee['email'], 'A', $i, $colors[$color_index]);
      writeCell($objActSheet, $ee['name'], 'B', $i, $colors[$color_index]);
      writeCell($objActSheet, $ee['revenue'], $CHAR_ADD++, $i, $colors[$color_index]);
    }
    $objActSheet->getColumnDimension($CHAR_ADD)->setAutoSize(true);
    ++$i;
  }
}

function write2Excel($list, $sum, $curtime) {
  $objPHPExcel = new PHPExcel();
  $objActSheet = initExcel($objPHPExcel);
  $CHAR_ADD = 'A';
  $title = "admob_revenue";
  writeHead($objActSheet, $list);
  writeSum($objActSheet, $sum);
  writeData($objActSheet, $list);     

  header('Content-Type: application/vnd.ms-excel; charset=UTF-8');
  //文件名
  $ua = $_SERVER["HTTP_USER_AGENT"];
  $filename = "${title}_$curtime.xls";
  $encoded_filename = urlencode($filename);
  $encoded_filename = str_replace("+", "%20", $encoded_filename);

  if (preg_match("/MSIE/", $ua)) {
    header('Content-Disposition: attachment; filename="' . $encoded_filename . '"');
  } else if (preg_match("/Firefox/", $ua)) {
    header('Content-Disposition: attachment; filename*="utf8\'\'' . $filename . '"');
  } else {
    header('Content-Disposition: attachment; filename="' . $filename . '"');
  }

  header('Cache-Control: max-age=0');
  $objWriter = PHPExcel_IOFactory::createWriter($objPHPExcel, 'Excel5');
  $objWriter->save('php://output');
}

function getthemonth($date) {
  $firstday = date('Y-m-01', strtotime($date)); 
  $lastday = date('Y-m-d', strtotime("$firstday +1 month -1 day")); 
  return array($firstday, $lastday); 
} 

function wrapList($old_list) {
  foreach($old_list as $e) {
    $site_id = $e['site_id'];
    $list[$site_id][$e['date']] = array('name' => $e['name'], 'revenue' => $e['revenue'], 'email' => $e['email']);
  } 
  foreach($list as &$e) {
     ksort($e);  
  }
  return $list;
#  print_r($list); 
}

function getSum($list) {
  foreach ($list as $e) {
    foreach ($e as $k => $ee) {
  	if(isset($sum[$k])) {
	  $sum[$k] += $ee['revenue'];
	} else {
	  $sum[$k] = $ee['revenue'];
	}
    }
  }
  return $sum;
}
