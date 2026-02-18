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

// --- 1. PRE-MOVEMENT LOGIC ---
if (attackTimer > 0) attackTimer--;

var _target = oPlayer;
var _dist = 999;
var _dir = image_xscale;

if (instance_exists(_target)) {
    _dist = distance_to_object(_target);
    _dir = sign(_target.x - x);
    if (_dir == 0) _dir = -1; // Default to facing left if on top of player
    
    // Always face the player when not shooting
    if (state != "SHOOT") {
        image_xscale = -_dir; // -1 for Right, 1 for Left
    }
}

// --- 2. STATE MACHINE ---
switch (state) {
    case "IDLE":
    case "COOLDOWN":
        sprite_index = sChristianIdle;
        
        // Always try to move towards the player
        if (instance_exists(_target)) {
            xSpeed = _dir * moveSpeed;
        }

        // Check for attack range (only if not cooling down)
        if (state == "IDLE" && _dist < 60) {
            state = "SHOOT";
            sprite_index = sChristianShoot;
            image_index = 0;
            hasShot = false;
			
        }
        
        // Finish cooldown
        if (state == "COOLDOWN" && attackTimer <= 0) {
            state = "IDLE";
        }
        break;

    case "SHOOT":
        sprite_index = sChristianShoot;
        xSpeed = 0;

        // Shoot on the 2nd frame (index 1)
        if (floor(image_index) == 1 && !hasShot) {
            var _bullet = instance_create_layer(x, y - 16, "Instances", oBullet);
            _bullet.hSpeed = (image_xscale == 1) ? -5 : 5; // Bullet matches facing
			_bullet.image_xscale = image_xscale;
            hasShot = true;
        }

        // End animation
        if (image_index >= image_number - 1) {
            state = "COOLDOWN";
            attackTimer = attackCooldown;
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

