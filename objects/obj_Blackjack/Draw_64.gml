/// @description Rendu Blackjack

if (!game_open) {
    if (player_near) {
        var _gw = display_get_gui_width();
        draw_set_halign(fa_center);
        scr_draw_text_outline(_gw / 2, 20, "Blackjack  —  Appuie sur E", make_color_rgb(255, 220, 50));
        draw_set_halign(fa_left);
    }
    exit;
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;
var _cy = _gh / 2;

// Fond
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(10, 40, 20)); // Vert tapis
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// Titre
draw_set_halign(fa_center);
scr_draw_text_outline(_cx, 30, "♣ BLACKJACK YACHT CLUB ♦", make_color_rgb(255, 215, 0));

if (state == 1) { // MISE
    scr_draw_text_outline(_cx, 200, "CHOISIS TA MISE", c_white);
    
    for (var i = 0; i < array_length(bet_amounts); i++) {
        var _bx = _cx - 450 + i * 150;
        var _by = 350;
        var _is_sel = (i == sel_bet_idx);
        
        draw_set_color(_is_sel ? c_yellow : c_white);
        draw_rectangle(_bx - 60, _by - 30, _bx + 60, _by + 30, true);
        draw_set_halign(fa_center);
        draw_text(_bx, _by - 10, string(bet_amounts[i]));
    }
    
    scr_draw_text_outline(_cx, 500, "Argent : " + string(global.money) + " EUR", c_yellow);
    scr_draw_text_outline(_cx, 600, "ENTRER pour jouer | ECHAP pour quitter", c_ltgray);

} else { // JEU
    
    // Main du croupier
    scr_draw_text_outline(_cx, 120, "CROUPIER", c_ltgray);
    var d_count = array_length(dealer_hand);
    for (var i = 0; i < d_count; i++) {
        var _x = _cx - (d_count*100)/2 + i*100;
        var _y = 180;
        
        // Cacher la 2eme carte si c'est le tour du joueur
        var is_hidden = (i == 1 && state == 2);
        
        draw_card_ui(_x, _y, is_hidden ? noone : dealer_hand[i]);
    }
    if (state != 2) scr_draw_text_outline(_cx, 310, "Score: " + string(calculate_score(dealer_hand)), c_white);

    // Main du joueur
    scr_draw_text_outline(_cx, _gh - 350, "TON JEU", c_white);
    var p_count = array_length(player_hand);
    for (var i = 0; i < p_count; i++) {
        var _x = _cx - (p_count*100)/2 + i*100;
        var _y = _gh - 280;
        draw_card_ui(_x, _y, player_hand[i]);
    }
    scr_draw_text_outline(_cx, _gh - 150, "Score: " + string(player_score), c_yellow);

    // Contrôles
    if (state == 2) {
        scr_draw_text_outline(_cx, _gh - 80, "[H] TIRER  |  [S] RESTER", c_white);
    } else if (state == 4) {
        scr_draw_text_outline(_cx, _cy, msg_result, (player_score > 21 || (dealer_score <= 21 && dealer_score > player_score)) ? c_red : c_lime);
        scr_draw_text_outline(_cx, _gh - 80, "ESPACE POUR REJOUER", c_white);
    }
}

draw_set_halign(fa_left);

function draw_card_ui(_x, _y, _card) {
    var cw = 80;
    var ch = 120;
    
    // Fond carte
    draw_set_color(c_white);
    draw_rectangle(_x, _y, _x + cw, _y + ch, false);
    draw_set_color(c_black);
    draw_rectangle(_x, _y, _x + cw, _y + ch, true);
    
    if (_card != noone) {
        var val_str = string(_card.val);
        if (_card.val == 11) val_str = "J";
        if (_card.val == 12) val_str = "Q";
        if (_card.val == 13) val_str = "K";
        if (_card.val == 14) val_str = "A";
        
        var suits = ["♠", "♥", "♦", "♣"];
        var suit_str = suits[_card.suit];
        var is_red = (_card.suit == 1 || _card.suit == 2);
        
        draw_set_color(is_red ? c_red : c_black);
        draw_text(_x + 5, _y + 5, val_str + suit_str);
        draw_set_halign(fa_center);
        draw_text(_x + cw/2, _y + ch/2, suit_str);
        draw_set_halign(fa_left);
    } else {
        // Dos de la carte
        draw_set_color(c_maroon);
        draw_rectangle(_x + 5, _y + 5, _x + cw - 5, _y + ch - 5, false);
    }
}
