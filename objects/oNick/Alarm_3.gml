var _inst = instance_create_layer(x, y-(sprite_height/1.5), "Instances", oBoboProjectile);
// Logic: If image_xscale is -1 (Right), speed is positive. 
// If image_xscale is 1 (Left), speed is negative.
if (image_xscale == -1) {
	_inst.xspd = 2.8
    _inst.image_xscale = -1; // Make the bullet face right too
} else {
	_inst.xspd = -2.8
    _inst.image_xscale = 1;  // Make the bullet face left
}