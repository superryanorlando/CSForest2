var player = instance_nearest(x, y, oPlayer);

switch (state) {
    case "closed":
        if (Touching(oPlayer)) {
            state = "opening";
        }
        break;

    case "opening":
        y -= open_speed;
        if (y <= open_y) {
            y = open_y;
            state = "open";
        }
        break;

    case "open":
        if (player.x > x + sprite_width + lock_distance) {
            state = "locking";
        }
        break;

    case "closing":
        y += open_speed;
        if (y >= closed_y) {
            y = closed_y;
            state = "locked";
        }
        break;
}