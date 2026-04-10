/// @description HUD Yacht – Achat ou embarquement

if (!variable_global_exists("yacht_owned")) { global.yacht_owned = false; }

if (player_near) {
    var _gw = display_get_gui_width();
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    if (!global.yacht_owned) {
        scr_draw_text_outline(_gw / 2, 20, "YACHT  (450 000 EUR)", make_color_rgb(100, 200, 255));
        scr_draw_text_outline(_gw / 2, 50, "Appuie sur E pour acheter", c_white);
    } else {
        scr_draw_text_outline(_gw / 2, 20, "TON YACHT", make_color_rgb(100, 255, 140));
        scr_draw_text_outline(_gw / 2, 50, "Appuie sur E pour monter à bord", c_white);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
