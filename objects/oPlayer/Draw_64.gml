var seg_w = sprite_get_width(spr_hp);

// draw filled HP
for (var i = 0; i < hp; i++) {
    draw_sprite(spr_hp, 0, 16 + i * (seg_w), 16);
}