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
  $subject = "AutoSize_daily_report_".date("Ymd");
  $headers = "Reply-To: ".$from. "\r\n";
  $headers .= "Return-Path: ". $from. "\r\n";
  $headers .= "From: ". '<ihappytime@163.com>' . "\r\n";
  $headers .= "MIME-Version:1.0" ."\r\n";
  $headers .= "Content-type:text/html;charset=utf-8" . "\r\n";
  $headers .= "X-Priority: 1\r\n";
#  $headers .= "X-Mailer: PHP/" . phpversion() . "\r\n"; 
  mail($to,$subject,$content,$headers);
}

wrap_mail(query('select rp_date 日期, ad_client_id CID, ad_unit_name 广告单元, clicks 点击, earnings 收入, page_views PV, individual_ad_impressions 展示次数,  page_views_rpm 网页RPM,  individual_ad_impressions_rpm 广告RPM from admob_report.rp_adsense where ad_unit_name = "AutoSize4Smartlee" and DATEDIFF(NOW(), rp_date) <= 30 order by rp_date desc'), $msg);
#wrap_mail($revenue, $msg);
#$android_version = query('select version 安卓版本号, num 用户数 , created_at 日期 from  andplus_stat.android where  DATEDIFF(NOW(), created_at) <= 1');
#wrap_mail($android_version, $msg);
#$lang = query('select lang 语言, num 用户数 , created_at 日期 from  andplus_stat.lang where  DATEDIFF(NOW(), created_at) <= 1');
#wrap_mail($lang, $msg);


$msg .= '</body></html>';
#exit;


$to = "ilee@foxmail.com";
send_mail($to, $msg);

