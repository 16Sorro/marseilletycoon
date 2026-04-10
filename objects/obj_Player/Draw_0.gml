/// @description Affiche le joueur et les bulles de dialogue

// Dessiner le sprite d'origine du joueur ou son emote
if (is_emoting) {
    var _spr = asset_get_index("cigaretteanim");
    if (_spr != -1) {
        var _bw = sprite_get_width(base_sprite);
        var _bh = sprite_get_height(base_sprite);
        var _sw = sprite_get_width(_spr);
        var _sh = sprite_get_height(_spr);
        
        // Calcul du scale exact pour forcer `cigaretteanim` à la taille précise de `base_sprite`
        var _adj_x = (_bw / _sw) * abs(base_scale);
        var _adj_y = (_bh / _sh) * abs(base_scale);
        
        // Garde la direction gauche/droite
        if (image_xscale < 0) { _adj_x = -_adj_x; }
        
        // Calcul du coin Haut-Gauche précis du joueur
        var _left = x - sprite_get_xoffset(base_sprite) * image_xscale;
        var _top = y - sprite_get_yoffset(base_sprite) * image_yscale;
        
        // Calcul du point de dessin (compense l'origin bizarre potentielle du nouveau sprite)
        var _draw_x = _left + sprite_get_xoffset(_spr) * _adj_x;
        var _draw_y = _top + sprite_get_yoffset(_spr) * _adj_y;
        
        // Faire avancer l'animation de l'emote
        draw_sprite_ext(_spr, image_index, _draw_x, _draw_y, _adj_x, _adj_y, 0, c_white, 1);
    } else {
        draw_self();
    }
} else {
    draw_self();
}

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

// ─── AFFICHAGE DES BULLES DE DIALOGUE AVEC LA POLICE ─────────────────────
if (police_dialogue_state > 0 && instance_exists(target_police)) {
    
    // Étape 1 : Le flic interpelle
    if (police_dialogue_state == 1) {
        scr_draw_bubble(target_police.x, target_police.y - 50, "contrôle de police monsieur,\ndéclinez votre identité !");
    }
    
    // Étape 2 : Le joueur répond
    else if (police_dialogue_state == 2) {
        scr_draw_bubble(x, y - 50, "hechek arrête de me casse les c*******,\nmais vzy c'est Moha");
    }
    
    // Étape 3 : Le flic conclut
    else if (police_dialogue_state == 3) {
        scr_draw_bubble(target_police.x, target_police.y - 50, "bien, bonne journée monsieur,\npas de bétises");
    }
}
