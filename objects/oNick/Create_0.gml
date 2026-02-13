//basic enemy stuff

xSpeed = 0;
ySpeed = 0;

grav = 0.275;
termVelocity = 6;
onGround = true;
canShoot = true;
cooldown = false;

maxHP = 3;
hp = maxHP;

dead = false;

isAttacking = false;
sprite_index = sNickIdle;

// Damage and Visuals
flashTimer = 0;
hpPrev = hp;