/// @description Notification — affichage du texte flottant

draw_set_alpha(alpha_val);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(color_text);
draw_text(x, y, msg);

// Reset
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
