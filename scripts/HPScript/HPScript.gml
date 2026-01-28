function HPScript(num){
	
	if (num<0) {
		oPlayer.hp+=num;
		oPlayer.invulnerable = true;
		oPlayer.canMove = false;
	
		if (oPlayer.hp<=0) {
			oPlayer.hp = 0;
			oPlayer.dead = true;
			oPlayer.image_alpha = 0;
			oPlayer.alarm[2] = 120;
		} else {
			oPlayer.alarm[0] = 70;
			oPlayer.alarm[1] = 25;
		}
	}
	
	
}