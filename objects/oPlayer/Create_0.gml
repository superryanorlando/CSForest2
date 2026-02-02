
inputSetup();
// moving
movDirection = 0;
movSpeed = 1.85;
xSpeed = 0;
ySpeed = 0;
canMove = true;
// jumping/air

grav = 0.275;
jumpSpeed = -3.3;
termVelocity = 6;
jumpHoldTime = 0;

onGround = true;

// hp
maxHP = 20
hp = maxHP;
hurt_timer = 0;
invulnerable = false;
dead = false;
	// 1 px between each bar. i love you rockman
spr_hp = shpbar;

