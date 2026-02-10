var _inst = instance_create_layer(x-8, y-(sprite_height/1.5), "Instances", oProjectile);
with (_inst) {
            spd = 3.5;
			direction = other.direction;
    
        }