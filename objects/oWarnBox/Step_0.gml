timer--;
if (timer <= 0) instance_destroy();

// Blinking Logic: 
// Normal blink every 10 frames. 
// Fast blink (every 4 frames) when timer is below 15.
if (timer > 15) {
    image_alpha = (timer % 10 < 5) ? 0.6 : 0.1;
} else {
    image_alpha = (timer % 4 < 2) ? 0.8 : 0.0;
}