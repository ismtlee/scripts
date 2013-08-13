<?php
include_once 'env.php';

$s = time();
for($i= 1; $i <= 100; $i++) {
    $playerId = 'aadw'.$i;
    $player = Player::produce($playerId);
    if(!$player) {
	$player = Player::createPlayer($playerId, $playerId, 'snsgame');
        #$player->guide = Constants::PLAYER_GUIDE;
        $player->guide = 0;
        $player->update();    
        print_r($playerId . " created!\n");
    } else {
	$player->level = 2;
	$player->update();
 //       print_r($playerId." already created!\n");
    }
}
$e = time();
print_r($e - $s);
