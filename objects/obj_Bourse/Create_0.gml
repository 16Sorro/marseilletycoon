/// @description Initialise la bourse de Marseille Tycoon

bourse_open    = false;
interact_range = 180;
player_near    = false;

// State machine: 0=sélection action, 1=mise, 2=trading, 3=résultat
bourse_state = 0;
sel_stock    = 0;
sel_bet      = 0;

// ── Actions disponibles ───────────────────────────────────────────────────
stock_names    = ["RICARD",  "LDLC",  "PALANTIR", "TOTAL ENERGIE"];
stock_prices   = [24.50,     9.80,    78.40,       62.15];
stock_change24 = [-1.2,      3.4,    -0.8,          2.1];  // variation 24h affichée

// Mini sparklines pre-calculées (10 valeurs relatives en %)
stock_sparklines = [
    [0,  0.3, -0.2, -0.5, -0.8, -0.6, -1.0, -1.2, -1.1, -1.2],
    [0,  0.6,  1.2,  1.8,  2.1,  2.8,  3.0,  3.5,  3.3,  3.4],
    [0, -0.2,  0.4, -0.1, -0.4, -0.6, -0.7, -0.9, -0.8, -0.8],
    [0,  0.3,  0.8,  1.2,  1.6,  1.9,  2.2,  2.0,  2.1,  2.1]
];

// ── Mises disponibles ─────────────────────────────────────────────────────
bet_options = [1000, 5000, 10000, 50000];

// ── Trade actif ───────────────────────────────────────────────────────────
candles          = [];
entry_price      = 0;
final_price      = 0;
active_stock_idx = 0;
active_bet_amt   = 0;
trade_timer      = 0;
candles_shown    = 0;
trade_duration   = 10.0; // 10 secondes
trade_won        = false;
profit_val       = 0;
result_msg       = "";
