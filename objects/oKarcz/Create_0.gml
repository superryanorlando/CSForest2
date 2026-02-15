// --- PHYSICS (Standard) ---
xSpeed = 0;
ySpeed = 0;
grav = 0.275;
termVelocity = 6;
onGround = true;

// --- STATS ---
maxHP = 5;
hp = maxHP;
dead = false;
flashTimer = 0;
hpPrev = hp;

// --- STATE MACHINE ---
state = "IDLE"; // States: IDLE, ALERT, ATTACK, COOLDOWN
facingDir = -1; // -1 = Left, 1 = Right

// --- TIMERS ---
alertTime = 45;   // 0.75 seconds (at 60fps)
attackDuration = 30; // How long the punch stays extended
cooldownTime = 120; // 2 seconds

// --- HITBOX LOGIC ---
hitList = ds_list_create(); // To store entities hit
debugShowHitbox = false;    // Toggles the red box drawing