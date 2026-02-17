var seg_w = sprite_get_width(spr_hp);
var scale = 2;
var start_x = 192
var draw_y = 632;

if state!="WAIT_FOR_DOOR" {
	// 1. Draw oHats' 1 HP (The very last segment on the left)
	var _hatsColor = (instance_exists(oHats) && !oHats.dead) ? c_red : c_black;
	draw_sprite_ext(spr_hp, -1, start_x, draw_y, scale, scale, 0, _hatsColor, 1);

	// 2. Draw oHibs' 99 HP (Segments 1 through 99)
	for (var i = 1; i < 100; i++) {
	    // We fill segments based on Hibs' current HP
	    // If Hibs has 99hp, all 99 segments are white.
	    var _hibsColor = (hp >= i) ? c_aqua : c_black;
	    draw_sprite_ext(spr_hp, -1, start_x + (i * seg_w * scale), draw_y, scale, scale, 0, _hibsColor, 1);
	}
}
