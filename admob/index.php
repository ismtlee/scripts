<?php
$post_data = array(
	'continue' => 'https://www.admob.com/home/login/google?',
	'followup' => 'https://www.admob.com/home/login/google?',
	'service' => 'admob',
	'dsh' => '2468179974661429234',
	'hl' => 'en_US',
	'GALX' => '5QwIZrOyHFc',
	'pstMsg' => 1,
	'dnConn' => '',
	'checkConnection' => '',
	'checkedDomains' => 'youtube',
	'timeStmp' => '',
  'secTok' => '',
	'Email' => 'letangadmob@gmail.com',
	'Passwd' => 'lt@147258369.',
	'signIn' => 'Sign+in',
  'PersistentCookie' => 'yes',
  'rmShown' => 1	
);

$cookie_jar = tempnam('./', 'cookie');
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, 'https://accounts.google.com/ServiceLogin?service=admob&hl=en_US&continue=https://www.admob.com/home/login/google?&followup=https://www.admob.com/home/login/google?');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post_data);
curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_jar);
echo curl_exec($ch);
curl_close($ch);
