// --- STATS ---
hp = 99;
maxHP = 99; // Hibs is 99, Hats is 1. Total 100.
dead = false;
state = "WAIT_FOR_DOOR"; 

// --- MOVEMENT ---
startX = x;
startY = y;
moveSpeed = 2;
targetX = x;
lineRef = noone; // Reference to oLine
boundLeft = 0;
boundRight = room_width;

// --- ATTACK LOGIC ---
attackTimer = irandom_range(60, 180);
snowballCount = 0;      // Projectiles thrown in current volley
volleyCount = 0;        // How many volleys thrown total
vulnerableTimer = 0;
snowballMax = 3; // Initial default value
// Add these to existing variables
invulnTimer = 0;
flashTimer = 0;
hasThrown = false; // Prevents spawning multiple snowballs on one frame

// --- SPAWN SETTINGS ---
snowballSpawnX = 15;     // Offset from center
snowballSpawnY = 20;    // Below the car

// --- VISUALS ---
suspender = instance_create_layer(x, y - 60, layer, oCarSuspender);
suspender.target = id;
flashTimer = 0;
deathTimer = 0; // For the explode/flash sequence
spr_hp = sbosshpbar; // Ensure you have this