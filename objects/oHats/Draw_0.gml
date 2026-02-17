draw_self();

// Draw Shield if Hibs is alive
if (instance_exists(oHibs)) {
    // Flashing Semi-Transparent Circle
    var _alpha = 0.3 + lengthdir_x(0.2, current_time * 0.5); // Oscillate alpha
    draw_set_alpha(_alpha);
    draw_set_color(c_aqua); // Sci-fi shield color
    draw_circle(x, y - (sprite_height/2), 24, false); // Adjust radius (24) as needed
    
    // Reset
    draw_set_alpha(1);
    draw_set_color(c_white);
}