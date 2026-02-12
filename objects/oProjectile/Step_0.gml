x += xspd
y += yspd

if Touching(oPlayer) && !oPlayer.invulnerable{
	HPScript(-2);
}

