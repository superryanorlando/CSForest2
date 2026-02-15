// Depth sorting
depth = -9000;

// Die
if (y > room_height && !dead) dead = true;

if (hp <= 0) {
	dead = true; 
}

if (dead) { instance_destroy(); exit; }

// Flash Logic
if (hp < hpPrev) {
    flashTimer = 2;
    hpPrev = hp;
}

// =========================================================
// --- STATE MACHINE ---
// =========================================================

switch (state) {

    // 1. IDLE: Watch Player
    case "IDLE":
        sprite_index = sLeeIdle;
        image_speed = 1; 
        
        if (instance_exists(oPlayer)) {
            // Face Player
            if (oPlayer.x < x) facingDir = 1;
            else facingDir = -1;
            
            image_xscale = facingDir;

            // Check Distance (80px)
            if (distance_to_object(oPlayer) < 100) {
                state = "RAISE";
                sprite_index = sLeeRaise;
                image_index = 0;
                
                // Set animation speed to 5 FPS (assuming 60fps game speed)
                // If your game is 30fps, change 60 to 30.
                
            }
        }
        break;

    // 2. RAISE: Play animation ONCE
    case "RAISE":
        // Face player is locked now (we don't update facingDir)
        
        // Check if animation has finished
        if (image_index >= image_number - 1) {
            state = "WARN";
            sprite_index = sLeeWarn;
            image_speed = 1; // Static image or looping warn
            alarm[0] = warnTime; // 0.75s timer
        }
        break;

    // 3. WARN: Freeze for 0.75s
    case "WARN":
        xSpeed = 0;
        // Waiting for Alarm 0 to trigger
        break;

    // 4. ATTACK: Loop twice, fire on frame 2
    case "ATTACK":
        xSpeed = 0;
        
        // Fire Bullet on 2nd Frame (Index 1)
        // We use a small range (1.0 to 1.5) to catch the frame cleanly
        if (image_index >= 1 && image_index < 2 && !hasFired) {
            
            // --- SPAWN BULLET ---
            // 2/3rds up from bottom = y - (height * 0.66)
            var _spawnY = y - (sprite_height * 0.66); 
            var _spawnX = x - (10 * facingDir); // Slight offset forward
            
            var _bullet = instance_create_layer(_spawnX, _spawnY, "Instances", oLeeIceBullet);
            
            // Pass direction to bullet
            _bullet.hspeed = 4 * -facingDir; 
            _bullet.image_xscale = -facingDir;
            
            hasFired = true; 
        }

        // End of Animation Loop
        if (image_index >= image_number - 1) {
            attackLoopCounter++;
            image_index = 0;    // Reset animation
            hasFired = false;   // Reset firing flag
            
            // If we have played it twice (0 and 1), stop
            if (attackLoopCounter >= 2) {
                state = "COOLDOWN";
                sprite_index = sLeeIdle;
                alarm[1] = cooldownTime; // 1.5s timer
            }
        }
        break;

    // 5. COOLDOWN: Wait
    case "COOLDOWN":
        xSpeed = 0;
        // Waiting for Alarm 1
        break;
}

// =========================================================
// --- PHYSICS (Standard) ---
// =========================================================

// X Collision
var _subpix = 0.5;
if place_meeting(x + xSpeed, y, oWall) {
    if !place_meeting(x+xSpeed, y-abs(xSpeed)-1, oWall) {
        while place_meeting(x+xSpeed, y, oWall) y-=_subpix;
    } else {
        if !place_meeting(x+xSpeed, y+abs(xSpeed)+1, oWall) {
            while place_meeting(x+xSpeed, y, oWall) y+=_subpix;
        } else {
            var _thing = _subpix*sign(xSpeed);
            while !place_meeting(x+_thing,y,oWall) x+=_thing;
            xSpeed=0;
        }
    }
}
if (ySpeed>=0) && !place_meeting(x+xSpeed, y+1, oWall) && place_meeting(x+xSpeed, y + abs(xSpeed)+1, oWall) {
    while !place_meeting(x+xSpeed, y+_subpix, oWall) y+=_subpix;
}
x+=xSpeed;

// Gravity
EnemyG(id);