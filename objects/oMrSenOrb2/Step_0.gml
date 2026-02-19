// Move the "Anchor Point" toward where the player was
anchorX += lengthdir_x(moveSpd, dir);
anchorY += lengthdir_y(moveSpd, dir);

// Spin the angle
angle += orbitSpd;

// Position the projectile relative to the anchor
x = anchorX + lengthdir_x(orbitRadius, angle);
y = anchorY + lengthdir_y(orbitRadius, angle);

// Hit Player Logic
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.invulnerable && !oPlayer.dead) {
        with (oPlayer) {
            HPScript(-5); 
        }
        instance_destroy();
    }
}

// Cleanup
if (x < camera_get_view_x(view_camera[0]) - 64 || x > camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) + 64) {
    instance_destroy();
}