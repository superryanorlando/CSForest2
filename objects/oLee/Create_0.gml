// --- PHYSICS ---
xSpeed = 0;
ySpeed = 0;
grav = 0.275;
termVelocity = 6;
onGround = true;

// --- STATS ---
maxHP = 5;
hp = maxHP;
dead = false;
hpPrev = hp;
flashTimer = 0;

// --- STATE MACHINE ---
state = "IDLE"; // States: IDLE, RAISE, WARN, ATTACK, COOLDOWN
facingDir = 1;  // 1 = Right, -1 = Left

// --- TIMERS & COUNTERS ---
warnTime = 45;      // 0.75 seconds (at 60fps)
cooldownTime = 90;  // 1.5 seconds (at 60fps)

attackLoopCounter = 0; // Tracks how many times we've played the attack anim
hasFired = false;      // Ensures we only fire one bullet per loop