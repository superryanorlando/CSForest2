x += hSpeed;

// Temporary: Remove room_width check for a second to see if it shows up
// if (x < 0 || x > room_width) instance_destroy();

if (place_meeting(x, y, oPlayer)) {
    // Damage logic...
    instance_destroy();
}

// Collision with Player
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.invulnerable) {
        with(oPlayer) HPScript(-2); 
        instance_destroy();
    }
}
