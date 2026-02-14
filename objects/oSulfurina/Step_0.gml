bubbleTimer--;
if (bubbleTimer <= 0) {
    var _spawnX = x + random(sprite_width);
    instance_create_layer(_spawnX, y, "Instances", oSulfurBubble);
    bubbleTimer = irandom_range(30, 60); 
}

damageTick--; 

if (Touching(oPlayer) && !oPlayer.invulnerable) {
    if (damageTick <= 0) {
        DamageScript(-1);
        damageTick = 6;
    }
}