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
