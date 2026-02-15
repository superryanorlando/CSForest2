if (isAttacking) {
    image_speed = 1; 
} else {
    if (onGround) {
        if (abs(xSpeed) > 0) {
            sprite_index = sGoddardWalk;
            image_speed = 1;
        } else {
            sprite_index = sGoddardIdle;
            image_speed = 0;
            image_index = 0; 
        }
    } else {
        if (ySpeed < -3) {
            sprite_index = sGoddardJump0;
        } else if (ySpeed < 0) {
            sprite_index = sGoddardJump;
        } else {
            sprite_index = sGoddardFall;
        }
    }
}

if (invulnerable) {
    if ((current_time div 100) mod 2 == 0) {
        image_alpha = 0.4; 
    } else {
        image_alpha = 1.0; 
    }
} else {

    image_alpha = 1.0;
}


draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);