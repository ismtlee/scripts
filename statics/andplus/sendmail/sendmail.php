<?php
require_once 'env.php';
define('DAY_TXT', '日期');
define('DAU_TXT', 'DAU');
define('DAU_ADD_TXT', '净增DAU');
define('REVU_TXT', '收入');
define('PKG_TXT', '包名');
$msg = '
<!DOCTYPE html>
<html>
<head>
<style>
.customers {
    font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
    width: 100%;
    border-collapse: collapse;
}

.customers td, #customers th {
    font-size: 1em;
    border: 1px solid #98bf21;
    padding: 3px 7px 2px 7px;
}

.customers th {
    font-size: 1.1em;
    text-align: left;
    padding-top: 5px;
    padding-bottom: 4px;
    background-color: #A7C942;
    color: #ffffff;
}

.customers tr.alt td {
    color: #000000;
    background-color: #EAF2D3;
}
</style>
</head>
<body>
';


function query($sql) {
  $conn = JoyDb::getInstance();
  $stmt = $conn->prepare($sql);
  $result = null;
  if($stmt->execute()) {
     $result = $stmt->fetchAll(PDO::FETCH_ASSOC); //fetchAll
   } else {
     JoyDb::exception($stmt);
   }
   return $result;
 }

function wrap_mail($data, &$msg) {
  $msg .= '<table class="customers">';
  $msg .= '<tr>';

  foreach($data[0] as $k=>$e) {
    $msg .= '<th>' . $k. '</th>';
  }
  $msg .= '</tr>';// table head end.
  foreach($data as $k=>$e) {
    if($k % 2 == 0) {
      $msg .= '<tr>';
    } else {
      $msg .= '<tr class="alt">'; 
    }
    foreach($e as $e1) {
      $msg .= '<td>';
      $msg .=  $e1;
      $msg .= '</td>';
    }
    $msg .= "</tr>\r\n"; // \r\n避免单行过长,邮件出现!
  }
  
  $msg .= '</table>';
  $msg .= "\r\n";
}

function send_mail($to, $content) {
  $from = 'ihappytime@163.com';
  $subject = "linkerboom_daily_report_".date("Ymd");
  $headers = "Reply-To: ".$from. "\r\n";
  $headers .= "Return-Path: ". $from. "\r\n";
  $headers .= "From: ". '<ihappytime@163.com>' . "\r\n";
  $headers .= "MIME-Version:1.0" ."\r\n";
  $headers .= "Content-type:text/html;charset=utf-8" . "\r\n";
  $headers .= "X-Priority: 1\r\n";
#  $headers .= "X-Mailer: PHP/" . phpversion() . "\r\n"; 
  mail($to,$subject,$content,$headers);
}

function dau_revenue() {
  $rs = null;
  $past_days = 30;
  $users = query('select   num '. DAU_TXT.',  date(subdate(created_at, 1))'. DAY_TXT.' from  andplus_stat.users where  DATEDIFF(NOW(), created_at) <= '. $past_days);
  for($i = count($users) - 1; $i >= 0; $i--) {
    $rp[$users[$i][DAY_TXT]] = $users[$i][DAU_TXT];
  } 
  $revenue = query('select  sum(earnings)'. REVU_TXT .',  rp_date '. DAY_TXT.' from admob_report.rp_admob where  DATEDIFF(NOW(), rp_date) <= '.$past_days .' group by rp_date');
  for($i = count($revenue) - 1; $i >= 0; $i--) {
    $rp1[$revenue[$i][DAY_TXT]] = $revenue[$i][REVU_TXT];
  }
  foreach($rp as $k => $e) {
    $rp3[DAY_TXT] = $k;
    $rp3[DAU_TXT] = $e;
    if(isset($rp1[$k])) {
      $rp3[REVU_TXT] = $rp1[$k];
    } else {
      $rp3[REVU_TXT] = 0;
    }
    $rs[] = $rp3;
  }
  return $rs; 
}

function package_rp() {
  $rs = null;
  $lastday = date('Y-m-d', strtotime('-1 day'));
  $sql1 = 'select pkg_name '. PKG_TXT.', num '. DAU_TXT. ' from andplus_stat.package where date(created_at) = "'. date('Y-m-d').'"';
  $sql2 = 'select pkg_name '. PKG_TXT.', num '. DAU_TXT. ' from andplus_stat.package where date(created_at) = "'.$lastday.'"';
  $list = query($sql1);
  $list2 = query($sql2);
  foreach($list as $e) {
    $newList[$e[PKG_TXT]] = $e;
  }
  foreach($list2 as $e) {
    $newList2[$e[PKG_TXT]] = $e;
  }
  foreach($newList as $k => $e) {
        if(isset($newList2[$k])) {
            $add = $e[DAU_TXT] - $newList2[$k][DAU_TXT];
        } else {
            $add = $e[DAU_TXT];
        }

        $rs[] = array(
          DAY_TXT => $lastday,
          PKG_TXT => $e[PKG_TXT],
          DAU_TXT => intval($e[DAU_TXT]),
          DAU_ADD_TXT => $add);
  }
   return $rs;
}

wrap_mail(dau_revenue(), $msg);
wrap_mail(query('select rp_date 日期, app_name 应用名称, ad_unit_name 广告单元, clicks 点击, earnings 收入, individual_ad_impressions_rpm rpm, individual_ad_impressions 广告展示次数, individual_ad_impressions_ctr 点击率 from admob_report.rp_admob where DATEDIFF(NOW(),  rp_date) <= 3 order by earnings desc'), $msg);
wrap_mail(package_rp(), $msg);
#wrap_mail($revenue, $msg);
#$android_version = query('select version 安卓版本号, num 用户数 , created_at 日期 from  andplus_stat.android where  DATEDIFF(NOW(), created_at) <= 1');
#wrap_mail($android_version, $msg);
#$lang = query('select lang 语言, num 用户数 , created_at 日期 from  andplus_stat.lang where  DATEDIFF(NOW(), created_at) <= 1');
#wrap_mail($lang, $msg);


$msg .= '</body></html>';
#exit;


$to = "ilee@foxmail.com";
send_mail($to, $msg);
$to = "linkroom@602557203.com";
send_mail($to, $msg);
#broad.xie
$to = "305307330@qq.com";
send_mail($to, $msg);
