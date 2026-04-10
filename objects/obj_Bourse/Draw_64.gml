/// @description Rendu GUI de la Bourse — Tableau + Graphique en bougies

// ── Hint de proximité (hors interface) ───────────────────────────────────
if (!bourse_open && bourse_state != 2) {
    if (player_near) {
        var _gw = display_get_gui_width();
        draw_set_halign(fa_center);
        scr_draw_text_outline(_gw / 2, 20, "Bourse  —  Appuie sur E", make_color_rgb(255, 220, 50));
        draw_set_halign(fa_left);
    }
    exit;
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw / 2;

// Fond sombre global
draw_set_alpha(0.93);
draw_set_color(make_color_rgb(6, 10, 24));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// Titre
draw_set_halign(fa_center);
scr_draw_text_outline(_cx, 18, "▲  LA BOURSE DE MARSEILLE  ▲", make_color_rgb(255, 200, 50));
draw_set_halign(fa_left);

// ══════════════════════════════════════════════════════════════════════════
// ÉTAT 0 : Tableau des actions
// ══════════════════════════════════════════════════════════════════════════
if (bourse_state == 0) {
    var _cols    = [100, 480, 760, 1020, 1480];
    var _headers = ["ACTION", "PRIX (EUR)", "VAR. 24H", "COURBE 7J", "INTENSITÉ"];

    // Barre de colonne header
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(15, 25, 60));
    draw_rectangle(70, 92, _gw - 70, 138, false);
    draw_set_alpha(1);

    for (var i = 0; i < array_length(_headers); i++) {
        scr_draw_text_outline(_cols[i], 98, _headers[i], make_color_rgb(140, 160, 220));
    }

    // Séparateur
    draw_set_color(make_color_rgb(40, 50, 100));
    draw_line(70, 138, _gw - 70, 138);

    // Lignes des actions
    for (var r = 0; r < array_length(stock_names); r++) {
        var _ry     = 158 + r * 145;
        var _is_sel = (r == sel_stock);

        // Fond de ligne
        if (_is_sel) {
            draw_set_alpha(0.22);
            draw_set_color(make_color_rgb(80, 200, 255));
            draw_rectangle(70, _ry - 8, _gw - 70, _ry + 118, false);
            draw_set_alpha(1);
        } else if (r mod 2 == 0) {
            draw_set_alpha(0.07);
            draw_set_color(c_white);
            draw_rectangle(70, _ry - 8, _gw - 70, _ry + 118, false);
            draw_set_alpha(1);
        }

        // Nom
        var _name_col = _is_sel ? make_color_rgb(100, 255, 200) : c_white;
        var _prefix   = _is_sel ? "▶ " : "  ";
        scr_draw_text_outline(_cols[0], _ry, _prefix + stock_names[r], _name_col);

        // Prix
        scr_draw_text_outline(_cols[1], _ry, string_format(stock_prices[r], 1, 2), _name_col);

        // Variation 24h
        var _ch     = stock_change24[r];
        var _ch_col = _ch >= 0 ? make_color_rgb(50, 220, 80) : make_color_rgb(220, 60, 60);
        var _ch_txt = (_ch >= 0 ? "+" : "") + string_format(_ch, 1, 2) + "%";
        scr_draw_text_outline(_cols[2], _ry, _ch_txt, _ch_col);

        // ── Mini sparkline ──────────────────────────────────────────────
        var _sp   = stock_sparklines[r];
        var _spn  = array_length(_sp);
        var _sx   = _cols[3];
        var _sy   = _ry + 60;
        var _sw   = 370;
        var _sh   = 55;

        // Min / max sparkline
        var _sp_min = 0; var _sp_max = 0;
        for (var k = 0; k < _spn; k++) {
            _sp_min = min(_sp_min, _sp[k]);
            _sp_max = max(_sp_max, _sp[k]);
        }
        var _sp_r = _sp_max - _sp_min;
        if (_sp_r < 0.01) _sp_r = 0.01;

        // Fond sparkline
        draw_set_alpha(0.3);
        draw_set_color(c_black);
        draw_rectangle(_sx, _sy - _sh / 2, _sx + _sw, _sy + _sh / 2, false);
        draw_set_alpha(1);

        // Ligne sparkline
        draw_set_color(_ch_col);
        for (var k = 1; k < _spn; k++) {
            var _x1 = _sx + (k - 1) / (_spn - 1) * _sw;
            var _y1 = (_sy + _sh / 2) - (_sp[k - 1] - _sp_min) / _sp_r * _sh;
            var _x2 = _sx + k / (_spn - 1) * _sw;
            var _y2 = (_sy + _sh / 2) - (_sp[k] - _sp_min) / _sp_r * _sh;
            draw_line(_x1, _y1, _x2, _y2);
        }

        // ── Barre d'intensité ────────────────────────────────────────────
        var _bx    = _cols[4];
        var _bw    = 280;
        var _bh    = 20;
        var _bfill = clamp(abs(_ch) / 5.0, 0, 1) * _bw;

        draw_set_color(make_color_rgb(20, 28, 55));
        draw_rectangle(_bx, _ry + 8, _bx + _bw, _ry + 8 + _bh, false);
        draw_set_color(_ch_col);
        draw_rectangle(_bx, _ry + 8, _bx + _bfill, _ry + 8 + _bh, false);

        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_bx + _bw / 2, _ry + 8, _ch_txt);
        draw_set_halign(fa_left);
    }

    // Instructions
    draw_set_halign(fa_center);
    scr_draw_text_outline(_cx, _gh - 55, "Z/S  ou  ↑↓  pour naviguer   |   ESPACE pour sélectionner   |   ECHAP pour fermer", make_color_rgb(100, 110, 150));
    draw_set_halign(fa_left);
}

// ══════════════════════════════════════════════════════════════════════════
// ÉTAT 1 : Sélection de la mise
// ══════════════════════════════════════════════════════════════════════════
else if (bourse_state == 1) {
    draw_set_halign(fa_center);

    scr_draw_text_outline(_cx, 88,  "ACTION : " + stock_names[sel_stock], make_color_rgb(100, 200, 255));
    scr_draw_text_outline(_cx, 138, "Prix actuel : " + string_format(stock_prices[sel_stock], 1, 2) + " EUR", c_white);

    var _ch24     = stock_change24[sel_stock];
    var _ch24_col = _ch24 >= 0 ? make_color_rgb(50,220,80) : make_color_rgb(220,60,60);
    scr_draw_text_outline(_cx, 185, "Variation 24h : " + (_ch24 >= 0 ? "+" : "") + string_format(_ch24,1,2) + "%", _ch24_col);

    scr_draw_text_outline(_cx, 270, "────  CHOISIR TA MISE  ────", make_color_rgb(200, 200, 255));

    for (var i = 0; i < array_length(bet_options); i++) {
        var _bx     = _cx - 720 + i * 480;
        var _by     = 360;
        var _is_sel = (i == sel_bet);

        // Carte
        draw_set_alpha(0.85);
        draw_set_color(_is_sel ? make_color_rgb(15,55,25) : make_color_rgb(12,18,40));
        draw_rectangle(_bx - 170, _by - 35, _bx + 170, _by + 70, false);
        draw_set_alpha(1);
        draw_set_color(_is_sel ? make_color_rgb(80,255,130) : make_color_rgb(40,55,110));
        draw_rectangle(_bx - 170, _by - 35, _bx + 170, _by + 70, true);

        var _bet_col = _is_sel ? make_color_rgb(80,255,130) : c_white;
        scr_draw_text_outline(_bx, _by, string(bet_options[i]) + " EUR", _bet_col);

        // Gain potentiel (estimation ~25%)
        var _est = round(bet_options[i] * 0.25);
        draw_set_color(make_color_rgb(80, 220, 100));
        draw_set_halign(fa_center);
        draw_text(_bx, _by + 48, "gain estimé : +" + string(_est) + " EUR");
        draw_set_halign(fa_left);
    }

    draw_set_halign(fa_center);
    scr_draw_text_outline(_cx, _gh - 130, "Capital : " + string(floor(global.money)) + " EUR", make_color_rgb(255, 200, 50));
    scr_draw_text_outline(_cx, _gh - 75,  "Q/D  ou  ←→  pour choisir   |   ESPACE pour confirmer   |   ECHAP pour retour", make_color_rgb(100,110,150));
    draw_set_halign(fa_left);
}

// ══════════════════════════════════════════════════════════════════════════
// ÉTATS 2 & 3 : Graphique en bougies candlestick
// ══════════════════════════════════════════════════════════════════════════
else if (bourse_state == 2 || bourse_state == 3) {

    // ── Bandeau d'information ────────────────────────────────────────────
    scr_draw_text_outline(80,  78, stock_names[active_stock_idx],                       make_color_rgb(100, 200, 255));
    scr_draw_text_outline(500, 78, "Mise : " + string(active_bet_amt) + " EUR",         c_white);
    scr_draw_text_outline(900, 78, "Entrée : " + string_format(entry_price, 1, 2) + " EUR", make_color_rgb(255,220,50));

    if (bourse_state == 2) {
        var _secs_left = max(0, ceil(trade_duration - trade_timer));
        scr_draw_text_outline(1480, 78, string(_secs_left) + " sec", make_color_rgb(180, 180, 255));
    }

    // ── Zone du graphique ────────────────────────────────────────────────
    var _chart_x = 60;
    var _chart_y = 115;
    var _chart_w = _gw - 180;
    var _chart_h = _gh - 265;

    // Fond du chart
    draw_set_color(make_color_rgb(3, 6, 18));
    draw_rectangle(_chart_x, _chart_y, _chart_x + _chart_w, _chart_y + _chart_h, false);
    draw_set_color(make_color_rgb(25, 35, 70));
    draw_rectangle(_chart_x, _chart_y, _chart_x + _chart_w, _chart_y + _chart_h, true);

    var _num = min(candles_shown, array_length(candles));

    if (_num > 0) {
        // ── Calcul de l'échelle de prix ──────────────────────────────────
        var _min_p = entry_price;
        var _max_p = entry_price;
        for (var i = 0; i < _num; i++) {
            _min_p = min(_min_p, candles[i].l);
            _max_p = max(_max_p, candles[i].h);
        }
        // Forcer un range minimum de 5%
        var _rng_min = entry_price * 0.05;
        if (_max_p - _min_p < _rng_min) {
            _min_p = entry_price - _rng_min / 2;
            _max_p = entry_price + _rng_min / 2;
        }
        var _pad  = (_max_p - _min_p) * 0.12;
        _min_p   -= _pad;
        _max_p   += _pad;
        var _pr   = _max_p - _min_p;
        if (_pr <= 0) _pr = 1;

        // ── Grille de prix ───────────────────────────────────────────────
        var _grid_n = 6;
        for (var g = 0; g <= _grid_n; g++) {
            var _gp = _min_p + (_max_p - _min_p) * g / _grid_n;
            var _gy = _chart_y + _chart_h - (_gp - _min_p) / _pr * _chart_h;

            draw_set_alpha(0.10);
            draw_set_color(c_white);
            draw_line(_chart_x, _gy, _chart_x + _chart_w, _gy);
            draw_set_alpha(1);

            draw_set_color(make_color_rgb(100, 115, 160));
            draw_set_halign(fa_left);
            draw_text(_chart_x + _chart_w + 5, _gy - 7, string_format(_gp, 1, 2));
        }

        // ── Ligne d'entrée (prix de trade) en pointillés jaunes ─────────
        var _y_entry = _chart_y + _chart_h - (entry_price - _min_p) / _pr * _chart_h;
        draw_set_color(make_color_rgb(255, 220, 50));
        var _di = 0;
        while (_di < _chart_w) {
            if (floor(_di / 14) mod 2 == 0) {
                draw_line(_chart_x + _di, _y_entry, _chart_x + min(_di + 10, _chart_w), _y_entry);
            }
            _di += 14;
        }
        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(255, 220, 50));
        draw_text(_chart_x - 4, _y_entry - 7, string_format(entry_price, 1, 2));
        draw_set_halign(fa_left);

        // ── Bougies Candlestick ──────────────────────────────────────────
        var _total_slots = 20;
        var _slot_w = _chart_w / _total_slots;
        var _body_w = _slot_w * 0.55;

        for (var i = 0; i < _num; i++) {
            var _cd     = candles[i];
            var _cx_pos = _chart_x + i * _slot_w + _slot_w / 2;

            var _yo = _chart_y + _chart_h - (_cd.o - _min_p) / _pr * _chart_h;
            var _yc = _chart_y + _chart_h - (_cd.c - _min_p) / _pr * _chart_h;
            var _yh = _chart_y + _chart_h - (_cd.h - _min_p) / _pr * _chart_h;
            var _yl = _chart_y + _chart_h - (_cd.l - _min_p) / _pr * _chart_h;

            var _is_green  = (_cd.c >= _cd.o);
            var _body_col  = _is_green ? make_color_rgb(35, 195, 75) : make_color_rgb(205, 45, 45);
            var _wick_col  = _is_green ? make_color_rgb(25, 150, 55) : make_color_rgb(160, 25, 25);

            // Mèche (wick)
            draw_set_color(_wick_col);
            draw_line(_cx_pos, _yh, _cx_pos, _yl);

            // Corps de la bougie
            var _top_b = min(_yo, _yc);
            var _bot_b = max(_yo, _yc);
            if (_bot_b - _top_b < 2) { _bot_b = _top_b + 2; }

            draw_set_color(_body_col);
            draw_rectangle(_cx_pos - _body_w / 2, _top_b, _cx_pos + _body_w / 2, _bot_b, false);
            draw_set_color(_wick_col);
            draw_rectangle(_cx_pos - _body_w / 2, _top_b, _cx_pos + _body_w / 2, _bot_b, true);
        }
    }

    // ── Barre de progression (état 2) ────────────────────────────────────
    if (bourse_state == 2) {
        var _t     = clamp(trade_timer / trade_duration, 0, 1);
        var _bar_y = _chart_y + _chart_h + 18;
        draw_set_color(make_color_rgb(15, 20, 48));
        draw_rectangle(_chart_x, _bar_y, _chart_x + _chart_w, _bar_y + 15, false);
        draw_set_color(make_color_rgb(70, 170, 255));
        draw_rectangle(_chart_x, _bar_y, _chart_x + floor(_chart_w * _t), _bar_y + 15, false);
        draw_set_color(make_color_rgb(40, 60, 130));
        draw_rectangle(_chart_x, _bar_y, _chart_x + _chart_w, _bar_y + 15, true);
    }

    // ── Résultat (état 3) ────────────────────────────────────────────────
    if (bourse_state == 3) {
        var _won = (profit_val > 0);

        draw_set_alpha(0.72);
        draw_set_color(_won ? make_color_rgb(0, 45, 0) : make_color_rgb(55, 0, 0));
        draw_rectangle(_chart_x, _chart_y, _chart_x + _chart_w, _chart_y + _chart_h, false);
        draw_set_alpha(1);

        var _res_col = _won ? make_color_rgb(40, 255, 80) : make_color_rgb(255, 55, 55);
        var _mid_y   = _chart_y + _chart_h / 2;

        draw_set_halign(fa_center);
        scr_draw_text_outline(_cx, _mid_y - 55, result_msg, _res_col);
        scr_draw_text_outline(_cx, _mid_y + 20, "Capital : " + string(floor(global.money)) + " EUR", c_white);
        scr_draw_text_outline(_cx, _gh - 55, "ESPACE pour continuer", make_color_rgb(130, 140, 170));
        draw_set_halign(fa_left);
    }
}

// Reset
draw_set_color(c_white);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
