// Draw the Boss as normal
if (flashTimer > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    gpu_set_fog(false, c_white, 0, 0);
    
    flashTimer--; // Countdown the flash
} else {
    // Normal draw
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}


// --- HITBOX DEBUG VISUALIZER ---
if (true && state == "SWING_DASH") {
    var _hitW = 30;
    var _hitH = 15;
    // Calculate coordinates exactly like the collision check
	var _x1 = x;
	var _y1 = y - hitboxYOffset;
	var _x2 = x + (hitboxW * image_xscale * -1); 
	var _y2 = y - hitboxYOffset - hitboxH;
	
    draw_set_alpha(0.4);
    draw_set_color(c_red);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
