// 1. Movement logic
var _targetX = oPlayer.x;
var _targetY = oPlayer.y;
anchorX = x;
anchorY = y;
moveSpd = 3.5;
dir = point_direction(x, y, _targetX, _targetY);

// 2. Orbital logic
angle = 0;
orbitSpd = 10;     // Speed of the rotation
orbitRadius = 24; // How far the orb is from the center point