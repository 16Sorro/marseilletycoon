/// @description Logique du Blackjack

// Bloquer le joueur si le jeu est ouvert
if (!variable_global_exists("blackjack_active")) { global.blackjack_active = false; }
global.blackjack_active = game_open;

// Proximité
player_near = false;
var _p = instance_nearest(x, y, obj_Player);
if (_p != noone && point_distance(x, y, _p.x, _p.y) < interact_range) {
    player_near = true;
    if (keyboard_check_pressed(ord("E")) && !game_open) {
        game_open = true;
        state = 1; // Mise
        sel_bet_idx = 0;
        // Reset des scores au cas où
        player_hand = [];
        dealer_hand = [];
        player_score = 0;
        dealer_score = 0;
    }
}

if (!game_open) exit;

// ECHAP pour fermer (seulement si pas en plein milieu d'une main)
if (keyboard_check_pressed(vk_escape)) {
    if (state == 1 || state == 4) game_open = false;
}

switch(state) {
    case 1: // MISE
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("A"))) {
            sel_bet_idx = (sel_bet_idx - 1 + array_length(bet_amounts)) mod array_length(bet_amounts);
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
            sel_bet_idx = (sel_bet_idx + 1) mod array_length(bet_amounts);
        }
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            current_bet = bet_amounts[sel_bet_idx];
            if (global.money >= current_bet) {
                global.money -= current_bet;
                
                // --- INITIALISATION MAIN ---
                player_hand = [];
                dealer_hand = [];
                
                // Rigging: 67% de chance de gagner
                is_rigged_win = (random(100) < 67);
                
                // Distribution initiale
                array_push(player_hand, get_random_card());
                array_push(player_hand, get_random_card());
                array_push(dealer_hand, get_random_card());
                array_push(dealer_hand, get_random_card());
                
                player_score = calculate_score(player_hand);
                dealer_score = calculate_score(dealer_hand);
                
                // --- CHECK BLACKJACK IMMEDIAT ---
                if (player_score == 21) {
                    msg_result = "BLACKJACK !";
                    global.money += current_bet * 2.5; // Gain bonus blackjack
                    state = 4;
                } else {
                    state = 2; // Tour du joueur
                }
            } else {
                // Notification thune (optionnel, déjà géré dans la bourse)
            }
        }
        break;

    case 2: // TOUR JOUEUR
        // Hit
        if (keyboard_check_pressed(ord("H")) || keyboard_check_pressed(ord("C"))) {
            var new_card = get_random_card();
            
            // Rigging : si on doit gagner, on évite de faire sauter le joueur
            if (is_rigged_win) {
                var attempts = 0;
                while (calculate_score(player_hand) + get_card_val(new_card) > 21 && attempts < 10) {
                    new_card = get_random_card();
                    attempts++;
                }
            }
            
            array_push(player_hand, new_card);
            player_score = calculate_score(player_hand);
            
            if (player_score == 21) {
                msg_result = "BLACKJACK !";
                global.money += current_bet * 2;
                state = 4;
            } else if (player_score > 21) {
                msg_result = "TROP ! MAISON GAGNE";
                state = 4;
            }
        }
        // Stand
        if (keyboard_check_pressed(ord("S")) || keyboard_check_pressed(ord("R"))) {
            state = 3; // Tour croupier
        }
        break;

    case 3: // TOUR CROUPIER
        dealer_score = calculate_score(dealer_hand);
        
        // Logique croupier classique (tire jusqu'à 17)
        // Rigging : si rigged_win et que le croupier bat le joueur, on le force à tirer jusqu'au bust
        var should_hit = (dealer_score < 17);
        if (is_rigged_win && dealer_score >= player_score && dealer_score <= 21) {
            should_hit = true;
        }

        if (should_hit) {
            var new_card = get_random_card();
            // Si rigged_win et que le croupier va bust, c'est parfait, on laisse faire.
            // Si on ne doit PAS gagner, on essaye de ne pas faire bust le croupier.
            if (!is_rigged_win && dealer_score + get_card_val(new_card) > 21) {
                var attempts = 0;
                while (dealer_score + get_card_val(new_card) > 21 && attempts < 10) {
                    new_card = get_random_card();
                    attempts++;
                }
            }
            
            array_push(dealer_hand, new_card);
        } else {
            // Fin du tour croupier, calcul du gagnant
            if (dealer_score > 21) {
                msg_result = "CROUPIER SAUTE ! TU GAGNES";
                global.money += current_bet * 2;
            } else if (dealer_score > player_score) {
                msg_result = "MAISON GAGNE (" + string(dealer_score) + ")";
            } else if (dealer_score < player_score) {
                msg_result = "TU GAGNES ! (" + string(player_score) + ")";
                global.money += current_bet * 2;
            } else {
                msg_result = "EGALITE ! REMBOURSE";
                global.money += current_bet;
            }
            state = 4;
        }
        break;

    case 4: // RESULTAT
        if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
            state = 1; // Rejouer
        }
        break;
}
