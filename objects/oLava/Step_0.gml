damageTick--; 

if (Touching(oPlayer) && !oPlayer.invulnerable) {
    if (damageTick <= 0) {
        DamageScript(-1);
        damageTick = 6;
    }
}