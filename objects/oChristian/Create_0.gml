//basic enemy stuff

xSpeed = 0;
ySpeed = 0;

grav = 0.275;
termVelocity = 6;
onGround = true;

maxHP = 1
hp = maxHP;
flashTimer = 0;
hpPrev = hp;

dead = false;

state = "IDLE";
moveSpeed = 1.25;
attackCooldown = 45; // 0.75 seconds at 60fps
attackTimer = 0;
hasShot = false;

// Default facing (Left = 1)
image_xscale = 1;
image_speed = 1.5;