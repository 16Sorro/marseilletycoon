/// @description Notification — monte et s'efface

lifetime--;
y        -= 0.6;                     // Monte doucement
alpha_val = lifetime / 120;          // Fondu progressif

if (lifetime <= 0) {
    instance_destroy();
}
