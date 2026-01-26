if !instance_exists(oPlayer) {
	exit;
}

var camHeight = camera_get_view_height(view_camera[0]);
var camWidth = camera_get_view_width(view_camera[0]);

var camX = oPlayer.x - camWidth/2;
var camY = oPlayer.y - camHeight/2;

camX = clamp(camX, 0, room_width-camWidth);
camY = clamp(camY, 0, room_height-camHeight);

actualCamX += (camX-actualCamX)*camFollowSpeed;
actualCamY += (camY-actualCamY)*camFollowSpeed;

camera_set_view_pos(view_camera[0], actualCamX, actualCamY);