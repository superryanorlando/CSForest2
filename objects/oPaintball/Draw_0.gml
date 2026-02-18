// Flash in and out during the last 60 frames (1 second)
var _drawMe = true;
if (lifespan < 60) {
    // Toggles visibility every 5 frames
    if ((lifespan div 5) % 2 == 0) _drawMe = false;
}

if (_drawMe) {
    draw_self();
}