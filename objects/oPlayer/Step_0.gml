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


// --- MELEE ATTACK SYSTEM ---

// Reduce combo timer over time
if (comboTimer > 0) comboTimer--;
else comboIndex = 1; // Reset combo if too much time passes

// Trigger Attack
if (xKeyPressed && !isAttacking && onGround) {
    isAttacking = true;
    canMove = false;
    image_index = 0;
    holdTimer = 0;
    canInputNext = false;
    
    // Select Sprite
    sprite_index = asset_get_index("sGoddardAtk" + string(comboIndex));
    
    // Hitbox Logic: Define area 6px wide, 35px tall
    // We adjust the X offset based on which way the player faces (image_xscale)
    var _hitboxW = 6;
    var _hitboxH = 35;
    var _xOffset = (image_xscale == -1) ? 5 : -5; // Adjust based on your sprite origin
    
    var _list = ds_list_create();
    var _num = collision_rectangle(x + _xOffset, y - (_hitboxH/2), x + _xOffset + (_hitboxW * -image_xscale), y + (_hitboxH/2), oEnemy, false, true);
    
    // If an enemy is found, reduce HP
    // Note: To prevent hitting every frame, we do this once per button press
    var _inst = instance_place(x + (_xOffset * -image_xscale), y, oEnemy);
    with (oEnemy) {
        if (place_meeting(x, y, other)) { // Basic check for simplicity
             if (collision_rectangle(other.x + _xOffset, other.y - (_hitboxH/2), other.x + _xOffset + (_hitboxW * -other.image_xscale), other.y + (_hitboxH/2), id, false, false)) {
                hp -= 1;
             }
        }
    }
    ds_list_destroy(_list);
}

// Handle Animation & "Holding" Frames
if (isAttacking) {
    image_speed = 1;
    
    // Check if we reached the last frame
    if (image_index >= image_number - 1) {
        image_speed = 0; // Pause animation
        image_index = image_number - 1; // Stay on last frame
        holdTimer++;
        
        // On the 2nd frame of holding, allow a combo follow-up
        if (holdTimer >= 2) canInputNext = true;
        
        // If we pressed X again during the hold
        if (canInputNext && xKeyPressed) {
            isAttacking = false; // Reset to trigger new attack
            comboIndex++;
            if (comboIndex > 4) comboIndex = 1;
            comboTimer = comboWindow;
        }
        
        // After 5 frames, finish the attack
        if (holdTimer >= 5) {
            isAttacking = false;
            canMove = true;
            comboIndex++;
            if (comboIndex > 4) comboIndex = 1;
            comboTimer = comboWindow;
        }
    }
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

y+=ySpeed + vY; 

// Updated Bounce Pad Logic
var pad = instance_place(x, y, oBouncePad);
if (pad != noone) {
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