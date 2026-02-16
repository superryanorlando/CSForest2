if (x < 0 || x > room_width || y < 0 || y > room_height) instance_destroy();

// Hit Player Logic
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.invulnerable && !oPlayer.dead) {
        with (oPlayer) {
            HPScript(-5); 
            // Optional: Knockback code here
        }
        instance_destroy();
    }
}
