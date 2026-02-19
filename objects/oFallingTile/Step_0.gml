if (!falling && instance_exists(oMrSen)) {
    // If MrSen's center is within 40 pixels of this block's center
    if (abs(x - oMrSen.x) < 50) {
        falling = true;
    }
}

if (falling) {
    ySpeed += grav;
    y += ySpeed;
    
    if (y > room_height + 32) {
        instance_destroy();
    }
}