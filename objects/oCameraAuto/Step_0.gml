// Only scroll if the boss exists and isn't dead
if (instance_exists(oMrSen) && oMrSen.state != "DEATH") {
    camX += scrollSpeed;
}

camera_set_view_pos(view_camera[0], camX, camY);