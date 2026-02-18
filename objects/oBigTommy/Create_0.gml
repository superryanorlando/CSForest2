// --- NEW STATE & TIMER ---
state = "WAIT_FOR_DOOR"; 
bendTimer = 0;
spr_hp = sbosshpbar;

// --- ATTEMPT LIMITS ---
slideCount = 0;
maxSlides = 2;

// --- JUMP CALCULATION ---
// To hit a vertex of 150px with gravity 0.275:
// Formula: v = sqrt(2 * gravity * height)
jumpImpulse = -sqrt(2 * 0.275 * 150); // This results in ~-9.1

// --- PHYSICS & DOOR ---
// Ensure these match your actual wall object name
wallObject = oWall; 
arenaMargin = 120; // Distance from wall required to summon

// --- BASIC SETUP ---
xSpeed = 0;
ySpeed = 0;
grav = 0.275;
termVelocity = 12; // Increased for heavy falling speed
onGround = false;

maxHP = 200;
hp = maxHP;
hpPrev = hp;
flashTimer = 0;
dead = false;

// --- BOSS VARIABLES ---
attackTimer = 60; // Time between attacks
currentAttack = 0;
image_xscale = 1;

// Attack Helpers
slideTargetX = 0;
jumpTargetX = 0;
hasSpawned = false; // For the snap attack

// Spawn positions for Christians (Change these to match your room)
spawnPos1_X = x - 100; 
spawnPos2_X = x + 100;
spawnY = y - 200;