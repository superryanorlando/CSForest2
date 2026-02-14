function DamageScript(num){
    // 1. SAFETY CHECK: If already dead, stop immediately. 
    // This prevents the alarm from being reset over and over.
    if (oPlayer.dead) return; 

    // 2. Math: Add/Subtract health
    if (num + oPlayer.hp > oPlayer.maxHP) {
        oPlayer.hp = oPlayer.maxHP;
    } else {
        oPlayer.hp += num;
    }

    // 3. Death Logic
    if (oPlayer.hp <= 0) {
        oPlayer.hp = 0;
        oPlayer.dead = true;
        oPlayer.image_alpha = 0;
        oPlayer.alarm[2] = 120; // Now this will only run ONCE
    }
}