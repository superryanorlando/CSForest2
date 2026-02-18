x += hSpeed;
lifespan--;

// Disappear logic
if (lifespan <= 0) {
    instance_destroy();
}

// Collision with Player
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.invulnerable) {
        with(oPlayer) HPScript(-1); 
        instance_destroy();
    }
}