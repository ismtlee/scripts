<?php
$AmazonSecretKey = "ppttbt9HZ2frqz0uwVfJ5uCX2WuAwv2MN43jObdl";
$start_instance= 
"GET
ec2.us-west-2.amazonaws.com
/
AWSAccessKeyId=AKIAIM7X2JITJUOYDXPA&Action=StartInstances&InstanceId.1=i-f64073c4&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2014-04-01T15%3A19%3A30&Version=2013-02-01";

$stop_instance = 
"GET
ec2.us-west-2.amazonaws.com
/
AWSAccessKeyId=AKIAIM7X2JITJUOYDXPA&Action=StopInstances&InstanceId.1=i-f64073c4&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2014-04-01T15%3A19%3A30&Version=2013-02-01";

$des_instance = 
"GET
ec2.us-west-2.amazonaws.com
/
AWSAccessKeyId=AKIAIM7X2JITJUOYDXPA&Action=DescribeInstances&Filter.1.Name=instance-id&Filter.1.Value.1=i-f64073c4&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2014-04-01T15%3A19%3A30&Version=2013-02-01";

$data = array('start_instance'=>$start_instance,
  'stop_instance' => $stop_instance,
	'des_instance' => $des_instance);

foreach($data as $key => $e) {
	$Sig = base64_encode(hash_hmac('sha256', $e, $AmazonSecretKey, true));
  #echo 'http://'.$e.'&Signature='. urlencode($Sig);
  echo  $key.'='.urlencode($Sig);
  echo "\n";
}
?>
