//basic enemy stuff

xSpeed = 0;
ySpeed = 0;

grav = 0.275;
termVelocity = 6;
onGround = true;

maxHP = 5
hp = maxHP;
flashTimer = 0;
hpPrev = hp;
hitList = ds_list_create(); // To store entities hit
dead = false;

state = "IDLE";
aggroDist = 110;
cooldownMax = 30; // 30 frame delay after swinging
canTurn = true;
hasShot = false; // Prevents multiple paintballs on one frame
// --- ADJUSTABLE SPAWN POINT ---
// Adjust these based on your sprite's hand position
shotOffsetX = 20; // How far in front of the origin the ball spawns
shotOffsetY = -36; // How far above/below the origin (negative is UP)
// --- HITBOX SETTINGS ---
hitList = ds_list_create();
boxWidth = 30;
boxHeight = 40;

// (Keep your existing stats/states here)