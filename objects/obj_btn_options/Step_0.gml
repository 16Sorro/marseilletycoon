if (variable_global_exists("in_options_menu") && global.in_options_menu) {
    if (scr_options_step()) {
        global.in_options_menu = false; // Retour
    }
    exit;
}

// Agrandissement léger au survol
if (position_meeting(mouse_x, mouse_y, id)) {
    image_xscale = 1.05;
    image_yscale = 1.05;
} else {
    image_xscale = 1;
    image_yscale = 1;
}