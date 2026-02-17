// --- EXISTING FLASH CODE ---
if (flashTimer > 0) {
    gpu_set_fog(true, c_white, 0, 0);
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
    gpu_set_fog(false, c_white, 0, 0);
    flashTimer--;
} else {
    draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
}

// --- DEBUG HITBOX (Visualizer) ---
if (state == "PUNCH" && image_index >= 1 && image_index <= 2) {
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    var _x1 = x;
    var _y1 = y - hitboxYOffset;
    var _x2 = x + (hitboxW * -image_xscale); 
    var _y2 = y - (hitboxYOffset + hitboxH);
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1);
}