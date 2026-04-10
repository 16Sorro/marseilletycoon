/// @description Texte au-dessus de la table (Monde)

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// Texte flottant
scr_draw_text_outline(x, y - 40, "TABLE DE BLACKJACK", make_color_rgb(255, 215, 0));
scr_draw_text_outline(x, y - 10, "STAKES: 50 - 20 000 EUR", c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
