//makes enemy almost front layer
depth = -9000;

if (y>room_height && !dead) {
	dead = true;
}

//Attacking

if (instance_exists(oPlayer)) {
    
    
    var _dist = distance_to_object(oPlayer);
    if (_dist < 80 && canShoot == true) {
        
        // --- FIRE PROJECTILE ---
        var _inst = instance_create_layer(x, y, "Instances", oProjectile);
        
        
        with (_inst) {
            speed = 10;
            
            // Assuming image_xscale determines facing (1 is Right, -1 is Left)
            if (other.image_xscale == 1) {
                direction = 0;   // Right
            } else {
                direction = 180; // Left
            }
            
    
        }
        
        // --- RESET COOLDOWN ---
        canShoot = false;
        alarm[0] = 45; // Set Alarm 0 to trigger later
    }
}


//X
var _subpix = 0.5;

if place_meeting(x + xSpeed, y, oWall) {
	//slopes (say thanks basil)
	if !place_meeting(x+xSpeed, y-abs(xSpeed)-1, oWall) {
		while place_meeting(x+xSpeed, y, oWall) {
			y-=_subpix;
		}
		
	} else {
		if !place_meeting(x+xSpeed, y+abs(xSpeed)+1, oWall) {
		while place_meeting(x+xSpeed, y, oWall) {
			y+=_subpix;
		}
		} else {
			//closes all distance between player and wall:
			var _thing = _subpix*sign(xSpeed);
			while !place_meeting(x+_thing,y,oWall) {
				x+=_thing;
			}
	
			xSpeed=0;
		}
	}
}

if (ySpeed>=0) && !place_meeting(x+xSpeed, y+1, oWall) && place_meeting(x+xSpeed, y + abs(xSpeed)+1, oWall) {
	while !place_meeting(x+xSpeed, y+_subpix, oWall) {
			y+=_subpix;
		}
}

x+=xSpeed;

//Y

//gravity
EnemyG(oNick);



