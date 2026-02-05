//makes enemy almost front layer
depth = -9000;

if (y>room_height && !dead) {
	dead = true;
}

//Attacking

if (instance_exists(oPlayer)) {
    
	var _dir = sign(oPlayer.x - x); 
    if (_dir != 0) {
        direction = (_dir == 1) ? 0 : 180;
    }
	
	var _moveSpeed = 0; // Adjust this for how fast you want him to walk
    xSpeed = _dir * _moveSpeed;
    
    var _dist = distance_to_object(oPlayer);
	
	 
    
	if (id.canAttack = true) {
		if (_dist < 100) {
        alarm[1] = 20;
		show_debug_message("heyl i work")
		
        //var _inst = instance_create_layer(x-8, y-(sprite_height/1.5), "Instances", oProjectile);
       
        canAttack = false;
        alarm[0] = 45; 
    }
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
//EnemyG(oDharma);



