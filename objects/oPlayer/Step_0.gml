//makes player front layer
depth = -10000;

//stun
if (flashTimer > 0) {
    flashTimer--;
    // Make the player flicker to show they are invincible
    image_alpha = (flashTimer % 4 < 2) ? 0.2 : 1.0; 
} else {
    // Only reset alpha if not currently stunned
    if (!stunned) image_alpha = 1.0;
}

// --- 2. STUN LOGIC ---
if (stunned) {
    xSpeed = 0; // Freeze horizontal movement
    
    stunTimer--;
    if (stunTimer <= 0) {
        stunned = false;
        canMove = true; // Set your movement flag back to true
        image_alpha = 1.0;
    }
    exit; 
}



// --- HOP RECOVERY TIMER ---
if (hopRecoveryTimer > 0) {
    hopRecoveryTimer--;
    canMove = false; // Keep movement locked
    
    // Once timer hits 0, restore movement
    if (hopRecoveryTimer <= 0) {
        canMove = true;
    }
}

//Inputs
playerInputs();

// Apply friction/gravity to external velocity BEFORE movement math
var _currentDecel = vDecel;
if (place_meeting(x, y + 1, oIce)) _currentDecel = 0.02; 

vX = lerp(vX, 0, _currentDecel);
vY = lerp(vY, 0, vDecel);
if (abs(vY) < 0.1) vY = 0;
if (abs(vX) < 0.1) vX = 0; 

// 1. QUICK HOP (Shift + Arrow)
// Must be on ground, not attacking, not already hopping/stunned, and holding a direction
if (shiftKey && (rightKey || leftKey) && onGround && !isAttacking && !stunned && !isHopping && hopRecoveryTimer <= 0) {
    var _hopDir = 0;
    if (rightKey) _hopDir = 1;
    if (leftKey) _hopDir = -1;
    
    // Hop Physics
    // We use vX (external velocity) so friction slows us down naturally after the burst
    vX = _hopDir * 12;   // High horizontal burst
    ySpeed = -2.5;        // Low vertical hop
    
    isHopping = true;
    onGround = false;     // Detach from ground immediately
    
    // Set Sprite
    sprite_index = sGoddardFall;
    // IMPORTANT: We do not change image_xscale here, so he hops backwards if facing wrong way
}

// Reset Hopping state when we land
if (onGround) {
    isHopping = false;
}

// 2. ORB PUNCH TRIGGER (C Key)
if (cKeyPressed && !isAttacking && !stunned && orbCooldown <= 0) {
    isAttacking = true;
    canMove = false;
    isHopping = false; 
    
    sprite_index = sGoddardOrbPunch;
    image_index = 0;
    image_speed = 1; 
    
    hasSpawnedOrb = false; // Reset this flag at the START of the punch
    orbCooldown = 60;      // Set the cooldown immediately
}

// Tick down the cooldown every frame
if (orbCooldown > 0) orbCooldown--;


// --- MELEE ATTACK SYSTEM (X) ---

// 1. COMBO RESET LOGIC
if (!isAttacking) {
    if (comboResetTimer > 0) {
        comboResetTimer--;
    } else {
        comboIndex = 1;
    }
}

// 2. TRIGGER ATTACK
if (xKeyPressed && onGround && !isAttacking) {
    isAttacking = true;
    canMove = false;
    attackTimer = 18; 
    
    alarm[3] = 6; // Delayed Hitbox
    
    ds_list_clear(enemy_hit_list);
    image_index = 0;
    
    switch(comboIndex) {
        case 1: sprite_index = sGoddardAtk1; break;
        case 2: sprite_index = sGoddardAtk2; break;
        case 3: sprite_index = sGoddardAtk3; break;
        case 4: sprite_index = sGoddardAtk4; break;
    }
    
    comboIndex++;
    if (comboIndex > 4) comboIndex = 1;
}

// 3. ACTIVE ATTACK BEHAVIOR
if (isAttacking) {
    canMove = false; 
    // CHECK: Is this the Orb Punch?
    if (sprite_index == sGoddardOrbPunch) {
        canMove = false;

    // 1. SPAWN THE ORB (on the 2nd frame)
    // We check the boolean 'hasSpawnedOrb' so it only happens ONCE per animation
    if (image_index >= 1 && !hasSpawnedOrb) { 
         var _orb = instance_create_layer(x-image_xscale*10, y-20, "Instances", oBlueOrb);
         _orb.facing = -image_xscale;
         
         hasSpawnedOrb = true; // This flag stays TRUE until the animation is totally done
    }

    // 2. WAIT FOR ANIMATION TO FINISH
    if (image_index + image_speed >= image_number) {
        isAttacking = false;
        canMove = true;
        sprite_index = sGoddardIdle;
        // Note: we don't reset hasSpawnedOrb here; we reset it at the start of the next press
    }
    } 
    // ELSE: It is a standard Melee attack
    else {
        attackTimer--;
        if (attackTimer <= 0) {
            isAttacking = false;
            canMove = true;
            comboResetTimer = 10;
            sprite_index = sGoddardIdle; 
        }
    }
}


// Combine normal movement with external velocity
var _totalX = xSpeed + vX;
var _totalY = ySpeed + vY;

//Collision stuffs

//did you fall into a bottomless pit...
if (y-sprite_height>room_height && !dead) {
    HPScript(-9999);
}

// MOVEMENT INPUTS
if (canMove) {
    if (rightKey) {
        // Only turn if NOT hopping
        if (!isHopping) image_xscale = -1; 
    } else if (leftKey) {
        if (!isHopping) image_xscale = 1;
    }
}
if (!canMove&&stunned) {
    xSpeed = 0; // Freeze horizontal movement
    // Countdown the stun
    if (variable_instance_exists(id, "stunTimer")) {
        stunTimer--;
        if (stunTimer <= 0) {
            canMove = true;
            image_alpha = 1.0;
        }
    }
}

//X
var _subpix = 0.5;

if place_meeting(x + _totalX, y, oWall) {
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
            var _thing = _subpix*sign(_totalX);
            while !place_meeting(x+_thing,y,oWall) {
                x+=_thing;
            }
    
            _totalX=0;
            vX = 0; 
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

if (ySpeed > termVelocity) {
    ySpeed = termVelocity
} 

if (zKeyReal && onGround) {
    
    if (isAttacking) {
        isAttacking = false;
        canMove = true;      
        attackTimer = 0;     
        alarm[3] = -1;       
    }

    // Perform the jump
    ySpeed = jumpSpeed;
    sprite_index = sGoddardJump0;
    jumpHoldTime = 10;
    onGround = false; 
    
    zKeyTimer = 0; 
    zKeyReal = 0;
}

// --- VARIABLE JUMP LOGIC (FIXED FOR PARABOLA) ---
if (jumpHoldTime > 0) {
    ySpeed = jumpSpeed;
    jumpHoldTime--;
    sprite_index = sGoddardJump;
}

// Variable jump height "brake"
// We added !isBouncing so the parabola isn't cut short if you aren't holding Z
if (!zKey && !isBouncing) {
    jumpHoldTime = 0;
    if (ySpeed < 0) {
        ySpeed *= 0.5;
    }
}

// Reset bounce flag when falling or landing
if (ySpeed >= 0 || onGround) {
    isBouncing = false;
}

// Re-calculate Y after jump/gravity logic
_totalY = ySpeed + vY;

//y collision
Gravity(oPlayer); 

if (ySpeed >= 0 && place_meeting(x, y+1, oWall)) {
	if (isHopping) {
        isHopping = false;
        canMove = false;
        vX = 0;      // Kill external horizontal momentum
        xSpeed = 0;  // Kill internal horizontal speed
        
        // 0.15 seconds is approx 9 frames at 60FPS
        // Use game_get_speed(gamespeed_fps) * 0.15 for accuracy across different monitors
        hopRecoveryTimer = game_get_speed(gamespeed_fps) * 0.25; 
    }
    onGround = true;
    vY = 0; 
} else {
    onGround = false;
}

y += (ySpeed + vY); 


var pad  = instance_place(x, y, oBouncePad);
var padS = instance_place(x, y, oBouncePadSuper);
var vpad = instance_place(x, y, oBouncePadV);
var hpad = instance_place(x, y, oBouncePadH);
var hpadL = instance_place(x, y, oBouncePadHL);

if (pad != noone) {
    vX = 15;
    ySpeed = -10;        
    vY = 0;           
    isBouncing = true;   
    jumpHoldTime = 0;     
    zKeyReal = 0;          
    onGround = false;
    y -= 2;
}

if (padS != noone) {
    vX = 25;
    ySpeed = -25;        
    vY = 0;           
    isBouncing = true;   
    jumpHoldTime = 0;     
    zKeyReal = 0;          
    onGround = false;
    y -= 2;
}

if (vpad != noone) {
    ySpeed = -10;         
    vY = 0;               
    isBouncing = true;    
    jumpHoldTime = 0;
    zKeyReal = 0;
    onGround = false;
    y -= 2;
}
if (hpad != noone) {
    vX = 10;
}

if (hpadL != noone) {
    vX = -10;
}

var vine = instance_place(x, y, oVine);

if (vine != noone) {
    if (keyboard_check(vk_up) || keyboard_check(vk_down)) {
        onVine = true;
        vX = 0;
        vY = 0;
        xSpeed = 0;
    }
} else {
    onVine = false;
}

if (onVine) {
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

    exit; 
}

var _onIce = place_meeting(x, y + 1, oIce);

if (_onIce && canMove) {
    if (rightKey) vX += 0.2; 
    if (leftKey)  vX -= 0.2;   
    vX = clamp(vX, -8, 8); 
}

var Bpad = instance_place(x, y, oBoostPad);

if (Bpad != noone) {
    vX = 15;
}

var Bpad2= instance_place(x, y, oBoostPad2);

if (Bpad2 != noone) {
    vX = -15;
}



// Boss Door Logic
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

if (x > room_width && instance_exists(oCamera)) {
    if (room_exists(room_next(room))) {
        room_goto_next();
		audio_stop_all();
    }
} else {
	// If oCamera doesn't exist, we assume oCameraAuto is running (Auto-scroller mode)
    if (!instance_exists(oCamera)) {
        var _camX = camera_get_view_x(view_camera[0]);
        var _camW = camera_get_view_width(view_camera[0]);
     
        // Clamp the player between the left and right edges of the CAMERA view
        // 16px buffer ensures the player's sprite doesn't clip halfway off-screen
        x = clamp(x, _camX + 16, _camX + _camW - 16);

}
}