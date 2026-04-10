/// @description Scooter - Mouvement

if (!place_free(x + (spd * direction_x), y)) {
    direction_x *= -1; // Demi-tour si mur
    // Si on va à droite (direction_x > 0), il faut inverser le sprite (si dessiné face gauche de base)
    // On conserve le signe inverse de image_xscale utilisé pour les autres PNJ, ajustez si le sprite est de base à droite.
    image_xscale = direction_x > 0 ? -abs(base_scale) : abs(base_scale);
} else {
    x += spd * direction_x;
}

// Limite droite → Demi-tour gauche
if (x >= start_x + patrol_range) {
    x = start_x + patrol_range;
    direction_x = -1;
    image_xscale = abs(base_scale);
}

// Limite gauche → Demi-tour droite
if (x <= start_x - patrol_range) {
    x = start_x - patrol_range;
    direction_x = 1;
    image_xscale = -abs(base_scale);
}
