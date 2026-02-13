//makes player front layer
depth = -10000;

//Inputs
playerInputs();

// Apply friction/gravity to external velocity BEFORE movement math
var _currentDecel = vDecel;
if (place_meeting(x, y + 1, oIce)) _currentDecel = 0.02; 

vX = lerp(vX, 0, _currentDecel);
vY = lerp(vY, 0, vDecel);
if (abs(vY) < 0.1) vY = 0;
if (abs(vX) < 0.1) vX = 0; 

// --- MELEE ATTACK SYSTEM ---

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
    attackTimer--;

    // --- END ATTACK ---
    if (attackTimer <= 0) {
        isAttacking = false;
        canMove = true;
        comboResetTimer = 10;
        sprite_index = sGoddardIdle; 
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
        image_xscale = -1;
    } else if (leftKey) {
        image_xscale = 1;
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
    onGround = true;
    vY = 0; 
} else {
    onGround = false;
}

y += (ySpeed + vY); 

// --- BOUNCE PAD LOGIC (FIXED FOR PARABOLA) ---
var pad  = instance_place(x, y, oBouncePad);
var vpad = instance_place(x, y, oBouncePadV);
var hpad = instance_place(x, y, oBouncePadH);

if (pad != noone) {
    vX = 15;
    ySpeed = -10;         // Use ySpeed so gravity handles the arc
    vY = 0;               // Reset external Y
    isBouncing = true;    // Prevents Z-release from cutting the height
    jumpHoldTime = 0;     
    zKeyReal = 0;          
    onGround = false;
    y -= 2;
}
if (vpad != noone) {
    ySpeed = -10;         // Use ySpeed so gravity handles the arc
    vY = 0;               // Reset external Y
    isBouncing = true;    // Prevents Z-release from cutting the height
    jumpHoldTime = 0;
    zKeyReal = 0;
    onGround = false;
    y -= 2;
}
if (hpad != noone) {
    vX = 10;
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