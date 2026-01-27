function DamageScript(dmg){
	
	oPlayer.hp-=dmg;
	
	if (oPlayer.hp<=0) {
		oPlayer.hp = 0;
		oPlayer.dead = true;
	}
}