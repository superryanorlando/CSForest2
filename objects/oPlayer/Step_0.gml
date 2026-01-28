//makes player front layer
depth = -10000;

//Inputs
playerInputs();

//Collision stuffs


//X
var _subpix = 0.5;

if place_meeting(x + xSpeed, y, oWall) {
	//slopes (say thanks basil)
	if !place_meeting(x+xSpeed, y-abs(xSpeed)-1, oWall) {
		while place_meeting(x+xSpeed, y, oWall) {
			y-=_subpix;
		}
		
	} else {
		if !place_meeting(x+xSpeed, y+abs(xSpeed)+1, oWall) {
		while place_meeting(x+xSpeed, y, oWall) {
			y+=_subpix;
		}
		} else {
			//closes all distance between player and wall:
			var _thing = _subpix*sign(xSpeed);
			while !place_meeting(x+_thing,y,oWall) {
				x+=_thing;
			}
	
			xSpeed=0;
		}
	}
}

//slopes pt2
if (ySpeed>=0) && !place_meeting(x+xSpeed, y+1, oWall) && place_meeting(x+xSpeed, y + abs(xSpeed)+1, oWall) {
	while !place_meeting(x+xSpeed, y+_subpix, oWall) {
			y+=_subpix;
		}
}


x+=xSpeed;


//Y

//gravity
ySpeed+=grav;
if (ySpeed>termVelocity) {
	ySpeed = termVelocity
} 

//jump

if (zKeyReal&&onGround) {
	ySpeed = jumpSpeed;
	jumpHoldTime = 10;
}


if (jumpHoldTime>0) {
	ySpeed=jumpSpeed;
	jumpHoldTime--;
}

if !zKey {
	jumpHoldTime=0;
	if (ySpeed<0) {
		ySpeed*=0.5;
	}
}

if (ySpeed>termVelocity) {
	ySpeed=termVelocity
}

//y collision
if (place_meeting(x, y+ySpeed, oWall)) {
	
	//closes all distance between player and y:
	var _thing = _subpix*sign(ySpeed);
	while !place_meeting(x,y+_thing,oWall) {
		y+=_thing;
	}
	
	if (ySpeed<0) {
		jumpHoldTime=0;
	}
	
	ySpeed=0;
}

if ySpeed==0 && place_meeting(x, y+1, oWall) {
	onGround = true;
} else {
	onGround = false;
}

y+=ySpeed



//pretty stuff
if (dead) {
    death_fade = min(death_fade + 0.02, 1);
}






