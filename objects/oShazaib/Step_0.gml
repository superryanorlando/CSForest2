//makes enemy almost front layer
depth = -9000;

if (y>room_height && !dead) {
	dead = true;
}

if (Touching(oPlayer) && !oPlayer.invulnerable) {
	if (state=="RUN"||state=="COOLDOWN") {
		HPScript(-15);
	} 
}

// --- DAMAGE FLASH LOGIC ---
if (hp < hpPrev) {
    flashTimer = 2;
    hpPrev = hp;
}
// Update hpPrev
hpPrev = hp;
if (hp <= 0) dead = true;
if (dead) { instance_destroy(); exit; }

switch (state) {
    
    // 1. IDLE: Wait for player
    case "IDLE":
        xSpeed = 0;
        sprite_index = sShazaibIdle;
        
        if (instance_exists(oPlayer)) {
            // Face the player (using your established -1 = Right convention)
            if (oPlayer.x > x) {
                image_xscale = -1; // Face Right
            } else {
                image_xscale = 1;  // Face Left
            }

            // Check distance (75px)
            if (distance_to_object(oPlayer) < 75) {
                state = "ALERT";
                sprite_index = sShazaibAlert;
                image_index = 0; // Reset animation to frame 0
                alarm[0] = alertTime; // Trigger Alert Timer
            }
        }
        break;

    // 2. ALERT: Freeze and warn player
    case "ALERT":
        xSpeed = 0;
        // Direction is now LOCKED (we are not updating image_xscale)
        if (sprite_index != sShazaibAlert) sprite_index = sShazaibAlert;
        break;

    // 3. RUN: Charge in the locked direction
    case "RUN":
        sprite_index = sShazaibRun;
        
        // Calculate speed based on facing direction
        // If Scale is -1 (Right), we want positive speed.
        // If Scale is 1 (Left), we want negative speed.
        xSpeed = -image_xscale * runSpeed;
        break;

    // 4. COOLDOWN: Skid to stop and wait
    case "COOLDOWN":
        sprite_index = sShazaibIdle;
        
        // Friction: Smoothly reduce speed to 0
        xSpeed = lerp(xSpeed, 0, fric);
        
        // Stop completely if very slow
        if (abs(xSpeed) < 0.1) xSpeed = 0;
        break;
}

//

//DIE

//


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

if (ySpeed>=0) && !place_meeting(x+xSpeed, y+1, oWall) && place_meeting(x+xSpeed, y + abs(xSpeed)+1, oWall) {
	while !place_meeting(x+xSpeed, y+_subpix, oWall) {
			y+=_subpix;
		}
}

x+=xSpeed;

//Y

//gravity
EnemyG(id);

