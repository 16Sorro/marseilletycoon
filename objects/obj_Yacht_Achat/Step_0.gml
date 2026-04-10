/// @description Step – Achat et accès au Yacht

if (!variable_global_exists("yacht_owned")) { global.yacht_owned = false; }

player_near = false;
var _player = instance_nearest(x, y, obj_Player);
if (_player != noone) {
    if (point_distance(x, y, _player.x, _player.y) < interact_range) {
        player_near = true;

        if (keyboard_check_pressed(ord("E"))) {
            if (!global.yacht_owned) {
                // ─── ACHAT ───────────────────────────────────────────────
                if (global.money >= yacht_price) {
                    global.money      -= yacht_price;
                    global.yacht_owned = true;

                    var _n = instance_create_layer(_player.x, _player.y - 32, "Instances", obj_Notification);
                    _n.msg        = "Yacht acheté ! Appuie sur E pour monter à bord.";
                    _n.color_text = c_lime;
                } else {
                    var _n = instance_create_layer(_player.x, _player.y - 32, "Instances", obj_Notification);
                    _n.msg        = "Pas assez de thune ! (450 000 EUR)";
                    _n.color_text = c_red;
                }
            } else {
                // ─── ENTRER DANS LE YACHT ─────────────────────────────────
                room_goto(rm_Yacht_Interieur);
            }
        }
    }
}
