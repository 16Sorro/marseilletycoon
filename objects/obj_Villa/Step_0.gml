/// @description Step – Gestion achat et entrée Villa

player_near = false;

var _player = instance_nearest(x, y, obj_Player);
if (_player != noone) {
    var _dist = point_distance(x, y, _player.x, _player.y);
    
    if (_dist < interact_range) {
        player_near = true;
        
        if (keyboard_check_pressed(ord("E"))) {
            
            if (!variable_global_exists("villa_owned")) { global.villa_owned = false; }
            
            if (!global.villa_owned) {
                // ─── ACHAT ───────────────────────────────────────────────
                if (global.money >= villa_price) {
                    global.money       -= villa_price;
                    global.villa_owned  = true;
                    
                    var _n = instance_create_layer(_player.x, _player.y - 32, "Instances", obj_Notification);
                    _n.msg        = "Villa achetée ! Appuie sur E pour entrer.";
                    _n.color_text = c_lime;
                } else {
                    var _n = instance_create_layer(_player.x, _player.y - 32, "Instances", obj_Notification);
                    _n.msg        = "Pas assez de thune ! (350 000 EUR)";
                    _n.color_text = c_red;
                }
            } else {
                // ─── ENTRER DANS LA VILLA ─────────────────────────────────
                room_goto(rm_Villa_Interieur);
            }
        }
    }
}
