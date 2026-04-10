/// @description Génère les revenus passifs chaque seconde

// ─── GESTION DE LA PAUSE ───────────────────────────────────────────────────
if (keyboard_check_pressed(vk_escape)) {
    if (global.is_paused) {
        if (global.pause_state == 2) {
            global.pause_state = 1;
            global.pause_selection = global.selected_slot;
        } else if (global.pause_state == 1 || global.pause_state == 3) {
            global.pause_state = 0; // Retour à la pause principale
            global.pause_selection = (global.pause_state == 1) ? 2 : 1; 
        } else {
            global.is_paused = false;
            instance_activate_all();
        }
    } else {
        global.is_paused = true;
        global.pause_state = 0;
        global.pause_selection = 0;
        instance_deactivate_all(true);
        instance_activate_object(obj_HUD); // HUD doit continuer de s'afficher
    }
}

if (global.is_paused) {
    if (global.pause_state == 3) {
        if (scr_options_step()) {
            global.pause_state = 0;
            global.pause_selection = 1;
        }
        exit;
    }

    var _max_sel = (global.pause_state == 2) ? 2 : 3;

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("W"))) {
        global.pause_selection--;
        if (global.pause_selection < 0) global.pause_selection = _max_sel;
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        global.pause_selection++;
        if (global.pause_selection > _max_sel) global.pause_selection = 0;
    }
    
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        if (global.pause_state == 0) { // MENU PRINCIPAL
            switch(global.pause_selection) {
                case 0: // Reprendre
                    global.is_paused = false;
                    instance_activate_all();
                    break;
                case 1: // Options
                    global.pause_state = 3;
                    break;
                case 2: // Sauvegarder
                    global.pause_state = 1;
                    global.pause_selection = 0;
                    break;
                case 3: // Quitter
                    game_end();
                    break;
            }
        } 

        else if (global.pause_state == 1) { // MENU LISTE SLOTS
            if (global.pause_selection < 3) { // Slots 1, 2, ou 3
                global.selected_slot = global.pause_selection;
                global.pause_state = 2; // Ouvre le menu d'action
                global.pause_selection = 0;
            } else if (global.pause_selection == 3) { // Retour
                global.pause_state = 0;
                global.pause_selection = 2;
            }
        }
        else if (global.pause_state == 2) { // MENU ACTION (SAUVER/CHARGER)
            if (global.pause_selection == 0) {
                // ECRASER SAUVEGARDE
                var _fname = "save" + string(global.selected_slot + 1) + ".json";
                var _data = {
                    money: global.money,
                    income_per_sec: global.income_per_sec,
                    biz_owned: global.biz_owned
                };
                var _str = json_stringify(_data);
                var _f = file_text_open_write(_fname);
                file_text_write_string(_f, _str);
                file_text_close(_f);
                
                global.save_info[global.selected_slot] = string(floor(global.money)) + " EUR";
                
                global.pause_state = 1;
                global.pause_selection = global.selected_slot;
                
            } else if (global.pause_selection == 1) {
                // CHARGER SAUVEGARDE
                var _fname = "save" + string(global.selected_slot + 1) + ".json";
                if (file_exists(_fname)) {
                    var _f = file_text_open_read(_fname);
                    var _str = "";
                    while (!file_text_eof(_f)) { _str += file_text_read_string(_f); file_text_readln(_f); }
                    file_text_close(_f);
                    
                    try {
                        var _data = json_parse(_str);
                        global.money = _data.money;
                        global.income_per_sec = _data.income_per_sec;
                        global.biz_owned = _data.biz_owned;
                        
                        global.is_paused = false;
                        instance_activate_all();
                    } catch(e) {}
                }
            } else if (global.pause_selection == 2) {
                // RETOUR
                global.pause_state = 1;
                global.pause_selection = global.selected_slot;
            }
        }
    }
    exit; // Stop le reste du Game Manager (argent, police, etc.)
}

// ─── GESTION DE L'ARGENT ───────────────────────────────────────────────────
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