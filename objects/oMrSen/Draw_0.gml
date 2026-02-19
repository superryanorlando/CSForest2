// 1. Draw the Boss (with flash effect)
if (variable_instance_exists(id, "flashTimer") && flashTimer > 0) {
    flashTimer--;
    gpu_set_fog(true, c_white, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else {
    draw_self();
}

// 2. Draw the Hitbox (ONLY during Charge and if Debug is on)
if (state == "LASER_CHARGE" && showDebugHitbox) {
    draw_set_color(c_lime);
    
    var _x1 = x + hitboxX;
    var _y1 = y + hitboxY;
    var _x2 = _x1 + 50;
    var _y2 = _y1 + 30;
    
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    
    // Also draw a label so you know what it is
    draw_text(_x1, _y1 - 15, "VULNERABLE");
    
    draw_set_color(c_white); 
}