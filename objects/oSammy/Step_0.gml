//basic
depth = -9000;

if (y>room_height && !dead) {
	dead = true;
}
if (hp < hpPrev) {
    flashTimer = 2; // Flash for 2 frames
    hpPrev = hp;    // Sync HP so we don't trigger the flash again until the next hit
}
if (hp <= 0) {
	dead = true; 
}
if (dead) {
	instance_destroy();
	exit;
}

// --- TARGETING & TURNING ---
var _target = oPlayer;
var _dist = 0;

if (instance_exists(_target)) {
    _dist = distance_to_object(_target);
    
    // Only turn if not currently punching or dashing
    if (canTurn) {
        if (_target.x < x) image_xscale = 1;  // Facing Left (default)
        else image_xscale = -1;               // Facing Right
    }
}

// --- STATE MACHINE ---
switch (state) {
    case "IDLE":
        sprite_index = sSammyIdle;
        xSpeed = 0;
        canTurn = true;

        if (instance_exists(_target) && _dist < aggroDist) {
            state = "DASH";
            sprite_index = sSammyDash;
            // Initial burst of speed towards player
            xSpeed = (image_xscale == 1) ? -dashPower : dashPower;
        }
        break;

    case "DASH":
        canTurn = false; // Keep facing the direction of the lunge
        
        // Friction Logic: Slow down if close to player OR if we've moved past them
        if (_dist < stopDist) {
            xSpeed *= frictionPower;
        }

        // Transition to Punch once slowed down significantly
        if (abs(xSpeed) < 0.5) {
            xSpeed = 0;
            state = "PUNCH";
            sprite_index = sSammyPunch;
            image_index = 0;
        }
        break;

    case "PUNCH":
        // HITBOX LOGIC: Only check for hits on specific frames of the animation
        // Usually frames 1-2 are the "active" punch frames
        if (image_index >= 4 && image_index <= 5) {
            var _x1 = x;
            var _y1 = y - hitboxYOffset;
            var _x2 = x + (hitboxW * -image_xscale); // Flipped because 1 is Left
            var _y2 = y - (hitboxYOffset + hitboxH);

            if (collision_rectangle(_x1, _y1, _x2, _y2, oPlayer, false, true)) {
                if (!oPlayer.invulnerable) {
                    with(oPlayer) HPScript(-8); 
                }
            }
        }

        // Transition to Cooldown after animation ends
        if (image_index >= image_number - 1) {
            state = "COOLDOWN";
            
            // Sets a random integer. Super annoying - ryan
            attackTimer = irandom_range(5, 40); 
            
            sprite_index = sSammyIdle;
        }
        break;

    case "COOLDOWN":
        canTurn = true;
        attackTimer--;
        if (attackTimer <= 0) {
            state = "IDLE";
        }
        break;
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

