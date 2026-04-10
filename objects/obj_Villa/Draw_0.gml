/// @description Affiche le nom + prix au-dessus de la villa dans le monde

if (!variable_global_exists("villa_owned")) { global.villa_owned = false; }

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

if (!global.villa_owned) {
    // Pas encore achetée : affiche nom + prix en jaune/blanc comme les businesses
    scr_draw_text_outline(x, y - 32, "VILLA", make_color_rgb(255, 200, 0));
    scr_draw_text_outline(x, y - 5, "350 000 EUR", c_white);
} else {
    // Achetée : affiche "TA VILLA" en vert
    scr_draw_text_outline(x, y - 20, "TA VILLA", make_color_rgb(100, 255, 140));
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
