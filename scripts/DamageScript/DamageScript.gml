function DamageScript(num){
    if (oPlayer.dead) return; 

    oPlayer.hp = clamp(oPlayer.hp + num, 0, oPlayer.maxHP);

    // Death Logic
    if (oPlayer.hp <= 0) {
        oPlayer.hp = 0;
        oPlayer.dead = true;
        oPlayer.image_alpha = 0;
        oPlayer.alarm[2] = 120; 
    }
}