var seg_w = sprite_get_width(spr_hp);


for (var i = 0; i < hp; i++) {
    draw_sprite(spr_hp, 0, 16 + i * (seg_w), 16);
}

if (hurt_timer > 0) {
    hurt_timer--;
    if (hurt_timer mod 2 == 0) exit; // flicker
}