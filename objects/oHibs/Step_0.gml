// Find bounds (run once)
if (lineRef == noone && instance_exists(oLine)) {
    lineRef = instance_nearest(x, y, oLine);
    boundLeft = lineRef.bbox_left + 16;
    boundRight = lineRef.bbox_right - 16;
}

if (hp <= 0 && state != "DEATH") {
    state = "DEATH";
    sprite_index = sHibsExplode;
    image_index = 0;
}

if (oPlayer.x > x) {
        image_xscale = -1; // Right
    } else {
        image_xscale = 1;  // Left
    }

// --- 1. TIMERS (Always at the top, outside the switch) ---
if (invulnTimer > 0) invulnTimer--;
if (flashTimer > 0) flashTimer--;

// --- 2. DEATH CHECK ---
if (hp <= 0 && state != "DEATH") {
    state = "DEATH";
    sprite_index = sHibsExplode;
    image_index = 0;
}

// --- 3. STATE MACHINE ---
switch (state) {
    case "WAIT_FOR_DOOR":
        if (instance_exists(oBossDoor) && oBossDoor.state == "locked") {
            state = "HOVER";
        }
        break;

    case "HOVER":
        sprite_index = sHibsIdle;
        // Movement logic (Stay 50px from player)
        if (instance_exists(oPlayer)) {
            var _idealX = oPlayer.x + (50 * -sign(oPlayer.x - x));
            _idealX = clamp(_idealX, boundLeft, boundRight);
            x = lerp(x, _idealX, 0.05);
        }

        attackTimer--;
        if (attackTimer <= 0) {
            state = "THROW";
            snowballCount = 0;
            hasThrown = false; 
            snowballMax = irandom_range(3, 5); 
            image_index = 0; // Start animation from frame 1
        }
        break;

    case "THROW":
        sprite_index = sHibsThrow;
    
    // Spawn snowball on the 3rd frame (index 2)
    if (floor(image_index) == 2 && !hasThrown) {
        var _ball = instance_create_layer(x + snowballSpawnX, y + snowballSpawnY, layer, oSnowball);
        var _pDir = (instance_exists(oPlayer)) ? sign(oPlayer.x - x) : 1;
        _ball.hSpeed = 4 * _pDir;
        hasThrown = true;
    }

    // WAIT FOR FULL ANIMATION: We check for > 2.8 to ensure frame 2 actually plays
    if (image_index >= image_number - 0.2) {
        snowballCount++;
        hasThrown = false; 
        
        if (snowballCount >= snowballMax) {
            volleyCount++;
            state = (volleyCount >= 2) ? "LOWERING" : "HOVER";
            attackTimer = irandom_range(60, 180);
            sprite_index = sHibsIdle;
        } else {
            image_index = 0; // Restart animation for next ball in volley
        }
    }
    break;

    case "LOWERING":
		sprite_index = sHibsIdle
        y = lerp(y, startY + 10, 0.1);
        if (abs(y - (startY + 10)) < 1) {
            y = startY + 10;
            state = "VULNERABLE";
            vulnerableTimer = 300; 
        }
        break;

    case "VULNERABLE":
		
        vulnerableTimer--;
        
        // DAMAGE LOGIC
        if (place_meeting(x, y, oPlayer) && invulnTimer <= 0) {
            hp -= 2;
            invulnTimer = 45; // 0.5 seconds of invulnerability
            flashTimer = 2;
            if (oPlayer.y < y) oPlayer.ySpeed = -4; 
        }

        if (vulnerableTimer <= 0) state = "RISING";
        break;
        
    case "RISING":
        y = lerp(y, startY, 0.1);
        if (abs(y - startY) < 1) {
            y = startY;
            state = "HOVER";
            attackTimer = irandom_range(60, 180);
        }
        break;

    case "DEATH":
        // Wait for animation end
        if (image_index >= image_number - 1) {
            image_speed = 0; // Stop anim on last frame
            // Ensure the explosion animation plays out
        if (image_index >= image_number - 1) {
            image_speed = 0; // Freeze on last frame
            
            // Spawn the flash controller to take over
            instance_create_layer(0, 0, "Instances", oScreenFlash);
            
            // Note: oScreenFlash's Create event will handle the instance_destroy(id)
        }
        break;
}
}

if (flashTimer > 0) flashTimer--;
if (invulnTimer>0) {
	image_alpha = 0.75;
} else {
	image_alpha = 1;
}
