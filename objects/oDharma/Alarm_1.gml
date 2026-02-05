// 1. Get the direction: positive if player is to the right, negative if to the left
var _dir = sign(oPlayer.x - x);

// 2. Apply acceleration in that direction
xSpeed += 10 * _dir;

// 3. Your friction loop (simulates drag/deceleration)
for (var i = 0; i <= 99; i++) {
    xSpeed *= 0.9
}

// Update the actual position
x += xSpeed;

show_debug_message("Moving towards player!");