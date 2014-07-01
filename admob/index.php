<?php

$USERNAME = 'letangadmob@gmail.com';
$PASSWORD = 'lt@147258369.';
$COOKIEJAR = 'cookies.txt';

$ch = curl_init();
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_COOKIEJAR, $COOKIEJAR);
curl_setopt($ch, CURLOPT_COOKIEFILE,$COOKIEJAR);
curl_setopt($ch, CURLOPT_HEADER, 0);  
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 120);
curl_setopt($ch, CURLOPT_TIMEOUT, 120);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1); 
curl_setopt($ch, CURLOPT_URL, 
  #'https://accounts.google.com/ServiceLogin?hl=en&service=alerts&continue=http://www.google.com/alerts/manage');
  'https://accounts.google.com/ServiceLogin?service=admob&hl=en_US&continue=https://www.admob.com/home/login/google?&followup=https://www.admob.com/home/login/google?');
$data = curl_exec($ch);

$formFields = getFormFields($data);

$formFields['Email']  = $USERNAME;
$formFields['Passwd'] = $PASSWORD;
unset($formFields['PersistentCookie']);

$post_string = '';
foreach($formFields as $key => $value) {
    $post_string .= $key . '=' . urlencode($value) . '&';
}

$post_string = substr($post_string, 0, -1);

#curl_setopt($ch, CURLOPT_URL, 'https://accounts.google.com/ServiceLoginAuth');
curl_setopt($ch, CURLOPT_URL, 'https://accounts.google.com/ServiceLogin?service=admob&hl=en_US&continue=https://www.admob.com/home/login/google?&followup=https://www.admob.com/home/login/google?');
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);

$result = curl_exec($ch);
if($result === false) {
  echo 'Curl error:' . curl_error($ch);
}
$ch2 = curl_init();
curl_setopt($ch2, CURLOPT_URL, "http://zhcn.admob.com/my_sites/widgets/trends/data/?_dc=1346813721212");
curl_setopt($ch2, CURLOPT_HEADER, false);
curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch2, CURLOPT_COOKIEFILE, $COOKIEJAR);
echo curl_exec($ch2);
unlink($COOKIEJAR);
curl_close($ch2);
return;
if (strpos($result, '<title>Redirecting') === false) {
    die("Login failed");
    var_dump($result);
   return;
} else {
  return;
    curl_setopt($ch, CURLOPT_URL, 'http://www.google.com/alerts/manage');
    curl_setopt($ch, CURLOPT_POST, 0);
    curl_setopt($ch, CURLOPT_POSTFIELDS, null);

    $result = curl_exec($ch);

    var_dump($result);
}

function getFormFields($data)
{
    if (preg_match('/(<form.*?id=.?gaia_loginform.*?<\/form>)/is', $data, $matches)) {
        $inputs = getInputs($matches[1]);

        return $inputs;
    } else {
        die('didnt find login form');
    }
}

function getInputs($form)
{
    $inputs = array();

    $elements = preg_match_all('/(<input[^>]+>)/is', $form, $matches);

    if ($elements > 0) {
        for($i = 0; $i < $elements; $i++) {
            $el = preg_replace('/\s{2,}/', ' ', $matches[1][$i]);

            if (preg_match('/name=(?:["\'])?([^"\'\s]*)/i', $el, $name)) {
                $name  = $name[1];
                $value = '';

                if (preg_match('/value=(?:["\'])?([^"\'\s]*)/i', $el, $value)) {
                    $value = $value[1];
                }

                $inputs[$name] = $value;
            }
        }
    }

    return $inputs;
}
