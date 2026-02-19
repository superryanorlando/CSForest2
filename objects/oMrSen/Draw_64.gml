// Center Calculation
// Screen Width is 256. Center is 128.
var start_x = 192;
var draw_y = 632; // 35px from bottom
var seg_w = sprite_get_width(spr_hp);
var scale = 2; 
var total_w = maxHP * seg_w * scale;

// 1. Draw Background (Black/Empty)
for (var i = 0; i < maxHP; i++) {
    draw_sprite_ext(
        spr_hp, 
        -1, 
        start_x + i * (seg_w * scale), 
        draw_y, 
        scale,       
        scale,   
        0,       
        c_black, 
        1        
    );
}

// 2. Draw Current HP (White/Filled)
for (var i = 0; i < hp; i++) {
    draw_sprite_ext(
        spr_hp, 
        -1, 
        start_x + i * (seg_w * scale), 
        draw_y, 
        scale,       
        scale,   
        0,       
        c_white, 
        1        
    );
}
