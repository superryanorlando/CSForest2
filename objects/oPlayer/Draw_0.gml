// --- ANIMATION CONTROLLER ---

if (isAttacking) {
    
    image_speed = 1; 
    
    // Optional: If your sprites have exactly 18 frames, 
    // you can manually sync them to the attackTimer:
    // image_index = floor(((attackDuration - attackTimer) / attackDuration) * image_number);

} else {
    // Only run movement animations if NOT attacking
    if (onGround) {
        if (abs(xSpeed) > 0) {
            sprite_index = sGoddardWalk;
            image_speed = 1;
        } else {
            sprite_index = sGoddardIdle;
            image_speed = 0;
            image_index = 0; // Keep it on the first frame of idle
        }
    } else {
        // Air logic
        if (ySpeed < -3) {
            sprite_index = sGoddardJump0;
        } else if (ySpeed < 0) {
            sprite_index = sGoddardJump;
        } else {
            sprite_index = sGoddardFall;
        }
    }
}

// Final Draw
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);