draw_self(); // Draw the enemy sprite normally

if (debugShowHitbox) {
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    
    var _rectX1, _rectX2;
    var _boxWidth = 40;
    
    if (facingDir == 1) {
        _rectX1 = x;
        _rectX2 = x + _boxWidth;
    } else {
        _rectX1 = x - _boxWidth;
        _rectX2 = x;
    }
    
    var _rectY1 = y - 20; 
    var _rectY2 = _rectY1 + 10;
    
    draw_rectangle(_rectX1, _rectY1, _rectX2, _rectY2, false);
    
    draw_set_alpha(1);
    draw_set_color(c_white);
}