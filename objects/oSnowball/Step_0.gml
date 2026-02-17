vSpeed += grav;
x += hSpeed;
y += vSpeed;


// Hit Player
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.invulnerable && !oPlayer.dead) {
        with (oPlayer) HPScript(-4);
        instance_destroy();
    }
}

// Cleanup
if (y > room_height) instance_destroy();