/// @description Affiche nom, prix/revenu, bulle dialogue et prompt [E]

draw_self();

var _player = instance_find(obj_Player, 0);
var _dist   = ((_player != noone) ? point_distance(x, y, _player.x, _player.y) : 9999);
var _proche = (_dist < 80);

// ─── NOM DU BUSINESS ─────────────────────────────────────────────────────
draw_set_halign(fa_center);
scr_draw_text_outline(x, y - 32, global.biz_name[biz_index], c_white);

// ─── PRIX ou REVENU ──────────────────────────────────────────────────────
if (!owned) {
    if (global.biz_price[biz_index] == 0) {
        scr_draw_text_outline(x, y - 48, "GRATUIT", c_yellow);
    } else {
        scr_draw_text_outline(x, y - 48, string(global.biz_price[biz_index]) + " EUR", c_yellow);
    }
} else {
    scr_draw_text_outline(x, y - 48, "+" + string(global.biz_income[biz_index]) + " EUR/s ", make_color_rgb(80, 255, 120));
}

// ─── BULLE DE DIALOGUE (proximité) ───────────────────────────────────────
if (_proche && variable_global_exists("biz_dialogue")) {
    scr_draw_bubble(x, y - 55, global.biz_dialogue[biz_index]);
}

// ─── PROMPT [E] ──────────────────────────────────────────────────────────
if (_proche && !owned) {
    scr_draw_text_outline(x, y + 32, "[E] Acheter", c_white);
}

// Reset
draw_set_halign(fa_left);
draw_set_color(c_white);
