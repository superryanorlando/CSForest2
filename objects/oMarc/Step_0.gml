// Depth
depth = -9000;

// Die check
if (y > room_height && !dead) dead = true;
if (dead) { instance_destroy(); exit; }

// Flash Logic
if (hp < hpPrev) {
    flashTimer = 2;
    hpPrev = hp;
}

var _applyGravity = true; // Default gravity to ON

// =========================================================
// --- STATE MACHINE ---
// =========================================================

switch (state) {

    // 1. HIDDEN
    case "HIDDEN":
        sprite_index = sMarcHidden;
        image_speed = 0;
        if (instance_exists(oPlayer) && onGround) {
            if (distance_to_object(oPlayer) < 60) {
                state = "SURPRISE";
                sprite_index = sMarcSurprise;
                image_index = 0;
                image_speed = 1; 
            }
        }
        break;

    // 2. SURPRISE (Animation Sync Fix)
    case "SURPRISE":
        // Wait for the animation to actually finish
        if (image_index >= image_number - 1) {
            state = "PRE_JUMP";
        }
        break;

    // 3. PRE_JUMP
    case "PRE_JUMP":
        sprite_index = sMarcJump;
        image_index = 0;
        image_speed = 1;
        
        jumpStartY = y;
        startX = x;
        if (instance_exists(oPlayer)) targetX = oPlayer.x;
        
        var _launchSpeed = -sqrt(2 * grav * jumpHeight);
        ySpeed = _launchSpeed;
        jumpDuration = abs(_launchSpeed / grav);
        jumpTimer = 0;
        
        onGround = false;
        state = "JUMP_UP";
        break;

    // 4. JUMP_UP
    case "JUMP_UP":
        jumpTimer++;
        var _progress = jumpTimer / jumpDuration;
        x = lerp(startX, targetX, min(_progress, 1));

        if (ySpeed >= 0) {
            y = jumpStartY - jumpHeight;
            x = targetX;
            ySpeed = 0;
            hoverTimer = 10;
            state = "HOVER";
        }
        break;

    // 5. HOVER
    case "HOVER":
        _applyGravity = false;
        hoverTimer--;
        if (hoverTimer <= 0) {
            state = "SLAM";
            ySpeed = 14; // Increased slam speed for impact
        }
        break;

    // 6. SLAM (Anti-Clipping Fix)
    case "SLAM":
        _applyGravity = false;
        if (Touching(oPlayer) && !oPlayer.invulnerable) {
	    HPScript(-15);
	    
	}
        // Precision Collision: Check if we will hit the wall in the next frame
        if (place_meeting(x, y + ySpeed, oWall)) {
            // Move pixel-by-pixel to the surface
            while (!place_meeting(x, y + sign(ySpeed), oWall)) {
                y += sign(ySpeed);
            }
            
            // --- THE FIXES ---
            y = round(y);       // Snap to the nearest integer pixel to prevent floating
            ySpeed = 0;
            onGround = true;
            state = "LAND_RECOVERY";
            sprite_index = sMarcStomp;
            image_index = 0;
            image_speed = 1;
        } else {
            y += ySpeed;
        }
        break;

    // 7. LAND RECOVERY (Shortened & Synced)
    case "LAND_RECOVERY":
        xSpeed = 0;
        // Animation check: Play sMarcStomp exactly once
        if (image_index >= image_number - 1) {
            stompCount++;
            if (stompCount < 3) {
                state = "PRE_JUMP";
            } else {
                state = "COOLDOWN";
                sprite_index = sMarcIdle;
                cooldownTimer = 120; 
            }
        }
        break;

    // 8. COOLDOWN & 9. SLEEP & 10. ALERT (Same as before)
    case "COOLDOWN":
        xSpeed = 0;
        cooldownTimer--;
        if (cooldownTimer <= 0) {
            if (instance_exists(oPlayer) && distance_to_object(oPlayer) <= 40) {
                state = "ALERT";
                sprite_index = sMarcAlert;
                animTimer = 20; 
            } else {
                state = "SLEEP";
                sprite_index = sMarcSleep;
            }
        }
        break;

    case "SLEEP":
        xSpeed = 0;
        if (instance_exists(oPlayer) && distance_to_object(oPlayer) <= 40) {
            state = "ALERT";
            sprite_index = sMarcAlert;
            animTimer = 20;
        }
        break;

    case "ALERT":
        xSpeed = 0;
        animTimer--;
        if (animTimer <= 0) {
            stompCount = 0;
            state = "PRE_JUMP";
        }
        break;
}

// =========================================================
// --- PHYSICS APPLICATION ---
// =========================================================

// Only run standard collisions if we are NOT in the special jump states
// This prevents the physics engine from fighting our manual math
if (state != "JUMP_UP" && state != "HOVER" && state != "SLAM") {
    
    // X Collision
    var _subpix = 0.5;
    if place_meeting(x + xSpeed, y, oWall) {
        if !place_meeting(x+xSpeed, y-abs(xSpeed)-1, oWall) {
            while place_meeting(x+xSpeed, y, oWall) { y-=_subpix; }
        } else {
            if !place_meeting(x+xSpeed, y+abs(xSpeed)+1, oWall) {
                while place_meeting(x+xSpeed, y, oWall) { y+=_subpix; }
            } else {
                var _thing = _subpix*sign(xSpeed);
                while !place_meeting(x+_thing,y,oWall) { x+=_thing; }
                xSpeed=0;
            }
        }
    }
    x += xSpeed;
    
    // Y Collision (Standard)
    if (_applyGravity) {
        EnemyG(id);
    }
} else {
    // If we ARE in JUMP_UP, we still want gravity to affect ySpeed 
    // so the arc curve works (ySpeed needs to decrease)
    if (state == "JUMP_UP") {
        ySpeed += grav;
        y += ySpeed;
    }
}