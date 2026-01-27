
// flash when hurt
if (invulnerable) {
    if ((current_time div 4) mod 2 == 0) {
        draw_self();
    }
} else {
    draw_self();
}