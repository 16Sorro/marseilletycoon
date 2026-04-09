// Déplacement
x += spd * direction_x;

// Limite droite → repart à gauche
if (x >= start_x + patrol_range) {
    x            = start_x + patrol_range;
    direction_x  = -1;
    image_xscale = abs(image_xscale);     // Face gauche
}

// Limite gauche → repart à droite
if (x <= start_x - patrol_range) {
    x            = start_x - patrol_range;
    direction_x  = 1;
    image_xscale = -abs(image_xscale);    // Face droite
}
