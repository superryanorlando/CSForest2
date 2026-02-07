//anim
draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

if (abs(xSpeed)>0) {
	sprite_index = sGoddardWalk;
	image_speed = 1;
}
if (xSpeed==0) {
	sprite_index = sGoddardIdle;
	image_speed = 0;
}
if (!onGround) {
	if (ySpeed<-3) {
		sprite_index = sGoddardJump0;
	} else if (ySpeed<0) {
		sprite_index = sGoddardJump;
	} else {
		sprite_index = sGoddardFall;
	}
}


// flash when hurt
if (invulnerable) {
    if ((current_time div 4) mod 2 == 0) {
        draw_self();
    }
}
