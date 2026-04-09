/// @description NPC Passant — patrouille gauche/droite en boucle

spd          = 2;     // Vitesse de déplacement
patrol_range = 100;   // Distance max de chaque côté (modifiable par instance)
start_x      = x;     // Position de départ mémorisée
direction_x  = 1;     // 1 = droite | -1 = gauche
