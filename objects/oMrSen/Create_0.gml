// --- CORE STATS ---
maxHP = 33;
hp = maxHP;
state = "IDLE";
timer = 0;
scrollSpeed = 0.75; // Must match oCameraAutoScroll!
spr_hp = sbosshpbar;

// Fix the friend's left-facing sprite!
image_xscale = -1; 

// --- TOGGLEABLE OFFSETS ---
orbX = 32;   orbY = -10;
laserX = 40; laserY = 0;
hitboxX = 0; hitboxY = -30; // Hitbox offset relative to x/y

// --- DEBUG ---
showDebugHitbox = false;