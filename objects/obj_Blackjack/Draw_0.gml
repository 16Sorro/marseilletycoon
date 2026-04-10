/// @description Texte au-dessus de la table (Monde)

draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

// Texte flottant (Toujours visible pour trouver la zone)
scr_draw_text_outline(x, y - 60, "♦ LE BLACKJACK ♦", make_color_rgb(255, 200, 50));
scr_draw_text_outline(x, y - 30, "Approche-toi pour jouer", c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
