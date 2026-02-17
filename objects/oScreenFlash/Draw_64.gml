flashTimer++;

// Flash Sequence:
// Frames 1-2: White
// Frames 3-4: Gap (Clear)
// Frames 5-6: White
// Frame 7+: Destroy controller

if ((flashTimer >= 1 && flashTimer <= 2) || (flashTimer >= 5 && flashTimer <= 6)) {
    draw_set_color(c_white);
    draw_set_alpha(1);
    // Draw a rectangle over the entire GUI layer
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}

if (flashTimer > 6) {
    instance_destroy();
}