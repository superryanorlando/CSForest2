switch(state) {
    case 0: // WAITING
        timer--;
        if (timer <= 0) {
            state = 1;
            timer = 4; // Very fast strike (4 frames)
        }
        break;

    case 1: // STRIKING
        // Move from bottom to ground level
        y = lerp(y, groundY, 0.5); 
        
        if (abs(y - groundY) < 1) {
            y = groundY;
            state = 2;
            timer = 10; // Hold for 10 frames
        }
        break;

    case 2: // HOLDING
        timer--;
        if (timer <= 0) state = 3;
        break;

    case 3: // RETRACTING
        y += 15; // Quickly drop back down
        if (y > 224 + 256) instance_destroy();
        break;
}

// Damage logic (only during strike and hold)
if (state == 1 || state == 2) {
    if (place_meeting(x, y, oPlayer)) {
        if (!oPlayer.invulnerable) { with(oPlayer) HPScript(-8); }
    }
}