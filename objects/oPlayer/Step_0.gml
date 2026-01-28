//makes player front layer
depth = -10000;

//Inputs
playerInputs();

//Collision stuffs


//did you fall into a bottomless pit...
if (y>room_height && !dead) {
	HPScript(-9999);
}

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
Gravity(oPlayer);

if ySpeed==0 && place_meeting(x, y+1, oWall) {
	onGround = true;
} else {
	onGround = false;
}

y+=ySpeed



//skibtastic

if dead {
	canMove = false;
} else {
	if (instance_exists(oBossDoor)) {
    var door = instance_nearest(x, y, oBossDoor);

    if (door.state == "locking" || door.state == "closing") {  // only lock after door closes
        if (x > door.x + door.lock_distance) {
            canMove = false;
        } else {
            canMove = true;
        }
    } else if (door.state == "opening") {
        canMove = false;
    } else {
		canMove = true;
	}
} 
}







