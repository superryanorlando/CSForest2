// --- BASICS ---
hp = 50;
maxHP = 50;
hpPrev = hp;
flashTimer = 0;
dead = false;
spr_hp = sbosshpbar; // Ensure this sprite exists

// --- PHYSICS ---
xSpeed = 0;
ySpeed = 0;
grav = 0.275;
onGround = true;

// --- STATE MACHINE ---
state = "WAIT_FOR_DOOR"; 
// States: WAIT_FOR_DOOR, IDLE, SWING_DASH, SWING_RECOVERY, 
// PRE_JUMP, JUMP_TO_TOTEM, ON_TOTEM, TOTEM_ATTACK_P, TOTEM_ATTACK_V, JUMP_DOWN, COOLDOWN

swingCount = 0; // Tracks swings before forcing a totem jump
attackTimer = 0;
subState = 0;   // Used for multi-stage attacks (like the 3 vine bursts)

// --- TOTEM / ARENA INFO ---
totemX = oDharmaTotem.x; // Default, can be adjusted
totemY = y - 100;  
groundY = y;      // Remember where the floor is
arenaLeft = 0;    // Will set this in Step based on Boss Door
vineWidth = 32;   // Width of the vine sprite (adjust to match your sprite)
burstTimer = 0;
burstDelay = 15; // 0.75 seconds of rest between each vine burs

// --- ANIMATION/FACING ---
// -1 = Facing Left (Default), 1 = Facing Right
image_xscale = -1; 
canTurn = true;

// --- HITBOX SETTINGS ---
hitboxW = 40;  // How far in front of Dharma it reaches
hitboxH = 20;  // The vertical thickness of the hit area
hitboxYOffset = 10; // How high up from Dharma's feet the hit box starts