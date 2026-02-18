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

var _target = oPlayer;
var _dist = distance_to_object(_target);

// --- FACING LOGIC ---
if (canTurn && instance_exists(_target)) {
    // 1 = Left (Default), -1 = Right
    image_xscale = (_target.x < x) ? 1 : -1;
}

// --- STATE MACHINE ---
switch (state) {
    case "IDLE":
        sprite_index = sPranavIdle;
        canTurn = true;
        
        if (_dist < aggroDist) {
            state = "SWING";
            sprite_index = sPranavSwing;
            image_index = 0;
            hasShot = false;
        }
        break;

    case "SWING":
        canTurn = false; 
		
		// --- HITBOX CALCULATION ---
    // The bottom of the hitbox aligns with y (the origin)
    var _rectX1, _rectX2;
    var _rectY1 = y - boxHeight; 
    var _rectY2 = y;

    // Pranav faces Left by default (image_xscale = 1)
    if (image_xscale == 1) { 
        _rectX1 = x - boxWidth; 
        _rectX2 = x; 
    } else { 
        _rectX1 = x; 
        _rectX2 = x + boxWidth; 
    }

    // --- HIT LOGIC (Active during the swing frames, e.g., frames 2-6) ---
    if (image_index >= 3 && image_index <= 6) {
        var _hits = ds_list_create();
        var _count = collision_rectangle_list(_rectX1, _rectY1, _rectX2, _rectY2, oPlayer, false, true, _hits, false);

        if (_count > 0) {
            for (var i = 0; i < _count; i++) {
                var _inst = _hits[| i];
                    
                    // 1. Apply Damage
                    with(_inst) { if !_inst.invulnerable{ HPScript(-5);} } 
                    
                    // 2. APPLY KNOCKBACK
                    // facingDir logic: image_xscale 1 is Left (-1 push), -1 is Right (+1 push)
                    var _pushDir = (image_xscale == 1) ? -1 : 1;
                    _inst.vX = _pushDir * 2.5; 
                    _inst.vY = -2; // Added a tiny bit of lift so they don't just slide
                    
                    ds_list_add(hitList, _inst);
                }
            }
			ds_list_destroy(_hits); // Always destroy temporary lists!
        }
        
   

        // Trigger shot on frame 5 (index 4)
        if (floor(image_index) == 4 && !hasShot) {
            // MATH: Since 1 is Left and -1 is Right:
            // Left: x + (20 * -1) = x - 20
            // Right: x + (20 * 1) = x + 20
            var _spawnX = x + (shotOffsetX * -image_xscale);
            var _spawnY = y + shotOffsetY;
            
            var _p = instance_create_layer(_spawnX, _spawnY, "Instances", oPaintball);
            
            _p.hSpeed = (image_xscale == 1) ? -4 : 4; 
            _p.image_xscale = image_xscale;
            hasShot = true;
        }

        // Transition to COOLDOWN instead of IDLE
        if (image_index >= image_number - 1) {
            state = "COOLDOWN";
            cooldownTimer = cooldownMax;
            sprite_index = sPranavIdle; // Back to idle pose during wait
        }
        break;
		
    case "COOLDOWN":
        canTurn = true; // He can watch the player while waiting
        cooldownTimer--;
        
        if (cooldownTimer <= 0) {
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

