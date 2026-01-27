function DamageScript(dmg){
	
	hp-=dmg;
	invulnerable = true;
	alarm[0] = 45;
	
	
	xSpeed = -60 * movDirection;
	
	
	if (hp<=0) {
		hp = 0;
		dead = true;
	}
}