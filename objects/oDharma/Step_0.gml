// Depth
depth = -9000;

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
		        with (oPlayer) HPScript(-8);
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

    // 4. TOTEM: PRE-JUMP
    case "PRE_JUMP":
        // Wait for animation end
        if (image_index >= image_number - 1) {
            state = "JUMP_TO_TOTEM";
            sprite_index = sDharmaJump;
            
            // Setup Parabola to Totem
            startX = x;
            jumpStartY = y;
            var _jumpH = 120; // Height of arc
            
            // Math: v = sqrt(2 * g * h)
            ySpeed = -sqrt(2 * grav * _jumpH);
            var _time = abs(ySpeed / grav); // Time to peak
            // Total time to land at y-80 is tricky, so let's aim for PEAK at totemX
            // This simplifies math: He peaks exactly at the totem's X and Y
            
            // Adjust Totem Target Y slightly
            targetX = totemX;
            var _totalTime = _time * 2; // Rough estimate
            xSpeed = (targetX - startX) / _totalTime;
        }
        break;

    // 5. TOTEM: JUMPING ARC
    case "JUMP_TO_TOTEM":
        x += xSpeed;
        ySpeed += grav;
        y += ySpeed;
        
        // Land on Totem Logic
        // If falling AND we hit the totem height
        if (ySpeed > 0 && y >= totemY) {
            y = totemY;
            ySpeed = 0;
            xSpeed = 0;
            state = "ON_TOTEM";
            sprite_index = sDharmaTotem;
            attackTimer = 30; // Brief pause before attacking
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
                var _p = instance_create_layer(x, y - 20, "Instances", oDharmaProjectile);
                if (instance_exists(oPlayer)) {
                    _p.direction = point_direction(x, y - 20, oPlayer.x, oPlayer.y);
                    _p.image_angle = _p.direction;
                }
                
                subState++; // Count shots
                attackTimer = 15; // Reset shot timer
                
                if (subState >= 3) {
                    state = "JUMP_DOWN"; // Done shooting
                }
            }
        }
        break;

    case "TOTEM_ATTACK_V":
        if (sprite_index == sDharmaWarn) {
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
                    for (var i = arenaLeft; i < arenaLeft + 512; i += (vineWidth * 3)) {
                        instance_create_layer(i, groundY, layer, oSpikedVine);
                        instance_create_layer(i, groundY, layer, oWarnBox);
                    }
                    subState = 1;
                    burstTimer = burstDelay; // Set the delay
                }
                // BURST 2: Spaced out and offset
                else if (subState == 1) {
                    var _offset = (vineWidth * 1.5); // Center the vines in the previous gaps
                    for (var i = arenaLeft + _offset; i < arenaLeft + 512; i += (vineWidth * 3)) {
                        instance_create_layer(i, groundY, layer, oSpikedVine);
                        instance_create_layer(i, groundY, layer, oWarnBox);
                    }
                    subState = 2;
                    burstTimer = burstDelay; // Set the delay
                }
                // BURST 3: Tracking Player (Wait 0.5s between each of the 3 vines)
                else if (subState >= 2 && subState < 5) {
                    instance_create_layer(oPlayer.x, groundY, layer, oSpikedVine);
                    instance_create_layer(oPlayer.x, groundY, layer, oWarnBox);
                    subState++;
                    burstTimer = 30; // 0.5s delay for tracking vines
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
