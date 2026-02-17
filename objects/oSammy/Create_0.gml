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
state = "IDLE";
attackTimer = 0;
canTurn = true;

// --- DASH & ATTACK SETTINGS ---
aggroDist = 100;      // Distance to start dashing
stopDist = 12;       // TOGGLEABLE: Distance from player to start applying friction
dashPower = 5;       // Initial dash speed
frictionPower = 0.75; // How quickly he slows down (lower = faster stop)

// --- HITBOX SETTINGS ---
hitboxW = 22;
hitboxH = 12;
hitboxYOffset = 30; // 20px above the bottom-center origin
