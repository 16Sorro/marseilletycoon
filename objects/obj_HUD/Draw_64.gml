/// @description HUD — Argent + Revenu par seconde (texte avec contour noir)

// ─── PANNEAU FOND ─────────────────────────────────────────────────────────
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_roundrect_ext(10, 10, 270, 95, 8, 8, false);
draw_set_alpha(1);
draw_set_halign(fa_left);

// ─── TITRE ───────────────────────────────────────────────────────────────
scr_draw_text_outline(20, 16, "COMPTE EN BANQUE", make_color_rgb(255, 200, 0));

// ─── ARGENT ACTUEL ───────────────────────────────────────────────────────
scr_draw_text_outline(20, 36, string(floor(global.money)) + " EUR", c_white);

// ─── SÉPARATEUR ──────────────────────────────────────────────────────────
draw_set_color(make_color_rgb(100, 100, 100));
draw_line(20, 58, 260, 58);

// ─── REVENU PAR SECONDE ──────────────────────────────────────────────────
scr_draw_text_outline(20, 64, "+" + string(global.income_per_sec) + " EUR/seconde", make_color_rgb(100, 255, 140));

// ─── BUSINESSES ACTIFS ───────────────────────────────────────────────────
var _count = 0;
for (var _i = 0; _i < 6; _i++) {
    if (global.biz_owned[_i]) { _count++; }
}
scr_draw_text_outline(20, 80, "Business : " + string(_count) + "/6", make_color_rgb(180, 180, 255));

// Reset
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_color(c_white);
