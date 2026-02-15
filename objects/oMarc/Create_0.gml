// --- PHYSICS (Standard) ---
xSpeed = 0;
ySpeed = 0;
grav = 0.275;
termVelocity = 6;
onGround = true;

// --- STATS ---
maxHP = 5;
hp = maxHP;
hpPrev = hp;
flashTimer = 0;
dead = false;

// --- STATE MACHINE ---
state = "HIDDEN"; // States: HIDDEN, SURPRISE, JUMP_UP, HOVER, SLAM, LAND_RECOVERY, COOLDOWN, SLEEP, ALERT
stompCount = 0;   // Counts up to 3
jumpStartY = y;   // Stores the ground level Y to calculate height

// --- TIMERS ---
hoverTimer = 0;   // The 10-frame pause at the top
cooldownTimer = 0;
animTimer = 0;    // Generic timer for animations (Surprise/Stomp)

// --- JUMP LOGIC ---
targetX = 0;
jumpHeight = 150; // Pixels