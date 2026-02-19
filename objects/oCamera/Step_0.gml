if !instance_exists(oPlayer) || oPlayer.dead {
	exit;
}

var camHeight = camera_get_view_height(view_camera[0]);
var camWidth = camera_get_view_width(view_camera[0]);

var camX = oPlayer.x - camWidth/2;
var camY = oPlayer.y - camHeight/2;

// --- ENTRY DOOR LOGIC (Left Boundary) ---
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

// --- EXIT DOOR LOGIC (Right Boundary) ---
if (instance_exists(oBossDoor2)) {
    var door2 = instance_nearest(oPlayer.x, oPlayer.y, oBossDoor2);
    
    // If the exit door is still closed, do not let the camera's 
    // right edge pass the door's position.
    if (door2.state == "closed") {
        camX = min(camX, door2.x - camWidth);
    }
}

// --- ROOM LIMITS ---
camX = clamp(camX, 0, room_width-camWidth);
camY = clamp(camY, 0, room_height-camHeight);

// --- SMOOTHING ---
actualCamX += (camX-actualCamX)*camFollowSpeed;
actualCamY += (camY-actualCamY)*camFollowSpeed;

// --- SHAKE LOGIC ---
var _xShake = 0;
var _yShake = 0;

if (shakeMag > 0) {
    _xShake = random_range(-shakeMag, shakeMag);
    _yShake = random_range(-shakeMag, shakeMag);
    shakeMag = lerp(shakeMag, 0, shakeFade); 
    if (shakeMag < 0.5) shakeMag = 0;
}

camera_set_view_pos(view_camera[0], actualCamX + _xShake, actualCamY + _yShake);