/// @description Initialise le Blackjack

game_open = false;
interact_range = 350;
player_near = false;

// Etats : 0=Inactif, 1=Mise, 2=Joueur, 3=Croupier, 4=Resultat
state = 0;

// Variables de jeu
player_hand = [];
dealer_hand = [];
player_score = 0;
dealer_score = 0;

bet_amounts = [50, 100, 500, 1000, 5000, 10000, 20000];
sel_bet_idx = 0;
current_bet = 0;

msg_result = "";
is_rigged_win = false;

// Pour le rendu des cartes
card_width = 80;
card_height = 120;

/// @function draw_card(value, suit)
// On utilisera des simples structs pour les cartes {val: 2..14, suit: 0..3}
// 11=J, 12=Q, 13=K, 14=A

function get_card_val(card) {
    if (card.val <= 10) return card.val;
    if (card.val <= 13) return 10;
    return 11; // Ace par défaut
}

function calculate_score(hand) {
    var _score = 0;
    var aces = 0;
    for (var i = 0; i < array_length(hand); i++) {
        var v = get_card_val(hand[i]);
        _score += v;
        if (hand[i].val == 14) aces++;
    }
    while (_score > 21 && aces > 0) {
        _score -= 10;
        aces--;
    }
    return _score;
}

function get_random_card() {
    return {
        val: irandom_range(2, 14),
        suit: irandom(3)
    };
}
