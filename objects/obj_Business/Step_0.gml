/// @description Synchronise la variable locale 'owned' avec la globale

if (!variable_global_exists("biz_owned")) { exit; }
owned = global.biz_owned[biz_index];