/// @description Tansition to Kick State
//  oKicker

// 0.1 Kicker: showcas to illustrate how to attach a hitbox only to specific zone and specific frames of a sprite.
if      ( state == "idle" )
{
	// Go to kick state
	state        = "kick";
	sprite_index = sKicker_Kick;
	image_index  = 0;
	hitbox_create(x, y, sKicker_HitBox).set_destroy_on_end(true).set_visible(false);
	
}


