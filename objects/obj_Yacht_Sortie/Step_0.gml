/// @description Step – Sortie du yacht
player_near = false;
var _player = instance_nearest(x, y, obj_Player);
if (_player != noone) {
    if (point_distance(x, y, _player.x, _player.y) < interact_range) {
        player_near = true;
        if (keyboard_check_pressed(ord("E"))) {
            room_goto(rm_Marseille);
        }
    }
}
