/// @description Génère les revenus passifs chaque seconde

// delta_time est en microsecondes → on convertit en secondes
global.income_timer += delta_time / 1000000;

if (global.income_timer >= 1) {
    global.income_timer = 0;
    global.money += global.income_per_sec;
    
    // Sécurité : empêche l'argent d'être négatif par income
    if (global.money < 0) { global.money = 0; }
}

// ─── CHEAT : touche M → +20 000 € ────────────────────────────────────────
if (keyboard_check_pressed(ord("M"))) {
    global.money += 20000;
}

// ─── INTELLIGENCE ARTIFICIELLE : PATROUILLE DE POLICE ────────────────────
var _policiers = [Object11_PnjPolice1, Object13_PnjPolice2, Object14_PnjPolice3, Object15_PnjPolice4];

for (var i = 0; i < array_length(_policiers); i++) {
    with (_policiers[i]) {
        // Initialisation à la volée si pas encore fait
        if (!variable_instance_exists(id, "police_spd")) {
            police_spd   = 1.5;
            police_dir   = random(360);
            police_timer = random(120);
            base_scale   = image_xscale;
            police_is_talking = false;
        }
        
        if (variable_instance_exists(id, "police_is_talking") && police_is_talking) {
            continue; // Le policier s'arrête de marcher
        }
        
        police_timer--;
        
        // Change de direction régulièrement
        if (police_timer <= 0) {
            police_dir   = random(360);
            police_timer = 60 + random(180); 
        }
        
        var _dx = lengthdir_x(police_spd, police_dir);
        var _dy = lengthdir_y(police_spd, police_dir);
        
        // Gérer les collisions avec les murs (Mur est "solid")
        if (place_free(x + _dx, y)) {
            x += _dx;
        } else {
            police_dir = random(360); // Repart dans une autre direction s'il tape un mur
        }
        
        if (place_free(x, y + _dy)) {
            y += _dy;
        } else {
            police_dir = random(360);
        }
        
        // Tourner le sprite selon la direction (gauche/droite)
        if (abs(_dx) > 0.2) {
            if (_dx > 0) image_xscale = -abs(base_scale); // Orienté droite
            else         image_xscale = abs(base_scale);  // Orienté gauche
        }
    }
}