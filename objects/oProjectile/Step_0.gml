x += lengthdir_x(spd, direction);
y += lengthdir_y(spd, direction);

if Touching(oPlayer) && !oPlayer.invulnerable{
	HPScript(-2);
}

