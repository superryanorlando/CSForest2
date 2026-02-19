// 1. Check if the boss is dead based on the room
if (!boss_cleared) {
    switch (room) {
        case ForestZone: // Replace with your actual room names
            if (!instance_exists(oDharma)) boss_cleared = true;
            break;
            
        case CityZone:
            if (!instance_exists(oBigTommy)) boss_cleared = true;
            break;
            
        case CaveZone:
            if (!instance_exists(oHats)) boss_cleared = true;
            break;
            
        default:
            // If it's a room without a boss, just let them through
            boss_cleared = true; 
            break;
    }
}

// 2. Door Logic
switch (state) {
    case "closed":
        if (boss_cleared) {
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
        // Door stays open once the boss is dead
        break;
}