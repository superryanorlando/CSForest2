//makes enemy almost front layer
depth = -9000;

if (y>room_height && !dead) {
	dead = true;
}

//Attacking

if (instance_exists(oPlayer)) {
    
	if oPlayer.x<id.x {
		id.direction=180;
	} else {
		id.direction=0;
	}
    
    var _dist = distance_to_object(oPlayer);
	
	 
    if (_dist > 256) {
        exit; 
    }
	
    if (_dist < 100 && id.canShoot == true && !cooldown) {
        alarm[1] = 5
		cooldown = true;
        
    }
}

if (dead) {
	instance_destroy();
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
EnemyG(id);



