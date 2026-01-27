function DamageScript(dmg){
	
	hp-=dmg;
	invulnerable = true;
	alarm[0] = 45;
	
	if (hp<=0) {
		hp = 0;
		dead = true;
	}
}