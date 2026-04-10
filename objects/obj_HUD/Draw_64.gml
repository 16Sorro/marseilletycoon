/// @description HUD — Argent + Revenu par seconde (texte avec contour noir)

// ─── PANNEAU FOND ─────────────────────────────────────────────────────────
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_roundrect_ext(10, 10, 270, 95, 8, 8, false);
draw_set_alpha(1);
draw_set_halign(fa_left);

// ─── TITRE ───────────────────────────────────────────────────────────────
scr_draw_text_outline(20, 16, "COMPTE EN BANQUE", make_color_rgb(255, 200, 0));

// ─── ARGENT ACTUEL ───────────────────────────────────────────────────────
scr_draw_text_outline(20, 36, string(floor(global.money)) + " EUR", c_white);

// ─── SÉPARATEUR ──────────────────────────────────────────────────────────
draw_set_color(make_color_rgb(100, 100, 100));
draw_line(20, 58, 260, 58);

// ─── REVENU PAR SECONDE ──────────────────────────────────────────────────
scr_draw_text_outline(20, 64, "+" + string(global.income_per_sec) + " EUR/seconde", make_color_rgb(100, 255, 140));

// ─── BUSINESSES ACTIFS ───────────────────────────────────────────────────
var _count = 0;
for (var _i = 0; _i < 6; _i++) {
    if (global.biz_owned[_i]) { _count++; }
}
scr_draw_text_outline(20, 80, "Business : " + string(_count) + "/6", make_color_rgb(180, 180, 255));

// Reset
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);

// ─── MENU PAUSE (ECHAP) ──────────────────────────────────────────────────
if (global.is_paused) {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    
    // Fond obscurci plein écran
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1);
    
    // Centrage du texte
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    if (global.pause_state == 0) {
        // Grand Titre PAUSE
        scr_draw_text_outline(_gw / 2, _gh / 2 - 120, "PAUSE", make_color_rgb(255, 200, 0));
        
        // Options du menu principal
        var _options = ["Reprendre", "Options", "Sauvegarder", "Quitter"];
        for (var i = 0; i < 4; i++) {
            var _col = (global.pause_selection == i) ? c_white : c_gray;
            var _txt = _options[i];
            
            if (global.pause_selection == i) {
                _txt = "> " + _txt + " <";
                _col = make_color_rgb(100, 255, 140);
            }
            scr_draw_text_outline(_gw / 2, _gh / 2 - 40 + (i * 60), _txt, _col);
        }
    } 
    else if (global.pause_state == 1) {
        // Menu de Sauvegarde
        scr_draw_text_outline(_gw / 2, _gh / 2 - 120, "CHOISIR UN SLOT", make_color_rgb(255, 200, 0));
        
        // Affichage des 3 Slots
        for (var i = 0; i < 3; i++) {
            var _txt = "Slot " + string(i+1) + " : " + global.save_info[i];
            var _col = (global.pause_selection == i) ? c_white : c_gray;
            if (global.pause_selection == i) {
                _txt = "> " + _txt + " <";
                _col = make_color_rgb(100, 255, 140);
            }
            scr_draw_text_outline(_gw / 2, _gh / 2 - 40 + (i * 60), _txt, _col);
        }
        
        // Bouton Retour
        var _txt = "Retour";
        var _col = (global.pause_selection == 3) ? c_white : c_gray;
        if (global.pause_selection == 3) {
            _txt = "> " + _txt + " <";
            _col = make_color_rgb(100, 255, 140);
        }
        scr_draw_text_outline(_gw / 2, _gh / 2 - 40 + (3 * 60), _txt, _col);
    }
    else if (global.pause_state == 2) {
        // Sous-menu d'action sur le slot séléctionné
        scr_draw_text_outline(_gw / 2, _gh / 2 - 120, "SLOT " + string(global.selected_slot + 1), make_color_rgb(255, 200, 0));
        
        var _options = ["Ecraser la sauvegarde", "Lancer cette sauvegarde", "Retour"];
        for (var i = 0; i < 3; i++) {
            var _col = (global.pause_selection == i) ? c_white : c_gray;
            var _txt = _options[i];
            
            if (global.pause_selection == i) {
                _txt = "> " + _txt + " <";
                _col = make_color_rgb(100, 255, 140);
            }
            scr_draw_text_outline(_gw / 2, _gh / 2 - 20 + (i * 60), _txt, _col);
        }
    }
    else if (global.pause_state == 3) {
        scr_options_draw();
    }
    
    // Reset alignement
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
