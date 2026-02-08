//makes player front layer
depth = -10000;

//Inputs
playerInputs();

// Apply friction/gravity to external velocity BEFORE movement math
vX = lerp(vX, 0, vDecel); 
vY = lerp(vY, 0, vDecel);
if (abs(vY) < 0.1) vY = 0;
if (abs(vX) < 0.1) vX = 0; // Snap to zero so lerp doesn't go forever

// Combine normal movement with external velocity
var _totalX = xSpeed + vX;
var _totalY = ySpeed + vY;

//Collision stuffs

//did you fall into a bottomless pit...
if (y-sprite_height>room_height && !dead) {
	HPScript(-9999);
}

if (rightKey) {
	image_xscale = -1;
} else if (leftKey) {
	image_xscale = 1;
}

//X
var _subpix = 0.5;

// Use _totalX here so walls stop the momentum too
if place_meeting(x + _totalX, y, oWall) {
	//slopes (say thanks basil)
	if !place_meeting(x+_totalX, y-abs(_totalX)-1, oWall) {
		while place_meeting(x+_totalX, y, oWall) {
			y-=_subpix;
		}
		
	} else {
		if !place_meeting(x+_totalX, y+abs(_totalX)+1, oWall) {
		while place_meeting(x+_totalX, y, oWall) {
			y+=_subpix;
		}
		} else {
			//closes all distance between player and wall:
			var _thing = _subpix*sign(_totalX);
			while !place_meeting(x+_thing,y,oWall) {
				x+=_thing;
			}
	
			_totalX=0;
			vX = 0; // Kill external momentum if you hit a wall face-first
		}
	}
}

//slopes pt2
if (_totalY>=0) && !place_meeting(x+_totalX, y+1, oWall) && place_meeting(x+_totalX, y + abs(_totalX)+1, oWall) {
	while !place_meeting(x+_totalX, y+_subpix, oWall) {
			y+=_subpix;
		}
}

x+=_totalX;


//Y

//gravity
ySpeed+=grav;

// Only cap falling speed, not rising speed (so bounces can be fast)
if (ySpeed > termVelocity) {
	ySpeed = termVelocity
} 

//jump
if (zKeyReal&&onGround) {
	ySpeed = jumpSpeed;
	sprite_index = sGoddardJump0;
	jumpHoldTime = 10;
}

if (jumpHoldTime> 9) {
	sprite_index = sGoddardJump;
	
	ySpeed=jumpSpeed;
	jumpHoldTime--;
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

// Re-calculate Y after jump/gravity logic
_totalY = ySpeed + vY;

//y collision
Gravity(oPlayer); // If Gravity() handles y+= and collision, ensure it uses _totalY internally

if (ySpeed >= 0 && place_meeting(x, y+1, oWall)) {
	onGround = true;
	vY = 0; // Reset vertical momentum when landing
} else {
	onGround = false;
}

y+=ySpeed + vY; // Note: If vY is meant to be a one-time blast, use y += (ySpeed + vY)

// Updated Bounce Pad Logic
if Touching(oBouncePad) {
    vX = 15;           
    vY = -20;          
    jumpHoldTime = 0;  
    onGround = false;
}

//skibtastic
if dead {
	canMove = false;
} else {
	if (instance_exists(oBossDoor)) {
    var door = instance_nearest(x, y, oBossDoor);

    if (door.state == "locking" || door.state == "closing") {  
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