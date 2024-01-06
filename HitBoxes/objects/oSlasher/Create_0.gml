// Hurt method
hurt_count = 0;
hurt             = function(_damages, _from, _type, ___hurt_func) {
	hurt_count++
	show_debug_message("Hurt #" + string(hurt_count) + ". For " + string(id) + " of " + object_get_name(object_index) + " hurt by " + string(_from.id) + " of " + object_get_name(_from.object_index) + "."); 
}
// Cast an attack
alarm[0] = 30;