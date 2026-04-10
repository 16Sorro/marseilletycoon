/// @description Affichage du nom et prix du Yacht au-dessus de l'instance

if (!variable_global_exists("yacht_owned")) { global.yacht_owned = false; }

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

if (!global.yacht_owned) {
    scr_draw_text_outline(x, y - 32, "YACHT", make_color_rgb(100, 200, 255));
    scr_draw_text_outline(x, y - 5,  "450 000 EUR", c_white);
} else {
    scr_draw_text_outline(x, y - 20, "TON YACHT", make_color_rgb(100, 255, 140));
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
