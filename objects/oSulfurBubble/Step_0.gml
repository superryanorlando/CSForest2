if (!isPopped) {
    waveTimer += waveSpeed;
    x = waveAnchorX + sin(waveTimer) * waveAmount;

    if (place_meeting(x, y, oWetCeiling)) {
        instance_destroy();
    }

    if (y < -50) instance_destroy();

    if (place_meeting(x, y, oPlayer)) {
        isPopped = true;   
        hitsLeft = 10;     
        image_alpha = 0;   
        vspeed = 0;        
    }
} 
else {
    hitTimer--;
    if (hitTimer <= 0 && hitsLeft > 0) {
        if (instance_exists(oPlayer)) {
            oPlayer.damageCooldown = 0; 
            DamageScript(-0.5); 
        }
        
        hitsLeft--;
        hitTimer = 6; 
    }

    if (hitsLeft <= 0) instance_destroy();
}