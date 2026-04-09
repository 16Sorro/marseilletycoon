/// scr_draw_bubble(x, y, text)
/// Dessine une bulle de dialogue au-dessus d'un point

function scr_draw_bubble(_x, _y, _txt) {
    var _scale = 1.4; // Plus grand et lisible
    var _pad   = 10;
    var _w     = string_width(_txt) * _scale + _pad * 2;
    var _h     = string_height(_txt) * _scale + _pad * 2;
    var _bx    = _x - _w / 2;
    var _by    = _y - _h - 30; // Au-dessus du PNJ

    // Fond noir transparent de la bulle
    draw_set_color(c_black);
    draw_set_alpha(0.65);
    draw_roundrect_ext(_bx, _by, _bx + _w, _by + _h, 16, 16, false);

    // Bordure
    draw_set_color(c_white);
    draw_set_alpha(0.7);
    draw_roundrect_ext(_bx, _by, _bx + _w, _by + _h, 16, 16, true);

    // Petite flèche en bas de la bulle
    draw_set_alpha(0.65);
    draw_set_color(c_black);
    draw_triangle(
        _x - 10, _by + _h,
        _x + 10, _by + _h,
        _x,      _by + _h + 15,
        false
    );
    draw_set_alpha(0.7);
    draw_set_color(c_white);
    draw_line(_x - 10, _by + _h, _x, _by + _h + 15);
    draw_line(_x + 10, _by + _h, _x, _by + _h + 15);

    // Texte dans la bulle
    draw_set_alpha(1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    // Mini-ombre du texte pour détacher
    draw_set_color(c_black);
    draw_text_transformed(_bx + _w / 2 + 1, _by + _pad + 1, _txt, _scale, _scale, 0);
    
    // Texte principal blanc
    draw_set_color(c_white);
    draw_text_transformed(_bx + _w / 2, _by + _pad, _txt, _scale, _scale, 0);

    // Reset
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
