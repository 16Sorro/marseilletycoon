/// @description Déplacement + interaction avec les businesses

// Bloque le joueur si la bourse ou blackjack est ouvert
if (variable_global_exists("bourse_active") && global.bourse_active) exit;
if (variable_global_exists("blackjack_active") && global.blackjack_active) exit;

// ─── MOUVEMENT (ZQSD + flèches) ───────────────────────────────────────────
var _dx = 0;
var _dy = 0;

if (keyboard_check(ord("Z")) || keyboard_check(vk_up))    { _dy = -spd; }
if (keyboard_check(ord("S")) || keyboard_check(vk_down))  { _dy =  spd; }
if (keyboard_check(ord("Q")) || keyboard_check(vk_left))  { _dx = -spd; }
if (keyboard_check(ord("D")) || keyboard_check(vk_right)) { _dx =  spd; }

// Frame Controller for custom 3 FPS
if (is_emoting) {
    emote_frame += 3 / game_get_speed(gamespeed_fps);
} else {
    emote_frame = 0;
}

// Annuler l'emote si on bouge
if ((_dx != 0 || _dy != 0) && is_emoting) {
    is_emoting = false;
    emote_frame = 0;
}

if (place_free(x + _dx, y)) { x += _dx; }
if (place_free(x, y + _dy)) { y += _dy; }

// ─── GESTION DE LA ROUE D'EMOTES (TOUCHE B) ──────────────────────────────
if (keyboard_check_pressed(ord("B"))) {
    global.emote_wheel_open = !global.emote_wheel_open;
}

// ─── ORIENTATION DU SPRITE (sens inversé, taille préservée) ──────────────
if (_dx > 0) { image_xscale = -base_scale; } // Droite → retourné
if (_dx < 0) { image_xscale =  base_scale; } // Gauche → normal


// ─── DÉTECTION DU BUSINESS LE PLUS PROCHE ────────────────────────────────
near_business = noone;
can_buy       = false;

var _biz = instance_nearest(x, y, obj_Business);
if (_biz != noone) {
    if (point_distance(x, y, _biz.x, _biz.y) < interact_range) {
        near_business = _biz;
        can_buy       = true;
    }
}

// ─── ACHAT D'UN BUSINESS (touche E) ──────────────────────────────────────
if (keyboard_check_pressed(ord("E")) && can_buy && near_business != noone) {
    var _idx = near_business.biz_index;

    if (!global.biz_owned[_idx]) {
        if (global.money >= global.biz_price[_idx]) {
            // Achat validé
            global.money          -= global.biz_price[_idx];
            global.biz_owned[_idx] = true;
            global.income_per_sec += global.biz_income[_idx];

            var _n = instance_create_layer(x, y - 32, "Instances", obj_Notification);
            _n.msg        = global.biz_name[_idx] + " acheté !";
            _n.color_text = c_lime;

        } else {
            // Pas assez de thune
            var _n = instance_create_layer(x, y - 32, "Instances", obj_Notification);
            _n.msg        = "Pas assez de thune frère !";
            _n.color_text = c_red;
        }
    }
}

// ─── DIALOGUE AVEC LES FEMMES ──────────────────────────────────────────────
if (dialogue_state > 0) {
    dialogue_timer += delta_time / 1000000;
    
    if (dialogue_state == 1 && dialogue_timer >= 2.0) {
        dialogue_state = 2;
        dialogue_timer = 0;
    } else if (dialogue_state == 2 && dialogue_timer >= 2.0 && global.money >= 50001) {
        dialogue_state = 3;
        dialogue_timer = 0;
    } else if ((dialogue_state == 2 && global.money <= 50000 && dialogue_timer >= 3.0) || 
               (dialogue_state == 3 && dialogue_timer >= 3.0)) {
        dialogue_state = 0;
        target_femme = noone;
    }
}

if (keyboard_check_pressed(ord("E")) && dialogue_state == 0 && !can_buy) { // Si pas de business proche
    var _f1 = instance_nearest(x, y, Object16_PnjFemme1);
    var _f2 = instance_nearest(x, y, Object17_PnjFemme2);
    var _target = noone;
    var _dist = 9999;
    
    if (_f1 != noone) {
        var d1 = point_distance(x, y, _f1.x, _f1.y);
        // Range un peu plus grand pour parler aux passants
        if (d1 < 120) { _target = _f1; _dist = d1; }
    }
    if (_f2 != noone) {
        var d2 = point_distance(x, y, _f2.x, _f2.y);
        if (d2 < 120 && d2 < _dist) { _target = _f2; }
    }
    
    if (_target != noone) { 
        dialogue_state = 1;
        dialogue_timer = 0;
        target_femme = _target;
        
        // Empêche la femme de s'enfuir trop loin pendant le dialogue
        if (variable_instance_exists(_target, "direction_x")) {
            _target.direction_x = sign(x - _target.x); // Elle se tourne vers le joueur
        }
    }
}

// ─── DIALOGUE ET COOLDOWN POLICE ──────────────────────────────────────────
if (police_cooldown > 0) {
    police_cooldown -= delta_time / 1000000;
}

if (police_dialogue_state > 0) {
    police_dialogue_timer += delta_time / 1000000;
    
    // Etat 1 : Le flic demande l'identité (dure 3 secondes)
    if (police_dialogue_state == 1 && police_dialogue_timer >= 3.0) {
        police_dialogue_state = 2;
        police_dialogue_timer = 0;
    }
    // Etat 2 : Moha répond (dure 3s)
    else if (police_dialogue_state == 2 && police_dialogue_timer >= 3.0) {
        police_dialogue_state = 3;
        police_dialogue_timer = 0;
    }
    // Etat 3 : Flic dit ok bonne journée (dure 2.5s)
    else if (police_dialogue_state == 3 && police_dialogue_timer >= 2.5) {
        police_dialogue_state = 0;
        if (instance_exists(target_police)) {
            // Le flic repart
            if (variable_instance_exists(target_police, "police_is_talking")) {
                target_police.police_is_talking = false; 
            }
        }
        target_police = noone;
        police_cooldown = 60.0; // 1 minute de cooldown
    }
} else if (police_cooldown <= 0) {
    // Si aucun dialogue avec la police n'est en cours et que le cooldown est fini, on cherche un policier proche
    var _detect_range = 100;
    var _t = noone;
    var _dist = 9999;
    
    // On vérifie tous les objets de police
    var _policiers = [Object11_PnjPolice1, Object13_PnjPolice2, Object14_PnjPolice3, Object15_PnjPolice4];
    for (var i = 0; i < array_length(_policiers); i++) {
        var _p = instance_nearest(x, y, _policiers[i]);
        if (_p != noone) {
            var d = point_distance(x, y, _p.x, _p.y);
            if (d < _detect_range && d < _dist) {
                _t = _p;
                _dist = d;
            }
        }
    }
    
    if (_t != noone) {
        police_dialogue_state = 1;
        police_dialogue_timer = 0;
        target_police = _t;
        
        if (variable_instance_exists(_t, "police_is_talking")) {
            _t.police_is_talking = true;
        }
        
        // Tourne le flic vers le joueur
        if (variable_instance_exists(_t, "base_scale")) {
            if (x > _t.x) _t.image_xscale = -abs(_t.base_scale); // Regarde à droite
            else _t.image_xscale = abs(_t.base_scale); // Regarde à gauche
        }
    }
}
