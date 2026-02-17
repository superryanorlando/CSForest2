flashTimer = 0;
// We destroy the boss immediately when this controller starts
if (instance_exists(oHibs)) {
    instance_destroy(oHibs);
}