// inputs
playerInputs();

//collision stuffs

//X
var _subpix = 0.5;

if place_meeting(x + xSpeed, y, oWall) {
	
	//closes all distance between player and wall:
	var _thing = _subpix*sign(xSpeed);
	while !place_meeting(x+_thing,y,oWall) {
		x+=_thing;
	}
	
	xSpeed=0;
}

x+=xSpeed;

//Y

//gravity
ySpeed+=grav;
if (ySpeed>termVelocity) {
	ySpeed = termVelocity
} 

//jump

if (zKeyReal&&place_meeting(x, y+1, oWall)) {
	ySpeed = jumpSpeed;
}

//die
var _subpix = 0.5;
if (place_meeting(x, y+ySpeed, oWall)) {
	
	//closes all distance between player and ceiling:
	var _thing = _subpix*sign(ySpeed);
	while !place_meeting(x,y+_thing,oWall) {
		y+=_thing;
	}
	
	ySpeed=0;
}

y+=ySpeed


