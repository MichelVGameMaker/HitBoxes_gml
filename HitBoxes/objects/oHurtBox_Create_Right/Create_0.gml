// Hurt method
hurt_count = 0;
timer = 0;
hurt             = function(_damages, _from, _type, ___hurt_func) {
	hurt_count++
	show_debug_message("Hurt #" + string(hurt_count) + ". For " + string(id) + " of " + object_get_name(object_index) + " hurt by " + string(_from.id) + " of " + object_get_name(_from.object_index) + "."); 
}

// Acquire Hurtable behavior through a Hurt Box (and not parenting)
my_hurt_box = hurtbox_create(sBig_Mask, x + abs(sprite_width) * 0.35, y - abs(sprite_height) * 0.35)
