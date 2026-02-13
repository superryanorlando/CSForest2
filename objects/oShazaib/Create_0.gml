//basic enemy stuff

xSpeed = 0;
ySpeed = 0;

grav = 0.275;
termVelocity = 6;
onGround = true;

maxHP = 5
hp = maxHP;

dead = false;

isAttacking = false;

// States: "IDLE", "ALERT", "RUN", "COOLDOWN"
state = "IDLE"; 

runSpeed = 3.2;      // How fast he runs
fric = 0.08;        // Friction for skidding to a stop
alertTime = 55;    // 0.75 seconds (at 60fps)
runTime = 180;     // 3 seconds
coolTime = 120;    // 2 seconds

// --- VISUALS ---
sprite_index = sShazaibIdle;
flashTimer = 0;
hpPrev = hp;