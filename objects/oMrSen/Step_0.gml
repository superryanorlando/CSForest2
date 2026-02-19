// --- 1. MOVEMENT ---
if (state != "DEATH") {
    // Keep him glued to the left side of the camera
    x += scrollSpeed; 
	y += 0.5*sin(0.1*x);
} else {
    // Slow descent on death
	sprite_index = sMrSenIdle;
	x+=0.1;
    y += 0.5;
	image_blend = c_gray;
    if (y > room_height + 100) instance_destroy();
}

// --- 2. STATE MACHINE ---
switch(state) {
    case "IDLE":
        sprite_index = sMrSenIdle;
        timer++;
        
        // Pick an attack every 2 seconds (120 frames)
        if (timer >= 120) {
            timer = 0;
            var _attack = irandom(2);
            if (_attack == 0) state = "ORB1_PREP";
            else if (_attack == 1) state = "ORB2_PREP";
            else state = "LASER_PREP_OPEN";
        }
        break;

    case "ORB1_PREP": // 20 Frames
        timer++;
        sprite_index = (timer % 4 < 2) ? sMrSenPink : sMrSenIdle; // Rapid flicker
        if (timer >= 20) {
            instance_create_layer(x + orbX, y + orbY, "Instances", oMrSenOrb);
            timer = 0;
            state = "IDLE";
        }
        break;

    case "ORB2_PREP": // 40 Frames
        timer++;
        sprite_index = (timer % 4 < 2) ? sMrSenPink : sMrSenIdle;
        if (timer >= 40) {
            instance_create_layer(x + orbX, y + orbY, "Instances", oMrSenOrb2);
            timer = 0;
            state = "IDLE";
        }
        break;

    case "LASER_PREP_OPEN": // 5 Frames
        sprite_index = sMrSenOpen;
        timer++;
        if (timer >= 5) {
            timer = 0;
            state = "LASER_CHARGE";
        }
        break;

    case "LASER_CHARGE": // 90 Frames (VULNERABLE STATE)
		 timer++;
        sprite_index = sMrSenCharge;
        
        // --- DAMAGE LOGIC: Only takes damage from oBlueOrb ---
        // Define the hitbox boundaries based on your offsets
        var _x1 = x + hitboxX;
        var _y1 = y + hitboxY;
        var _x2 = _x1 + 50;
        var _y2 = _y1 + 30;
        
        // Look for the orb within the rectangle
        var _inst = collision_rectangle(_x1, _y1, _x2, _y2, oBlueOrb, false, true);
        
        if (_inst != noone) {
            hp -= 1;             // Take 1 damage
            flashTimer = 5;      // Flash white to show hit
            
            // Destroy the orb so it doesn't hit multiple times in one frame
            with (_inst) instance_destroy(); 
            
            // Optional: Add a small screen shake on hit
            if (instance_exists(oCamera)) oCamera.shakeMag = 5;
        }
        
        if (timer >= 90) {
            timer = 0;
            state = "LASER_FIRE";
        }
        break;

    case "LASER_FIRE": // 10 Frames
        if (timer == 0) {
            instance_create_layer(x + laserX, y + laserY, "Instances", oMrSenLaser);
        }
        sprite_index = sMrSenFire;
        timer++;
        if (timer >= 10) {
            timer = 0;
            state = "LASER_POST_OPEN"; // NEW STATE
        }
        break;

    case "LASER_POST_OPEN": // 5 Frames (Recovery)
        sprite_index = sMrSenOpen;
        timer++;
        if (timer >= 5) {
            timer = 0;
            state = "IDLE";
        }
        break;

    case "DEATH":
        // Generate explosions randomly over his body
        if (irandom(3) == 0) { // Every few frames
            var _exX = x + random_range(-60, 60);
            var _exY = y + random_range(-60, 60);
            instance_create_layer(_exX, _exY, "Instances", oExplosion);
        }
        break;
}

// --- 3. HEALTH CHECK ---
if (hp <= 0 && state != "DEATH") {
    state = "DEATH";
    // The camera will naturally stop moving because we check for this state in the camera step!
}