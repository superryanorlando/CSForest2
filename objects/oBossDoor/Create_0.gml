depth=-15000;

state = "closed"; // closed, opening, open, locking, closing
open_speed = 2;

closed_y = y;
open_y = y - sprite_height; // slides upward

lock_distance = 24; 

player_passed = false;

with (oCamera) {
    bossDoor = id;
    bossLock = true;
}