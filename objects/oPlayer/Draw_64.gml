
var seg_w = sprite_get_width(spr_hp);
var scale = 2; 


for (var i = 0; i < hp; i++) {
    draw_sprite_ext(
        spr_hp, 
        -1, 
        16 + i * (seg_w), 
        16, 
        1,       
        scale,   
        0,       
        c_white, 
        1        
    );
}

