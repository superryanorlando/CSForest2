// Depth
depth = 0;

// Die check
if (hp <= 0 && !dead) dead = true;
if (dead) { instance_destroy(); exit; }

// Flash Logic
if (hp < hpPrev) {
    flashTimer = 2;
    hpPrev = hp;
}

// Find Arena Bounds (Once)
if (arenaLeft == 0 && instance_exists(oBossDoor)) {
    arenaLeft = instance_nearest(x, y, oBossDoor).x;
}

// --- STATE MACHINE ---
switch (state) {

    // 1. WAIT FOR FIGHT TO START
    case "WAIT_FOR_DOOR":
        if (instance_exists(oBossDoor)) {
            if (oBossDoor.state == "locked") {
                state = "COOLDOWN";
                attackTimer = 60; // 1 second buffer before starting
            }
        }
        break;

    // 2. IDLE / DECISION MAKING
    case "IDLE":
        canTurn = true;
        sprite_index = sDharmaIdle; 
        
        var _dist = distance_to_object(oPlayer);
        
        // Decision Logic
        if (swingCount < 2 && _dist < 70) {
            // SWING ATTACK
            state = "SWING_DASH";
            sprite_index = sDharmaSwing;
            image_index = 0;
            canTurn = false;
            
            // Dash Setup
            startX = x;
            targetX = oPlayer.x; 
            // Cap dash distance so he doesn't fly across screen
            var _dir = sign(targetX - startX);
            if (abs(targetX - startX) > 100) targetX = startX + (100 * _dir);
            
            attackTimer = 0;
            swingCount++;
        } else {
            // TOTEM JUMP (If too far OR swung twice already)
            state = "PRE_JUMP";
            sprite_index = sDharmaPreJump;
            image_index = 0;
            swingCount = 0; // Reset swing counter
            canTurn = false;
        }
        break;

    case "SWING_DASH":
        attackTimer++;
        var _duration = 30; // 0.5 seconds
		// Updated detection logic
		var _x1 = x;
		var _y1 = y - hitboxYOffset;
		var _x2 = x + (hitboxW * image_xscale * -1); 
		var _y2 = y - hitboxYOffset - hitboxH;

		if (collision_rectangle(_x1, _y1, _x2, _y2, oPlayer, false, true)) {
		    if (!oPlayer.invulnerable && !oPlayer.dead) {
		        with (oPlayer) {
					HPScript(-8);
					oPlayer.vX = oDharma.image_xscale * -8; 
                    oPlayer.vY = 0;   
				}
		    }
}
        
        // --- QUADRATIC EASE OUT FORMULA ---
        // progress goes from 0 to 1
        var _t = attackTimer / _duration;
        var _ease = 1 - (1 - _t) * (1 - _t); // This creates the "friction" feel
        
        x = lerp(startX, targetX, _ease);

        if (attackTimer >= _duration) {
            state = "COOLDOWN";
            attackTimer = 60;
        }
        break;

    // 4. TOTEM: PRE-JUMP (Dynamic Target Calculation)
    case "PRE_JUMP":
        if (image_index >= image_number - 1) {
            // Find the actual totem object
            var _target = instance_nearest(x, y, oDharmaTotem);
            
            if (_target != noone) {
                state = "JUMP_TO_TOTEM";
                sprite_index = sDharmaJump;
                
                // --- TARGET COORDINATES ---
                // Origin is Top-Centre, so _target.x and _target.y is the landing spot
                targetX = _target.x;
                targetY = _target.y+5;
                startX = x;
                startY = y;

                // --- THE MATH ---
                // 1. Calculate vertical velocity for a specific arc height
                var _peakHeight = 140; // Total height of the jump arc relative to ground
                ySpeed = -sqrt(2 * grav * _peakHeight);
                
                // 2. Calculate how long it takes to reach the peak, then fall to targetY
                var _timeToPeak = abs(ySpeed / grav);
                var _distToFall = targetY - (startY - _peakHeight);
                var _timeToFall = sqrt(abs(2 * _distToFall / grav));
                
                var _totalTime = _timeToPeak + _timeToFall;

                // 3. Set horizontal speed to arrive exactly on time
                xSpeed = (targetX - startX) / _totalTime;
            } else {
                // Failsafe if no totem is found
                state = "COOLDOWN";
                attackTimer = 60;
            }
        }
        break;

    // 5. TOTEM: JUMPING ARC
    case "JUMP_TO_TOTEM":
        x += xSpeed;
        ySpeed += grav;
        y += ySpeed;
        
        
        if (ySpeed > 0 && y >= targetY) {
            y = targetY; 
            x = targetX; //basically snaps to totem
            ySpeed = 0;
            xSpeed = 0;
            state = "ON_TOTEM";
            sprite_index = sDharmaTotem;
            attackTimer = 30;
        }
        break;

    // 6. ON TOTEM (Choose Attack)
    case "ON_TOTEM":
        attackTimer--;
        if (attackTimer <= 0) {
            // Randomly choose Projectile (0) or Vines (1)
            var _choice = irandom(1); 
            
            if (_choice == 0) {
                state = "TOTEM_ATTACK_P"; // Projectile
                sprite_index = sDharmaTotemWarn;
                attackTimer = 30; // Warn duration
                subState = 0; // Shots fired count
            } else {
                state = "TOTEM_ATTACK_V"; // Vines
                sprite_index = sDharmaTotemWarn;
                attackTimer = 45; // Warn duration (0.75s)
                subState = 0; // Burst count
            }
        }
        break;

    // 7. TOTEM ATTACK: PROJECTILES
    case "TOTEM_ATTACK_P":
        // Phase 1: Warning
        if (sprite_index == sDharmaTotemWarn) {
            attackTimer--;
            if (attackTimer <= 0) {
                sprite_index = sDharmaTotemAttack;
                image_index = 0;
                attackTimer = 15; // Time between shots (0.25s)
            }
        } 
        // Phase 2: Shooting
        else {
            attackTimer--;
            if (attackTimer <= 0) {
                // Fire Shot
                var _p = instance_create_layer(x, y - 40, "Instances", oDharmaProjectile);
                if (instance_exists(oPlayer)) {
                    _p.direction = point_direction(x, y - 40, oPlayer.x, oPlayer.y);
                    _p.image_angle = _p.direction;
                }
                
                subState++; // Count shots
                attackTimer = 15; // Reset shot timer
                
                if (subState >= 4) {
                    state = "JUMP_DOWN"; // Done shooting
                }
            }
        }
        break;

    case "TOTEM_ATTACK_V":
        if (sprite_index == sDharmaTotemWarn) {
            attackTimer--;
            if (attackTimer <= 0) {
                sprite_index = sDharmaTotemAttack;
                image_index = 0;
                burstTimer = 0; 
            }
        }
        else {
            // Handle delay between bursts
            if (burstTimer > 0) {
                burstTimer--;
                image_index = 0; // Freeze Dharma's animation during the pause
            } 
            else if (image_index >= image_number - 1) {
                
                // BURST 1: Spaced out more
                if (subState == 0) {
                    for (var i = arenaLeft; i < arenaLeft + 512; i += (vineWidth * 2)) {
                        instance_create_layer(i, groundY, "Instances", oSpikedVine);
                        instance_create_layer(i, groundY, "Instances", oWarnBox);
                    }
                    subState = 1;
                    burstTimer = burstDelay; // Set the delay
                }
                // BURST 2: Spaced out and offset
                else if (subState == 1) {
                    var _offset = (vineWidth * 1.5); // Center the vines in the previous gaps
                    for (var i = arenaLeft + _offset; i < arenaLeft + 512; i += (vineWidth * 2)) {
                        instance_create_layer(i, groundY, "Instances", oSpikedVine);
                        instance_create_layer(i, groundY, "Instances", oWarnBox);
                    }
                    subState = 2;
                    burstTimer = burstDelay; // Set the delay
                }
                // BURST 3: Tracking Player 
                else if (subState >= 2 && subState < 5) {
                    instance_create_layer(oPlayer.x, groundY, "Instances", oSpikedVine);
                    instance_create_layer(oPlayer.x, groundY, "Instances", oWarnBox);
                    subState++;
                    burstTimer = 0; // 0.5s delay for tracking vines
                }
                else {
                    state = "JUMP_DOWN";
                }
                
                // Reset animation index so it can play again for the next burst
                if (state == "TOTEM_ATTACK_V") image_index = 0;
            }
        }
        break;

    case "JUMP_DOWN":
        // 1. Setup the Jump (Runs once)
        if (xSpeed == 0 && ySpeed == 0) {
            sprite_index = sDharmaJump;
            startX = x;
            jumpStartY = y; // Current totem height
            targetX = arenaLeft + 200; // Aim for arena center
            
            // We want to jump UP slightly before falling
            ySpeed = -4; 
            
            // Calculate xSpeed based on distance and gravity
            // This is a simplified "feel-good" arc
            var _dist = targetX - startX;
            xSpeed = _dist / 60; // Travel over 1 second
        }

        // 2. Physics
        x += xSpeed;
        ySpeed += grav;
        y += ySpeed;

        // 3. Land on Ground
        if (y >= groundY) {
            y = groundY;
            xSpeed = 0;
            ySpeed = 0;
            state = "COOLDOWN";
            attackTimer = 120; // 2 seconds
        }
        break;

    // 10. COOLDOWN
    case "COOLDOWN":
        sprite_index = sDharmaIdle;
        canTurn = true;
        attackTimer--;
        if (attackTimer <= 0) {
            state = "IDLE";
        }
        break;
}

// --- FACING LOGIC ---
if (canTurn && instance_exists(oPlayer)) {
    if (oPlayer.x < x) {
        image_xscale = 1; // Face Left (assuming sprite faces left by default)
    } else {
        image_xscale = -1; // Face Right
    }
}
