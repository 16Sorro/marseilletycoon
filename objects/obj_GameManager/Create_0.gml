/// @description Initialise les globales du jeu Marseille Tycoon

// === PARAMETRES GRAPHIQUES ===
display_reset(8, true); // Active l'Anti-Aliasing (MSAA x8) et le V-Sync
gpu_set_texfilter(true); // Active le filtrage des textures pour lisser les sprites agrandis ou rÈduits

// === ARGENT ===
global.money          = 0;
global.income_per_sec = 0;
global.income_timer   = 0; // compte en secondes (via delta_time)

// === DONNÉES DES BUSINESSES ===
// Index : 0=Clope | 1=Glacier | 2=Supérette | 3=CBD | 4=Voitures | 5=Festival

global.biz_name[0]   = "Vente Clope";
global.biz_name[1]   = "Glacier";
global.biz_name[2]   = "Supérette";
global.biz_name[3]   = "Coffee Shop CBD";
global.biz_name[4]   = "Location Voitures";
global.biz_name[5]   = "Festival Musique";

global.biz_price[0]  = 0;
global.biz_price[1]  = 1000;
global.biz_price[2]  = 5000;
global.biz_price[3]  = 15000;
global.biz_price[4]  = 25000;
global.biz_price[5]  = 50000;

global.biz_income[0] = 10;
global.biz_income[1] = 50;
global.biz_income[2] = 100;
global.biz_income[3] = 250;
global.biz_income[4] = 350;
global.biz_income[5] = 450;

global.biz_owned[0]  = false;
global.biz_owned[1]  = false;
global.biz_owned[2]  = false;
global.biz_owned[3]  = false;
global.biz_owned[4]  = false;
global.biz_owned[5]  = false;

// La clope est gratuite → auto-débloquée
global.biz_owned[0]  = true;
global.income_per_sec += global.biz_income[0];

global.biz_dialogue[0] = "Cigarette ? 5 balles\nle paco le sang !";
global.biz_dialogue[1] = "Glace artisanale\ndu Vieux-Port !";
global.biz_dialogue[2] = "On a de tout,\n rend pas fou !";
global.biz_dialogue[3] = "CBD de qualite,\nen detente garantie !";
global.biz_dialogue[4] = "Belle caisse pour\nun beau prix !";
global.biz_dialogue[5] = "C'est Marseille bebe !";
