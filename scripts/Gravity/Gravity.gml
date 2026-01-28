function Gravity(obj){
	if (place_meeting(obj.x, obj.y+obj.ySpeed, oWall)) {
	
	//closes all distance between player and y:
	var _thing = 0.5*sign(obj.ySpeed);
	while !place_meeting(obj.x,obj.y+_thing,oWall) {
		obj.y+=_thing;
	}
	
	if (obj.object_index==oPlayer) {
		if (ySpeed<0) {
			jumpHoldTime=0;
		}
	}
	obj.ySpeed=0;
}

}