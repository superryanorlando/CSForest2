draw_self();

// Draw the 50x30 vulnerability hitbox ONLY during the charge state
if (state == "LASER_CHARGE" && showDebugHitbox) {
    draw_set_color(c_lime);
    
    var _left = x + hitboxX;
    var _top = y + hitboxY;
    var _right = _left + 50;
    var _bottom = _top + 30;
    
    draw_rectangle(_left, _top, _right, _bottom, true);
    
    // Reset color to white so we don't tint the rest of the game
    draw_set_color(c_white); 
}