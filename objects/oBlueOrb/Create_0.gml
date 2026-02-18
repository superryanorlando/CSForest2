// Configuration
moveSpeed = 4;
facing = 1; // Default, will be overwritten by oPlayer upon creation

// Timers (assuming 60 FPS)
age = 0;
blinkStartAge = 120; // 2 seconds * 60 fps
maxAge = 180;        // 3 seconds (2 sec travel + 1 sec blink)