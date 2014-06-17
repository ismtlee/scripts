<?php
include_once 'env.php';
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
  $b = explode(" ", trim($e));
  if(count($b) == 4 && substr($b[1], -1) == $source) {
    $c = array('carrier' => $b[2], 
      'promotion' => $b[3],
      'total' => $b[0],
      'func' => $b[1],
      'date' => $date);
    $d[] = $c;
  }
}
foreach($d as &$e) {
  #$e['ip'] = `grep ${e['carrier']} $file |grep ${e['promotion']} |grep ${e['func']}|awk '{print $1}'|sort -u|wc -l`; 
  $e['ip'] = `awk '{print $1, $2, "c="$3, "p="$7}'|grep c=${e['carrier']} $file |grep p=${e['promotion']} |grep ${e['func']}|awk '{print $1}'|sort -u|wc -l`; 
  $e['imei'] = `awk '{print $4, $2, "c="$3, "p="$7}'|grep c=${e['carrier']} $file |grep p=${e['promotion']} |grep ${e['func']}|awk '{print $1}'|sort -u|wc -l`; 
  $e['imsi'] = `awk '{print $5, $2, "c="$3, "p="$7}'|grep c=${e['carrier']} $file |grep p=${e['promotion']} |grep ${e['func']}|awk '{print $1}'|sort -u|wc -l`; 
  $e['uuid'] = `awk '{print $6, $2, "c="$3, "p="$7}'|grep c=${e['carrier']} $file |grep p=${e['promotion']} |grep ${e['func']}|awk '{print $1}'|sort -u|wc -l`; 
}
write2Excel($d, $date);


function writeHead($objActSheet) {
 $ledger_tabname = array(
     'date' => '日期',
     'func' =>'功能',
     'carrier' => '载体应用',
     'promotion' => '推广应用',
     'ip' => 'ip排重',
     'uuid' => 'uuid排重',
     'imei' => 'imei排重',
     'imsi' => 'imsi排重',
     'total' => '总请求数',
  );
  $tab_color = 'B2A1C7';
  $CHAR_ADD = 'A';
  foreach ($ledger_tabname as $e) {
    writeCell($objActSheet, $e, $CHAR_ADD++, 1, $tab_color);
  }
}

function writeData($objActSheet, $list) {
  $i = 2;
  $color = 'CCCCCC';
  foreach($list as $e) {
    $CHAR_ADD = 'A';
    writeCell($objActSheet, $e['date'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['func'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['carrier'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['promotion'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['ip'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['uuid'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['imei'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['imsi'], $CHAR_ADD++, $i, $color);
    writeCell($objActSheet, $e['total'], $CHAR_ADD++, $i, $color);
    $objActSheet->getColumnDimension($CHAR_ADD)->setAutoSize(true);
    ++$i;
  }
}

function write2Excel($list, $curtime) {
  $objPHPExcel = new PHPExcel();
  $objActSheet = initExcel($objPHPExcel);
  $CHAR_ADD = 'A';
  $title = "promotion";
  writeHead($objActSheet);
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

function writeCell($objActSheet, $value, $x, $y, $back_color) {
  $objActSheet->setCellValue($x.$y, $value);
  $objActSheet->getStyle($x.$y)->applyFromArray(
     array('fill' => array(
        'type' => PHPExcel_Style_Fill::FILL_SOLID,
        'color' => array('rgb' => $back_color))));
}

function initExcel($objPHPExcel) {
  $objPHPExcel->getProperties()->setCreator("Lee")
            ->setLastModifiedBy("Lee")
            ->setTitle("promotion")
            ->setSubject("promotion")
            ->setDescription("")
            ->setCategory("safety ledger");
  $objActSheet = $objPHPExcel->setActiveSheetIndex(0);
  $objActSheet->setTitle("promotion");
  return $objActSheet;
}
