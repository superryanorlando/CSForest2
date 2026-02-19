age++;

// --- MOVEMENT ---
// Straight line movement
x += moveSpeed * facing;


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

// --- COLLISION LOGIC ---
var _enemy = instance_place(x, y, oEnemy);

if (_enemy != noone) {
    // Check if the thing we hit is actually the boss
    if (_enemy.object_index == oMrSen || object_is_ancestor(_enemy.object_index, oMrSen)) {
        // It's the boss! 
        // We do NOTHING here. The boss's own code handles taking damage 
        // from the oBlueOrb only during his vulnerable state.
        
        // However, we destroy the orb so it doesn't pass through him
        instance_destroy();
    } 
    else {
        // It's a regular enemy
        _enemy.hp -= 1;
        instance_destroy();
    }
}
