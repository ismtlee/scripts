<?php
$AmazonSecretKey = "ppttbt9HZ2frqz0uwVfJ5uCX2WuAwv2MN43jObdl";
$Request = 
"GET
ec2.us-west-2.amazonaws.com
/
AWSAccessKeyId=AKIAIM7X2JITJUOYDXPA&Action=DescribeInstances&Filter.1.Name=instance-id&Filter.1.Value.1=i-f64073c4&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2013-04-01T15%3A19%3A30&Version=2013-02-01";
$Sig = base64_encode(hash_hmac('sha256', $Request, $AmazonSecretKey, true));
echo urlencode($Sig);
echo "\n";
?>
