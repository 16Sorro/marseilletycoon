/// scr_draw_text_outline(x, y, text, color_main)
/// Dessine un texte avec contour noir visible

function scr_draw_text_outline(_x, _y, _txt, _col) {
    // Contour noir (4 directions décalées de 1px)
    draw_set_color(c_black);
    draw_text(_x - 1, _y - 1, _txt);
    draw_text(_x + 1, _y - 1, _txt);
    draw_text(_x - 1, _y + 1, _txt);
    draw_text(_x + 1, _y + 1, _txt);
    // Texte principal par-dessus
    draw_set_color(_col);
    draw_text(_x, _y, _txt);
    // Reset couleur
    draw_set_color(c_white);
}
