spd = 3;
interact_range = 64;
near_business = noone;
can_buy = false;
base_scale = image_xscale; // Sauvegarde la taille d'origine
base_sprite = sprite_index;
is_emoting = false;
global.emote_wheel_open = false;
// ─── GESTION DE L'AFFICHAGE (Z-INDEX) ────────────────────────────────────
// Le joueur est devant tous les PNJ et décors
depth = -9000;

// On s'assure que les murs (Object36_Mur) restent au-dessus du joueur
with (Object36_Mur) {
    depth = -10000;
}

// ─── GESTION DU DIALOGUE AVEC LES FEMMES ──────────────────────────────────
dialogue_state = 0; // 0=aucun, 1="Wesh", 2="Saluuuuut" ou "Casse toi", 3="Insta"
dialogue_timer = 0;
target_femme = noone;

// ─── GESTION DU DIALOGUE AVEC LA POLICE ───────────────────────────────────
police_dialogue_state = 0;
police_dialogue_timer = 0;
target_police = noone;
police_cooldown = 0;

