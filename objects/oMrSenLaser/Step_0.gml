timer++;
y = oMrSen.y-20;
if (timer >= maxLife) instance_destroy();
if (place_meeting(x, y, oPlayer)) {
    if (!oPlayer.invulnerable && !oPlayer.dead) {
        with (oPlayer) {
            HPScript(-20); 
        }
        
    }
}