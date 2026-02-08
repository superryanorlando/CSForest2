
inputSetup();
// moving
movDirection = 0;
movSpeed = 2;
xSpeed = 0;
ySpeed = 0;
canMove = true;
sprite_index = sGoddardIdle;
image_speed = 0;
// jumping/air

grav = 0.275;
jumpSpeed = -4;
termVelocity = 6;
jumpHoldTime = 0;
vX = 0;
vY = 0;
vDecel = 0.05;
onGround = true;

// hp
maxHP = 20
hp = maxHP;
hurt_timer = 0;
invulnerable = false;
dead = false;
	// 1 px between each bar. i love you rockman
spr_hp = shpbar;

