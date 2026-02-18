// --- 1. BASIC SYSTEM CHECKS ---
depth = -9000;
var _target = oPlayer;

if (y > room_height && !dead) dead = true;
if (hp < hpPrev) { flashTimer = 2; hpPrev = hp; }
if (hp <= 0 || dead) { instance_destroy(); exit; }

// --- 2. STATE MACHINE ---
switch (state) {
    case "WAIT_FOR_DOOR":
        sprite_index = sBigTommyIdle;
        xSpeed = 0;
        // Specifically find the door near Tommy
        var _inst = instance_nearest(x, y, oBossDoor);
        if (_inst != noone && _inst.state == "locked") {
            state = "IDLE";
            attackTimer = 60;
        }
        break;

    case "IDLE":
        sprite_index = sBigTommyIdle;
        xSpeed = 0;
        if (instance_exists(_target)) image_xscale = (_target.x > x) ? -1 : 1;

        attackTimer--;
        if (attackTimer <= 0) {
            var _pool = [];
            
            // Limit Slides to 2
            if (slideCount < 2) array_push(_pool, "PRE_SLIDE");
            
            // Only Snap if not against a wall (100px margin)
            if (!place_meeting(x - 100, y, oWall) && !place_meeting(x + 100, y, oWall)) {
                array_push(_pool, "SNAP");
            }
            
            // Always allow Jump
            array_push(_pool, "PRE_JUMP");

            var _choice = _pool[irandom(array_length(_pool) - 1)];
            state = _choice;
            
            if (state == "PRE_SLIDE") { bendTimer = 20; sprite_index = sBigTommyBend; slideCount++; }
            else if (state == "PRE_JUMP") { bendTimer = 20; sprite_index = sBigTommyBend; slideCount = 0; }
            else { image_index = 0; hasSpawned = false; sprite_index = sBigTommySnap; slideCount = 0; }
        }
        break;

    case "PRE_JUMP":
        bendTimer--;
        if (bendTimer <= 0) {
            state = "JUMP";
            sprite_index = sBigTommyJump;
            
            // THE ARC FIX: Set speeds ONCE
            ySpeed = -9.1; // Exactly 150px height
            y -= 5;        // Prevent instant landing
            
            if (instance_exists(_target)) {
                // Total air time = 2 * (v / g) = 2 * (9.1 / 0.275) approx 66 frames
                var _totalTime = 66; 
                var _distX = _target.x - x;
                xSpeed = _distX / _totalTime;
            }
            jumpTimer = 20; // Grace period
        }
        break;

    case "JUMP":
        ySpeed += grav; 
        jumpTimer--;

        // --- NEW: CRUSH PLAYER LOGIC ---
        // If falling, check if we're about to land on the player
        if (ySpeed > 0) {
            var _hitPlayer = instance_place(x, y + ySpeed, oPlayer);
            if (_hitPlayer != noone && !_hitPlayer.stunned) {
                // Deal damage or knockback
                with (_hitPlayer) {
                    // Replace '1' with your damage amount
                    hp -= 10; 
                }
            }
        }

        // --- LANDING DETECTION ---
        if (jumpTimer <= 0 && ySpeed > 0 && place_meeting(x, y + ySpeed, oWall)) {
            
            // 1. STUCK FIX: Precise "Pixel Snap" to the floor
            while (!place_meeting(x, y + sign(ySpeed), oWall)) {
                y += sign(ySpeed);
            }
            
            // 2. TRIGGER CAMERA SHAKE
            if (instance_exists(oCamera)) {
                oCamera.shakeMag = 5; 
            }
            
            // 3. STUN PLAYER
            if (instance_exists(_target) && _target.onGround) {
                with (_target) {
                    stunned = true; 
                    stunTimer = 45; 
                    xSpeed = 0;
                }
            }
            
            // Reset vertical momentum and switch state
            ySpeed = 0;
            xSpeed = 0;
            state = "RECOVER";
            attackTimer = 80;
        }
        break;

    case "PRE_SLIDE":
        bendTimer--;
        if (bendTimer <= 0) {
            state = "SLIDE";
            sprite_index = sBigTommyCrouch;
            if (instance_exists(_target)) slideTargetX = _target.x;
        }
        break;

    case "SLIDE":
        var _dist = slideTargetX - x;
        xSpeed = lerp(xSpeed, sign(_dist) * 12, 0.1);
		if (Touching(oPlayer) && !oPlayer.invulnerable) {
				HPScript(-10);
			}
        if (abs(_dist) < 32 || place_meeting(x + xSpeed, y, oWall)) {
            state = "RECOVER";
            attackTimer = 60;
        }
        break;

    case "SNAP":
        if (floor(image_index) == 3 && !hasSpawned) {
            instance_create_layer(x - 80, y - 200, "Instances", oChristian);
            instance_create_layer(x + 80, y - 200, "Instances", oChristian);
            hasSpawned = true;
        }
        if (image_index >= image_number - 1) {
            state = "RECOVER";
            attackTimer = 45;
        }
        break;

    case "RECOVER":
        sprite_index = sBigTommyIdle;
        xSpeed = 0;
        attackTimer--;
        if (attackTimer <= 0) state = "IDLE";
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

if (state != "JUMP") {
    // Only use the standard gravity script when NOT in the custom Jump state
    EnemyG(id); 
}

x += xSpeed;
y += ySpeed; // Add this to ensure vertical movement is applied!


