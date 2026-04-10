/// scr_draw_text_outline(x, y, text, color_main)
/// Dessine un texte avec contour noir visible

function scr_draw_text_outline(_x, _y, _txt, _col) {
    var _scale = 1.6; // Taille augmentée
    
    // Contour très gras et prononcé (8 directions, 2px) pour lisibilité max sans fond
    draw_set_color(c_black);
    draw_text_transformed(_x - 2, _y - 2, _txt, _scale, _scale, 0);
    draw_text_transformed(_x + 2, _y - 2, _txt, _scale, _scale, 0);
    draw_text_transformed(_x - 2, _y + 2, _txt, _scale, _scale, 0);
    draw_text_transformed(_x + 2, _y + 2, _txt, _scale, _scale, 0);
    
    draw_text_transformed(_x - 2, _y, _txt, _scale, _scale, 0);
    draw_text_transformed(_x + 2, _y, _txt, _scale, _scale, 0);
    draw_text_transformed(_x, _y - 2, _txt, _scale, _scale, 0);
    draw_text_transformed(_x, _y + 2, _txt, _scale, _scale, 0);
    
    // Texte principal (affiché deux fois avec 1px de décalage pour le rendre plus "gras" au centre)
    draw_set_color(_col);
    draw_text_transformed(_x, _y, _txt, _scale, _scale, 0);
    draw_text_transformed(_x + 1, _y, _txt, _scale, _scale, 0);
    
    // Reset couleur
    draw_set_color(c_white);
}

// ─── LOGIQUE DU MENU OPTIONS GLOBAL ────────────────────────────────────────

function scr_options_step() {
    if (!variable_global_exists("opt_vol")) {
        global.opt_vol = 1.0;
        global.opt_fs = window_get_fullscreen();
        global.opt_sel = 0;
    }
    
    // Haut / Bas
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("W"))) {
        global.opt_sel--;
        if (global.opt_sel < 0) global.opt_sel = 3; // 4 rows: Vol, FS, Keys, Back
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        global.opt_sel++;
        if (global.opt_sel > 3) global.opt_sel = 0;
    }
    
    // Gauche / Droite (pour modifier les valeurs)
    if (global.opt_sel == 0) { // Volume
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("A"))) {
            global.opt_vol = max(0, global.opt_vol - 0.1);
            audio_master_gain(global.opt_vol);
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
            global.opt_vol = min(1, global.opt_vol + 0.1);
            audio_master_gain(global.opt_vol);
        }
    }
    
    // Validation
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        if (global.opt_sel == 1) { // Fullscreen
            global.opt_fs = !global.opt_fs;
            window_set_fullscreen(global.opt_fs);
        }
        if (global.opt_sel == 3) { // Retour
            return true; // Demande de quitter le menu
        }
    }
    return false;
}

function scr_options_draw() {
    if (!variable_global_exists("opt_vol")) {
        global.opt_vol = 1.0;
        global.opt_fs = window_get_fullscreen();
        global.opt_sel = 0;
    }

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    
    draw_set_alpha(0.9);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    scr_draw_text_outline(_gw/2, _gh/2 - 200, "OPTIONS", make_color_rgb(255, 200, 0));
    
    // 0: Volume
    var _c0 = (global.opt_sel == 0) ? make_color_rgb(100,255,140) : c_white;
    var _t0 = "Volume Sonore : < " + string(round(global.opt_vol * 100)) + "% >";
    scr_draw_text_outline(_gw/2, _gh/2 - 100, _t0, _c0);
    
    // 1: Plein Ecran
    var _c1 = (global.opt_sel == 1) ? make_color_rgb(100,255,140) : c_white;
    var _t1 = "Plein Ecran : " + (global.opt_fs ? "[OUI]" : "[NON]");
    scr_draw_text_outline(_gw/2, _gh/2 - 40, _t1, _c1);
    
    // 2: Touches (Just infos)
    var _c2 = (global.opt_sel == 2) ? make_color_rgb(100,255,140) : make_color_rgb(200, 200, 200);
    var _t2 = "DEPLACEMENT : Fleches ou ZQSD\nINTERACTION/ACHAT : E\nPAUSE/RETOUR : ECHAP\nROUE D'EMOTES : B\nARGENT(CHEAT) : M";
    scr_draw_text_outline(_gw/2, _gh/2 + 80, _t2, _c2);
    
    // 3: Retour
    var _c3 = (global.opt_sel == 3) ? make_color_rgb(100,255,140) : c_white;
    scr_draw_text_outline(_gw/2, _gh/2 + 200, "> Retour <", _c3);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
