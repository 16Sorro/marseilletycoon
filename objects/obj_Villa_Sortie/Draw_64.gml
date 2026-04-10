/// @description HUD sortie villa
if (player_near) {
    var _gw = display_get_gui_width();
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    scr_draw_text_outline(_gw / 2, 20, "Appuie sur E pour sortir", c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
