if !instance_exists(oPlayer) || oPlayer.dead {
	exit;
}

var camHeight = camera_get_view_height(view_camera[0]);
var camWidth = camera_get_view_width(view_camera[0]);

var camX = oPlayer.x - camWidth/2;
var camY = oPlayer.y - camHeight/2;


clamp(oPlayer.x, actualCamX-camWidth, actualCamX+camWidth)


if (instance_exists(oBossDoor)) {
    var door = instance_nearest(oPlayer.x, oPlayer.y, oBossDoor);

    var yRange = 200;
    var withinY = (oPlayer.y >= door.y - yRange) && (oPlayer.y <= door.y + yRange);

    if (withinY) {
        switch (door.state) {
            case "closed":
            case "opening":
                camX = min(camX, door.x - camWidth);
                break;

            case "locking":
            case "closing":
            case "locked":
                camX = max(camX, door.x - door.sprite_width);
				camY -= 40;
                break;
        }
    }
}




camX = clamp(camX, 0, room_width-camWidth);
camY = clamp(camY, 0, room_height-camHeight);

actualCamX += (camX-actualCamX)*camFollowSpeed;
actualCamY += (camY-actualCamY)*camFollowSpeed;

// --- NEW SHAKE LOGIC ---
var _xShake = 0;
var _yShake = 0;

if (shakeMag > 0) {
    _xShake = random_range(-shakeMag, shakeMag);
    _yShake = random_range(-shakeMag, shakeMag);
    shakeMag = lerp(shakeMag, 0, shakeFade); // Fade out
    if (shakeMag < 0.5) shakeMag = 0;
}

camera_set_view_pos(view_camera[0], actualCamX + _xShake, actualCamY + _yShake);


