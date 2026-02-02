function EnemyG(obj){

obj.ySpeed += obj.grav;

if !obj.onGround {
	
	if (obj.ySpeed<0) {
		obj.ySpeed*=0.5;
	}
}

if (obj.ySpeed>obj.termVelocity) {
	obj.ySpeed=obj.termVelocity
}

//y collision
Gravity(obj);

if obj.ySpeed==0 && place_meeting(obj.x, obj.y+1, oWall) {
	obj.onGround = true;
} else {
	obj.onGround = false;
}

obj.y+=obj.ySpeed
}