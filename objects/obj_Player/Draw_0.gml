/// @description Affiche le joueur et les bulles de dialogue

// Dessiner le sprite d'origine du joueur
draw_self();

// ─── AFFICHAGE DES BULLES DE DIALOGUE AVEC LES FEMMES ────────────────────
if (dialogue_state > 0 && instance_exists(target_femme)) {
    
    // Étape 1 : Le joueur parle
    if (dialogue_state == 1) {
        scr_draw_bubble(x, y - 40, "Wesh la miss, bien ?");
    }
    
    // Étape 2 : La femme répond selon l'argent
    else if (dialogue_state == 2) {
        if (global.money <= 50000) {
            scr_draw_bubble(target_femme.x, target_femme.y - 40, "Casse toi sale clochard, tu me dèg !");
        } else {
            scr_draw_bubble(target_femme.x, target_femme.y - 40, "Saluuuuut mignon !!");
        }
    }
    
    // Étape 3 : La femme demande l'insta (si le joueur est riche)
    else if (dialogue_state == 3) {
        scr_draw_bubble(target_femme.x, target_femme.y - 40, "t'as pas un insta pour moi ?");
    }
}
