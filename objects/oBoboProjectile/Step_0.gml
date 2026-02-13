age++;
x += xspd;
y = startY + -1*sin(age * frequency) * amplitude;


if (Touching(oPlayer) && !oPlayer.invulnerable) {
    HPScript(-6);
    instance_destroy();
}

// --- LIFECYCLE (Blinking and Deletion) ---

// After 3 seconds (maxAge), start blinking
if (age >= maxAge) {
    // This toggles visibility every 4 frames (0,1 is off, 2,3 is on)
    if (age % 4 < 2) {
        image_alpha = 0;
    } else {
        image_alpha = 1;
    }
}

// After the blink duration ends, delete it
if (age >= (maxAge + blinkDuration)) {
    instance_destroy();
}