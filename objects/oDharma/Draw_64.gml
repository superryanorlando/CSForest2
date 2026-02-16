if (!instance_exists(oPlayer)) exit;

if state!="WAIT_FOR_DOOR" {
	var seg_w = sprite_get_width(spr_hp); // Width of one segment
var scale = 2; 
var total_w = maxHP * seg_w * scale;

// Center Calculation
// Screen Width is 256. Center is 128.
var start_x = 50;
var draw_y = 600; // 35px from bottom

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
}