<?php
 
$COOKIEJAR = 'cookies.txt';

login();
$data = fetch();

print_r(json_decode($data, true));

function login() {
	$url = 'https://accounts.google.com/ServiceLogin?service=admob&hl=en_US&continue=https://www.admob.com/home/login/google?&followup=https://www.admob.com/home/login/google?';
  $USERNAME = 'letangadmob@gmail.com';
  $PASSWORD = 'lt@147258369.';
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
  curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
  curl_setopt($ch, CURLOPT_COOKIEJAR, $GLOBALS['COOKIEJAR']);
  curl_setopt($ch, CURLOPT_COOKIEFILE, $GLOBALS['COOKIEJAR']);
  curl_setopt($ch, CURLOPT_HEADER, 0);  
  curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
  curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 120);
  curl_setopt($ch, CURLOPT_TIMEOUT, 120);
  curl_setopt($ch, CURLOPT_FOLLOWLOCATION,1); 
  curl_setopt($ch, CURLOPT_URL, $url);
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
  
  #curl_setopt($ch, CURLOPT_URL, $url);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $post_string);
  
  $result = curl_exec($ch);
  if($result === false) {
    echo 'Curl error:' . curl_error($ch);
  }
}

function fetch() {
  $ch2 = curl_init();
  #curl_setopt($ch2, CURLOPT_URL, "http://zhcn.admob.com/my_sites/widgets/trends/data/?_dc=1346813721212");
  curl_setopt($ch2, CURLOPT_URL, "http://zhcn.admob.com/my_sites/widgets/revenue/data/?_dc=1346753157248");
  curl_setopt($ch2, CURLOPT_HEADER, false);
  curl_setopt($ch2, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch2, CURLOPT_COOKIEFILE, $GLOBALS['COOKIEJAR']);
  $data =  curl_exec($ch2);
  unlink($GLOBALS['COOKIEJAR']);
  curl_close($ch2);
  return $data;
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
