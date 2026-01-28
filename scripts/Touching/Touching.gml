function Touching(obj){
    return (
        bbox_right >= obj.bbox_left &&
        bbox_left  <= obj.bbox_right &&
        bbox_bottom >= obj.bbox_top &&
        bbox_top <= obj.bbox_bottom
    );

}