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

// 1. COMBO RESET LOGIC
// If we are not attacking, count down the reset timer. 
// If it hits 0, the next attack starts back at Animation 1.
if (!isAttacking) {
    if (comboResetTimer > 0) {
        comboResetTimer--;
    } else {
        comboIndex = 1;
    }
}

// 2. TRIGGER ATTACK
// Trigger if X is pressed, we are on the ground, and not currently locked in an animation
if (xKeyPressed && onGround && !isAttacking) {
    isAttacking = true;
    canMove = false;
    
    // Stop all momentum immediately so we don't slide while attacking
    xSpeed = 0; 
    vX = 0;     
    
    // Set duration
    attackTimer = attackDuration;
    
    // Clear the hit list so we can hit enemies again with this new swing
    ds_list_clear(enemy_hit_list);
    
    // Select Sprite based on current combo index
    image_index = 0; // Reset animation to frame 0
    switch(comboIndex) {
        case 1: sprite_index = sGoddardAtk1; break;
        case 2: sprite_index = sGoddardAtk2; break;
        case 3: sprite_index = sGoddardAtk3; break;
        case 4: sprite_index = sGoddardAtk4; break;
    }
    
    // Prepare the NEXT attack index (1->2->3->4->1)
    comboIndex++;
    if (comboIndex > 4) comboIndex = 1;
}

// 3. ACTIVE ATTACK BEHAVIOR
if (isAttacking) {
    // Keep player frozen
    canMove = false; 
    attackTimer--;

    // --- HITBOX GENERATION ---
    // Define the rectangle coordinates based on facing direction
    var _dir = image_xscale; // 1 or -1
    
    // Calculate X coordinates:
    // Starts 6px away from origin. Width is 6px.
    // Right: x+6 to x+12. Left: x-12 to x-6.
    var _x1, _x2;
    
    if (_dir == 1) {
        _x1 = x + 6;
        _x2 = x + 12; // 6px start + 6px width
    } else {
        _x1 = x - 12; // 6px start + 6px width (mirrored)
        _x2 = x - 6;
    }
    
    // Calculate Y coordinates (origin is bottom, box is 32px tall)
    var _y1 = y - 32;
    var _y2 = y;

    // Create a list to store enemies hit this frame
    var _hits = ds_list_create();
    var _count = collision_rectangle_list(_x1, _y1, _x2, _y2, oEnemy, false, true, _hits, false);

    // If we hit something
    if (_count > 0) {
        for (var i = 0; i < _count; i++) {
            var _inst = _hits[| i];
            
            // Check if this specific enemy has already been hit THIS SWING
            if (ds_list_find_index(enemy_hit_list, _inst) == -1) {
                // Apply Damage
                if (variable_instance_exists(_inst, "hp")) {
                    _inst.hp -= 1;
                }
                // Add to list so they don't get hit again until next button press
                ds_list_add(enemy_hit_list, _inst);
            }
        }
    }
    // Clean up temporary list
    ds_list_destroy(_hits);

    // --- END ATTACK ---
    if (attackTimer <= 0) {
        isAttacking = false;
        canMove = true;
        // Start the 10-frame timer. If player doesn't press X within 10 frames, combo resets.
        comboResetTimer = 10;
        
        // Return to Idle sprite immediately to prevent stuck animation
        sprite_index = sGoddardIdle; 
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

var vine = instance_place(x, y, oVine);

if (vine != noone) {
    if (keyboard_check(vk_up) || keyboard_check(vk_down)) {
        onVine = true;

        // Kill momentum only
        vX = 0;
        vY = 0;
        xSpeed = 0;
    }
} else {
    onVine = false;
}

if (onVine) {

    // Disable gravity
    ySpeed = 0;
    vY = 0;

    var climb = 0;
    if (keyboard_check(vk_up))   climb = -vineSpeed;
    if (keyboard_check(vk_down)) climb =  vineSpeed;

    if (!place_meeting(x, y + climb, oWall)) {
        y += climb;
    }

    // Jump off vine
    if (zKeyReal) {
        onVine = false;
        ySpeed = jumpSpeed;
    }

    exit; // VERY IMPORTANT — stops normal movement code
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