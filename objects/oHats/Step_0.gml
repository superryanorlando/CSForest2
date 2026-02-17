// Define Arena Bounds (Simple version: 32px from room edges)
// Or use oWall detection
if (place_meeting(x + 32, y, oWall)) arenaRight = x; // Dynamic wall check if needed

switch (state) {
    case "WAIT_FOR_DOOR":
        if (instance_exists(oBossDoor) && oBossDoor.state == "locked") {
            state = "IDLE";
            waitTimer = 20; // Start immediately
            // Ensure facing player
            if (instance_exists(oPlayer)) dir = sign(oPlayer.x - x);
            if (dir == 0) dir = 1;
            image_xscale = dir;
        }
        break;

    case "IDLE":
		turnsThisDash = 0;
        sprite_index = sHatsIdle;
        xSpeed = 0;
        waitTimer--;
        
        // Turn to face direction of travel
        image_xscale = -dir; 

        if (waitTimer <= 0) {
            state = "SPEED_UP";
            sprite_index = sHatsSpeedUp;
            image_index = 0;
        }
        break;

    case "SPEED_UP":
        // Wait for animation to finish
        if (image_index >= image_number - 1) {
            state = "MOVING";
            sprite_index = sHatsMoving;
            checkedTurn = false; // Reset trick mechanic
        }
        break;

    case "MOVING":
	// --- 1. MOVEMENT CALCULATIONS ---
	image_xscale = -dir;
	xSpeed = lerp(xSpeed, moveSpeedMax * dir, 0.1);

	// --- 2. ARENA BOUNDARY & WALL COLLISION ---
	var _subpix = 0.5;
	// Check if hitting an oWall OR exceeding the oLine boundaries
	var _atEdge = false;
	if (instance_exists(oLine)) {
	    var _line = instance_nearest(x, y, oLine);
	    if (dir == 1 && x >= _line.bbox_right - 32) _atEdge = true;
	    if (dir == -1 && x <= _line.bbox_left + 32) _atEdge = true;
	}

	// Hard Collision (Your provided logic)
	if (place_meeting(x + xSpeed, y, oWall) || _atEdge) {
	    if (!_atEdge && !place_meeting(x + xSpeed, y - abs(xSpeed) - 1, oWall)) {
	        while (place_meeting(x + xSpeed, y, oWall)) { y -= _subpix; }
	    } else {
	        // If it's a hard wall or the arena edge, stop and prepare to flip
	        var _thing = _subpix * sign(xSpeed);
	        while (!place_meeting(x + _thing, y, oWall) && !_atEdge) { x += _thing; }
        
	        xSpeed = 0;
	        state = "IDLE";
	        waitTimer = irandom_range(20, 60);
	        dir *= -1; // Prepare to face the other way
	    }
	}

		// Apply Horizontal Movement
		x += xSpeed;

		// --- 3. SLOPE & GRAVITY ---
		if (ySpeed >= 0) && !place_meeting(x + xSpeed, y + 1, oWall) && place_meeting(x + xSpeed, y + abs(xSpeed) + 1, oWall) {
		    while (!place_meeting(x + xSpeed, y + _subpix, oWall)) { y += _subpix; }
		}

		EnemyG(id); // Use your gravity script
        // 1. Find the arena bounds once
		if (!boundsSet && instance_exists(oLine)) {
		    var _inst = instance_nearest(x, y, oLine);
		    edgeLeft = _inst.bbox_left + 32;
		    edgeRight = _inst.bbox_right - 32;
		    boundsSet = true;
		}

		

		// 3. UPDATED EDGE DETECTION (Uses oLine instead of Room Width)
		var _distToEdge = (dir == 1) ? (edgeRight - x) : (x - edgeLeft);

		if (_distToEdge < 64) {
		    xSpeed = lerp(xSpeed, 0, 0.2); // Decelerate
    
		    if (abs(xSpeed) < 0.5) {
		        x = (dir == 1) ? edgeRight : edgeLeft; // Snap to edge
		        dir *= -1; 
		        state = "IDLE";
		        waitTimer = irandom_range(20, 60);
		    }
			}
	// 2. THE FAKE OUT (Only once per dash)
	    if (instance_exists(oPlayer) && !checkedTurn && turnsThisDash < 1) {
	        if (oPlayer.y < y - 20 && abs(x - oPlayer.x) < 24) {
	            checkedTurn = true; 
	            if (random(100) < 40) {
	                state = "TURN_AROUND";
	                turnsThisDash++; // Lock the ability to turn again
	            }
	        }
	    }
        
        // DAMAGE PLAYER
        if (place_meeting(x, y, oPlayer)&&instance_exists(oHibs)) {
             if (!oPlayer.invulnerable) with(oPlayer) HPScript(-5);
        }
        break;
        
    case "TURN_AROUND": 
    xSpeed = lerp(xSpeed, 0, 0.04); 
    
    if (abs(xSpeed) < 0.8) {
        dir *= -1; 
        image_xscale = -dir; // Stay synced with direction
        state = "SPEED_UP"; 
        sprite_index = sHatsSpeedUp;
        image_index = 0;
    }
    x += xSpeed;
    break;
}

// DEATH LOGIC (Only if Hibs is dead)
if (!instance_exists(oHibs)) {
    // Shield is gone, now vulnerable
    if (place_meeting(x, y, oPlayer)) {
        // One hit kill
        instance_destroy();
        // Trigger Victory Sequence
    }
}