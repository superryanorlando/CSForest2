if !instance_exists(oPlayer) || oPlayer.dead {
	exit;
}

var camHeight = camera_get_view_height(view_camera[0]);
var camWidth = camera_get_view_width(view_camera[0]);

var camX = oPlayer.x - camWidth/2;
var camY = oPlayer.y - camHeight/2;


clamp(oPlayer.x, actualCamX-camWidth, actualCamX+camWidth)

//thing
if (instance_exists(oBossDoor)) {
    var door = instance_nearest(oPlayer.x, oPlayer.y, oBossDoor);

    switch (door.state) {
        case "closed":
        case "opening":
            camX = min(camX, door.x - camWidth);
            break;
        case "locking":
        case "closing":
        case "locked":
            camX = max(camX, door.x - door.sprite_width);
            break;
    }
}

//


camX = clamp(camX, 0, room_width-camWidth);
camY = clamp(camY, 0, room_height-camHeight);

actualCamX += (camX-actualCamX)*camFollowSpeed;
actualCamY += (camY-actualCamY)*camFollowSpeed;

camera_set_view_pos(view_camera[0], actualCamX, actualCamY);

