function HPScript(num){
	
	if (num+oPlayer.hp>oPlayer.maxHP) {
		oPlayer.hp = oPlayer.maxHP;
	} else {
		oPlayer.hp+=num;
	}
	if (num<0) {
		oPlayer.invulnerable = true;
		oPlayer.invulTimer = 120;
		if (oPlayer.hp<=0) {
			oPlayer.hp = 0;
			oPlayer.dead = true;
			oPlayer.image_alpha = 0;
			oPlayer.alarm[2] = 120;
		} else {
			oPlayer.alarm[0] = 70;
			
		}
	}
	
}