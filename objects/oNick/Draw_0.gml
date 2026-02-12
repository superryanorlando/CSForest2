// If the flash timer is active, turn the sprite pure white
if (flashTimer > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    gpu_set_fog(false, c_white, 0, 0);
    
    flashTimer--; // Countdown the flash
} else {
    // Normal draw
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

if (isAttacking) {
	sprite_index = sNickThrow;
} else {
	sprite_index = sNickIdle;
}