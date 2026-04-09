/// @description Déplacement + interaction avec les businesses

// ─── MOUVEMENT (ZQSD + flèches) ───────────────────────────────────────────
var _dx = 0;
var _dy = 0;

if (keyboard_check(ord("Z")) || keyboard_check(vk_up))    { _dy = -spd; }
if (keyboard_check(ord("S")) || keyboard_check(vk_down))  { _dy =  spd; }
if (keyboard_check(ord("Q")) || keyboard_check(vk_left))  { _dx = -spd; }
if (keyboard_check(ord("D")) || keyboard_check(vk_right)) { _dx =  spd; }

if (place_free(x + _dx, y)) { x += _dx; }
if (place_free(x, y + _dy)) { y += _dy; }

// ─── ORIENTATION DU SPRITE (sens inversé, taille préservée) ──────────────
if (_dx > 0) { image_xscale = -base_scale; } // Droite → retourné
if (_dx < 0) { image_xscale =  base_scale; } // Gauche → normal


// ─── DÉTECTION DU BUSINESS LE PLUS PROCHE ────────────────────────────────
near_business = noone;
can_buy       = false;

var _biz = instance_nearest(x, y, obj_Business);
if (_biz != noone) {
    if (point_distance(x, y, _biz.x, _biz.y) < interact_range) {
        near_business = _biz;
        can_buy       = true;
    }
}

// ─── ACHAT D'UN BUSINESS (touche E) ──────────────────────────────────────
if (keyboard_check_pressed(ord("E")) && can_buy && near_business != noone) {
    var _idx = near_business.biz_index;

    if (!global.biz_owned[_idx]) {
        if (global.money >= global.biz_price[_idx]) {
            // Achat validé
            global.money          -= global.biz_price[_idx];
            global.biz_owned[_idx] = true;
            global.income_per_sec += global.biz_income[_idx];

            var _n = instance_create_layer(x, y - 32, "Instances", obj_Notification);
            _n.msg        = global.biz_name[_idx] + " acheté !";
            _n.color_text = c_lime;

        } else {
            // Pas assez de thune
            var _n = instance_create_layer(x, y - 32, "Instances", obj_Notification);
            _n.msg        = "Pas assez de thune frère !";
            _n.color_text = c_red;
        }
    }
}
