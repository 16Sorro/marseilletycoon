/// scr_draw_bubble(x, y, text)
/// Dessine une bulle de dialogue au-dessus d'un point

function scr_draw_bubble(_x, _y, _txt) {
    var _pad   = 10;
    var _w     = string_width(_txt)  + _pad * 2;
    var _h     = string_height(_txt) + _pad * 2;
    var _bx    = _x - _w / 2;
    var _by    = _y - _h - 20; // Au-dessus du PNJ

    // Fond blanc de la bulle
    draw_set_color(c_white);
    draw_set_alpha(0.92);
    draw_roundrect_ext(_bx, _by, _bx + _w, _by + _h, 6, 6, false);

    // Bordure noire
    draw_set_color(c_black);
    draw_set_alpha(1);
    draw_roundrect_ext(_bx, _by, _bx + _w, _by + _h, 6, 6, true);

    // Petite flèche en bas de la bulle
    draw_triangle(
        _x - 8, _by + _h,
        _x + 8, _by + _h,
        _x,     _by + _h + 12,
        false
    );
    draw_set_color(c_white);
    draw_triangle(
        _x - 6, _by + _h - 1,
        _x + 6, _by + _h - 1,
        _x,     _by + _h + 10,
        false
    );

    // Texte dans la bulle
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_text(_bx + _w / 2, _by + _pad, _txt);

    // Reset
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
