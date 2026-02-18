if (instance_exists(oPlayer)) {
    // Check 1: Is the player to the RIGHT of the cage?
    var _isRight = (oPlayer.x-100 > x);
    
    // Check 2: Is the player close enough horizontally?
    var _withinX = (oPlayer.x < x + triggerDistX);
    
    // Check 3: Is the player roughly on the same vertical level?
    var _withinY = abs(oPlayer.y - y) < triggerDistY;

    if (_isRight && _withinX && _withinY) {
        //
        // 3. Destroy the cage block
        instance_destroy();
    }
}