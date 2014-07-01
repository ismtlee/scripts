<?php
$AmazonSecretKey = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY";
$Request = 
"GET
elasticmapreduce.amazonaws.com
/
AWSAccessKeyId=AKIAIOSFODNN7EXAMPLE&Action=DescribeJobFlows&SignatureMethod=HmacSHA256&SignatureVersion=2&Timestamp=2011-10-03T15%3A19%3A30&Version=2009-03-31";
$Sig = base64_encode(hash_hmac('sha256', $Request, $AmazonSecretKey, true));
echo urlencode($Sig);
echo "\n";
?>
