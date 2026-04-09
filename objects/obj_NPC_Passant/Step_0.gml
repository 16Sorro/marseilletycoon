// Déplacement avec vérification des collisions (écarte l'objet solide)
if (!place_free(x + (spd * direction_x), y)) {
    direction_x *= -1; // Change de direction si on touche un mur
    image_xscale = direction_x > 0 ? -abs(image_xscale) : abs(image_xscale);
} else {
    x += spd * direction_x;
}

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
