/// @description Logique de la Bourse

// ── Flag global (bloque le joueur pendant le trading) ─────────────────────
if (!variable_global_exists("bourse_active")) { global.bourse_active = false; }
global.bourse_active = bourse_open || (bourse_state == 2);

// ── Animation des bougies (tourne même si le menu est fermé) ──────────────
if (bourse_state == 2) {
    trade_timer   += delta_time / 1000000;
    candles_shown  = min(floor(trade_timer / 0.5) + 1, array_length(candles));

    if (trade_timer >= trade_duration) {
        bourse_state  = 3;
        global.money += active_bet_amt + profit_val; // Rembourse mise ± profit
    }
}

// ── Détection du joueur ───────────────────────────────────────────────────
player_near = false;
var _p = instance_nearest(x, y, obj_Player);
if (_p != noone && point_distance(x, y, _p.x, _p.y) < interact_range) {
    player_near = true;
    if (keyboard_check_pressed(ord("E")) && bourse_state != 2) {
        bourse_open = !bourse_open;
        if (bourse_open) {
            bourse_state = 0;
            sel_stock    = 0;
            sel_bet      = 0;
        }
    }
}

if (!bourse_open) exit;

// ── ECHAP = retour / fermer ───────────────────────────────────────────────
if (keyboard_check_pressed(vk_escape)) {
    if (bourse_state == 0 || bourse_state == 3) { bourse_open = false; }
    else if (bourse_state == 1)                 { bourse_state = 0; }
}

// ── ÉTAT 0 : Sélection d'une action ──────────────────────────────────────
if (bourse_state == 0) {
    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(ord("W"))) {
        sel_stock = (sel_stock - 1 + array_length(stock_names)) mod array_length(stock_names);
    }
    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        sel_stock = (sel_stock + 1) mod array_length(stock_names);
    }
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        bourse_state = 1;
        sel_bet      = 0;
    }
}

// ── ÉTAT 1 : Sélection de la mise ────────────────────────────────────────
else if (bourse_state == 1) {
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("Q")) || keyboard_check_pressed(ord("A"))) {
        sel_bet = (sel_bet - 1 + array_length(bet_options)) mod array_length(bet_options);
    }
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
        sel_bet = (sel_bet + 1) mod array_length(bet_options);
    }
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        var _bet = bet_options[sel_bet];
        if (global.money >= _bet) {
            global.money    -= _bet;
            active_stock_idx = sel_stock;
            active_bet_amt   = _bet;
            entry_price      = stock_prices[sel_stock];

            // 35% de chances de gagner
            trade_won = (random(1) < 0.35);

            // Génère 20 bougies avec trend selon résultat
            candles = [];
            var _price = entry_price;
            for (var i = 0; i < 20; i++) {
                var _o     = _price;
                var _trend = trade_won ? random_range(-0.012, 0.035) : random_range(-0.035, 0.012);
                var _c     = _o * (1 + _trend);
                var _hw    = random_range(0.003, 0.009);
                var _lw    = random_range(0.003, 0.009);
                array_push(candles, {
                    o : _o,
                    c : _c,
                    h : max(_o, _c) * (1 + _hw),
                    l : min(_o, _c) * (1 - _lw)
                });
                _price = _c;
            }

            final_price = candles[array_length(candles) - 1].c;
            var _shares = active_bet_amt / entry_price;
            profit_val  = _shares * (final_price - entry_price);
            var _pct    = (final_price - entry_price) / entry_price * 100;

            if (profit_val > 0) {
                result_msg = "GAGNÉ !  +" + string(round(profit_val)) + " EUR    (+" + string_format(_pct, 1, 2) + "%)";
            } else {
                result_msg = "PERDU !   " + string(round(profit_val)) + " EUR    (" + string_format(_pct, 1, 2) + "%)";
            }

            candles_shown = 1;
            trade_timer   = 0;
            bourse_state  = 2;

        } else {
            // Pas assez de thune
            var _notif = instance_create_layer(_p.x, _p.y - 32, "Instances", obj_Notification);
            if (instance_exists(_notif)) {
                _notif.msg        = "Pas assez de thune pour miser !";
                _notif.color_text = c_red;
            }
        }
    }
}

// ── ÉTAT 3 : Résultat — presse ESPACE pour relancer ──────────────────────
else if (bourse_state == 3) {
    if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
        bourse_state = 0;
        sel_stock    = 0;
    }
}
