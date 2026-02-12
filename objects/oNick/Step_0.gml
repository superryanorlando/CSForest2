//makes enemy almost front layer
depth = -9000;

if (y>room_height && !dead) {
	dead = true;
}

//Attacking

// --- HIT DETECTION & FLASHING ---
// If current HP is less than what it was last frame, he was hit!
if (hp < hpPrev) {
    flashTimer = 2; // Flash for 2 frames
    hpPrev = hp;    // Sync HP so we don't trigger the flash again until the next hit
}

// --- TURNING LOGIC ---
if (instance_exists(oPlayer)) {
    // Determine facing BEFORE shooting
    if (oPlayer.x > x) {
        image_xscale = -1; // Right
    } else {
        image_xscale = 1;  // Left
    }

    var _dist = distance_to_object(oPlayer);
    
    // Stop the rest of the logic if too far away
    if (_dist > 256) exit;

    // Your existing distance and shooting logic...
    var _dist = distance_to_object(oPlayer);
    if (_dist < 100 && canShoot && !cooldown) {
        isAttacking = true; // Set the animation state
        alarm[1] = 5;       // Create the projectile in 5 frames
        cooldown = true;
}

// Update hpPrev in case HP was healed or changed elsewhere
hpPrev = hp;

// Existing death check
if (hp <= 0) {
	dead = true; 
}

if (dead) {
	instance_destroy();
	exit;
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

if (ySpeed>=0) && !place_meeting(x+xSpeed, y+1, oWall) && place_meeting(x+xSpeed, y + abs(xSpeed)+1, oWall) {
	while !place_meeting(x+xSpeed, y+_subpix, oWall) {
			y+=_subpix;
		}
}

x+=xSpeed;

//Y

//gravity
EnemyG(id);


}
