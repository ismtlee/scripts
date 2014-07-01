<?php
  $f = fopen("user.txt", "w");
  for($i = 1; $i <= 2000; $i++) {
	fputs($f, 'wm'.$i."\n");
  }
  fclose($f);
?>
