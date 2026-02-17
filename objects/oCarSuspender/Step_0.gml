if (instance_exists(target)) {
    x = target.x;
    // Keep it fixed at the top of the screen or relative to Hibs?
    // "Directly above" implies a fixed Y anchor or relative. 
    // Let's make it hang from the ceiling (room_top) or relative to Hibs.
    // Based on "Suspender", it usually hangs from the ceiling down to the car.
    y = target.y - heightOffset; 
} else {
    instance_destroy();
}