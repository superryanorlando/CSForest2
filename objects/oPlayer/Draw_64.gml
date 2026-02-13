var seg_w = sprite_get_width(spr_hp);
var scale = 2; 

for (var i = 0; i < hp; i++) {
    draw_sprite_ext(
        spr_hp, 
        -1, 
        16 + i * (seg_w), // Adjust spacing by the scaled width
        16, 
        1,   // xscale
        scale,   // yscale
        0,       // rotation
        c_white, // color blend
        1        // alpha
    );
}

if (hurt_timer > 0) {
    hurt_timer--;
    if (hurt_timer mod 2 == 0) exit; // flicker
}