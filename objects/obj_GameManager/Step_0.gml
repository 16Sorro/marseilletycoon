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