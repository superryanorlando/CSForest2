
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
jumpSpeed = -4.3;
termVelocity = 6;
jumpHoldTime = 0;
vX = 0;
vY = 0;
vDecel = 0.05;
onGround = true;

// hp
maxHP = 100
hp = maxHP;
hurt_timer = 0;
invulnerable = false;
dead = false;
onVine = false;
vineSpeed = 2.0; 


	// 1 px between each bar. i love you rockman
spr_hp = shpbar;

// --- MELEE ATTACK VARIABLES ---
isAttacking = false;
comboIndex = 1;         // Which attack (1-4)
attackDuration = 18;    // How long the attack lasts (locked in place)
attackTimer = 0;        // Counter for the current attack
comboResetTimer = 0;    // Counter to reset combo to 1 if you wait too long
enemy_hit_list = ds_list_create(); // Prevents multi-hits in one swing


