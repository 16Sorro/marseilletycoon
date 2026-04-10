/// @description HUD villa – Prix ou statut "Appuie sur E"

if (!variable_global_exists("villa_owned")) { global.villa_owned = false; }

if (player_near) {
    var _gw = display_get_gui_width();
    
    if (!global.villa_owned) {
        // Affiche le prix
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        scr_draw_text_outline(_gw / 2, 20, "VILLA (350 000 EUR)", make_color_rgb(255, 200, 0));
        scr_draw_text_outline(_gw / 2, 50, "Appuie sur E pour acheter", c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    } else {
        // Villa possédée – invite à entrer
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        scr_draw_text_outline(_gw / 2, 20, "TA VILLA", make_color_rgb(100, 255, 140));
        scr_draw_text_outline(_gw / 2, 50, "Appuie sur E pour entrer", c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}
