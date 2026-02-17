hp = 1;
dead = false;
state = "WAIT_FOR_DOOR";

// --- MOVEMENT ---
xSpeed = 0;
ySpeed = 0;
grav = 0.375;
onGround = true;
termVelocity = 6;
dir = -1; // 1 = Right, -1 = Left
turnsThisDash = 0; // New variable to track fake-outs
moveSpeedMax = 5;
accel = 0.2;
arenaLeft = oBossDoor.x+8;      // Will be updated based on room/collision
arenaRight = 10000;
// Toggleable Edges
edgeLeft = 0;
edgeRight = 0;
boundsSet = false;

// --- TURN LOGIC ---
checkedTurn = false; // Ensures we only roll dice once per jump-over

// --- TIMERS ---
waitTimer = 0;