// --- ALARM 3: HITBOX LOGIC ---

// Define the rectangle coordinates based on facing direction at the moment of impact
var _dir = image_xscale; 
var _x1, _x2;

if (_dir == -1) { // Facing Right
    _x1 = x + 6;
    _x2 = x + 18; 
} else { // Facing Left
    _x1 = x - 18; 
    _x2 = x - 6;
}

var _y1 = y - 32;
var _y2 = y;

// Hit detection
var _hits = ds_list_create();
var _count = collision_rectangle_list(_x1, _y1, _x2, _y2, oEnemy, false, true, _hits, false);

if (_count > 0) {
    for (var i = 0; i < _count; i++) {
        var _inst = _hits[| i];
        
        // Using the persistent enemy_hit_list from Create
        if (ds_list_find_index(enemy_hit_list, _inst) == -1) {
            if (variable_instance_exists(_inst, "hp")) {
                _inst.hp -= 1;
            }
            ds_list_add(enemy_hit_list, _inst);
        }
    }
}

// Clean up the temporary list
ds_list_destroy(_hits);