age++;

// --- MOVEMENT ---
// Straight line movement
x += moveSpeed * facing;

// (Optional: If you want the sine wave movement instead, uncomment below)
// y = ystart + -1 * sin(age * 0.1) * 2; 

// --- LIFECYCLE ---

// Start blinking after 2 seconds
if (age >= blinkStartAge) {
    // Toggle visibility every few frames
    if ((age div 4) mod 2 == 0) {
        image_alpha = 1;
    } else {
        image_alpha = 0;
    }
}

// Die after 3 seconds
if (age >= maxAge) {
    instance_destroy();
}

// --- COLLISION (Placeholder) ---
// Since this is a player attack, checking for oPlayer collision 
// usually hurts the player. Assuming this hurts ENEMIES:

var _enemy = instance_place(x, y, oEnemy);
if (_enemy != noone) {
    _enemy.hp -= 1;
    instance_destroy();
}
