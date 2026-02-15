// Depth sorting
depth = -9000;

// Die if falling out of world
if (y > room_height && !dead) {
    dead = true;
}

if (hp < hpPrev) {
    flashTimer = 2; // Flash for 2 frames
    hpPrev = hp;    // Sync HP so we don't trigger the flash again until the next hit
}

// =========================================================
// --- STATE MACHINE ---
// =========================================================

switch (state) {
    
    case "IDLE":
        image_speed = 1;
        image_xscale = 1; // Reset scale so Idle0/1 show correctly
        
        if (instance_exists(oPlayer)) {
            // 1. Determine direction
            facingDir = (oPlayer.x < x) ? -1 : 1; 

            // 2. SWITCH SPRITES (Explicitly check every frame)
            if (facingDir == -1) {
                sprite_index = sKarczIdle0; // Look Left
            } else {
                sprite_index = sKarczIdle1; // Look Right
            }

            // 3. Range Check
            if (distance_to_object(oPlayer) < 40) {
                state = "ALERT";
                sprite_index = sKarczAlert;
                image_xscale = -facingDir; // Flip the alert sprite to face player
                alarm[0] = alertTime;
            }
        }
        break;

    case "ATTACK":
        xSpeed = 0;
        debugShowHitbox = true;
        image_xscale = -facingDir;

        // Animation transition logic
        if (sprite_index == sKarczJab && image_index >= 1.9) { 
            sprite_index = sKarczExtend;
            image_index = 0;
        }

        // Hitbox Calculation
        var _rectX1, _rectX2;
        var _boxWidth = 40;
        if (facingDir == 1) { _rectX1 = x; _rectX2 = x + _boxWidth; }
        else { _rectX1 = x - _boxWidth; _rectX2 = x; }
        
        var _rectY1 = y - 35; 
        var _rectY2 = _rectY1 + 10;

        // HIT LOGIC
        var _hits = ds_list_create();
        var _count = collision_rectangle_list(_rectX1, _rectY1, _rectX2, _rectY2, oPlayer, false, true, _hits, false);

        if (_count > 0) {
            for (var i = 0; i < _count; i++) {
                var _inst = _hits[| i];
                if (ds_list_find_index(hitList, _inst) == -1) {
                    
                    // 1. Apply Damage
                    with(_inst) { HPScript(-5); } 
                    
                    // 2. APPLY KNOCKBACK
                    // We push the player in the direction Karcz is facing
                    // Increase '8' for a stronger push, '-4' for higher lift
                    _inst.vX = facingDir * 2.5; 
                    _inst.vY = 0;            
                    
                    ds_list_add(hitList, _inst);
                }
            }
        }
        ds_list_destroy(_hits);
        break;
        
    case "COOLDOWN":
        // Reset scale and pick correct idle sprite while waiting
        image_xscale = 1;
        sprite_index = (facingDir == -1) ? sKarczIdle0 : sKarczIdle1;
        break;
}


// =========================================================
// --- PHYSICS & COLLISION (Provided Code) ---
// =========================================================

if (hp <= 0) {
	dead = true; 
}

if (dead) {
	instance_destroy();
	exit;
}

// X Collision
var _subpix = 0.5;

if place_meeting(x + xSpeed, y, oWall) {
    if !place_meeting(x + xSpeed, y - abs(xSpeed) - 1, oWall) {
        while place_meeting(x + xSpeed, y, oWall) { y -= _subpix; }
    } else {
        if !place_meeting(x + xSpeed, y + abs(xSpeed) + 1, oWall) {
            while place_meeting(x + xSpeed, y, oWall) { y += _subpix; }
        } else {
            var _thing = _subpix * sign(xSpeed);
            while !place_meeting(x + _thing, y, oWall) { x += _thing; }
            xSpeed = 0;
        }
    }
}

// Slope Y Logic
if (ySpeed >= 0) && !place_meeting(x + xSpeed, y + 1, oWall) && place_meeting(x + xSpeed, y + abs(xSpeed) + 1, oWall) {
    while !place_meeting(x + xSpeed, y + _subpix, oWall) { y += _subpix; }
}

x += xSpeed;

// Gravity
EnemyG(id); 
