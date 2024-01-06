/// @description Cast an attack

// I have tried to demonstrate most of the features creating hitboxes from an instance of an Object I called ‘oSlasher’:
alarm[0] = 150;

switch(room)
{
	default:
	case rBasics:
	// 1.1 Basics: a hitbox with default values. You can appreciate a ‘Target’ is only hurted once per hitbox even if the hitbox last many steps, which is the most useful configuration.
		var _hitbox = hitbox_create(x, y, sHitMask_Big);
		_hitbox.set_destroy_on_timer(120);
		break;
	case rResetRehurt:
	// 1.2.Reset Rehurt: a hitbox with default values that is reset manually. It is useful for threats that reload like traps.
		// nothing this is managed by another object oSlasher_Trap
		break;		
	case rTimingRehurt:
	// 1.3.Timing Rehurt: a hitbox that can hurt Target several times, if 30 steps elapsed . It is useful for threats like lazer or fall zones.
		hitbox_create(x, y, sHitMask_Lazer).set_destroy_on_timer(120).set_rehurt_timing(30).set_mono_hurt(false);
		break;	
	case rCollider:
	// 2.1.Collider a hitbox with default values. A collider is sitting between the ‘Slasher’ and the ‘Target’ showcasing the collider feature.
		var _hitbox = hitbox_create(x, y, sHitMask_Big).set_destroy_on_timer(120);
		break;	
	case rMovementScale:
	// 3.1.Scale: a hitbox with default values created 8 pixels in front of the ‘Slasher’. Fliping the ‘Slasher’s you can appreciate the hitbox follows. 
	//         This is useful for a melee attack and if the hitbox lasts more than one frame and you want to give input tolerance to change attack orientation or the casting instance is moving quickly.
		hitbox_create(x,  y + 4 * image_yscale, sHitMask_Small, true).set_destroy_on_timer(120);
		call_later(40, time_source_units_frames, function() {image_xscale *= -1; });
		call_later(80, time_source_units_frames, function() {image_yscale *= -1; });
		break;	
	case rMovementRotate:
	// 3.2.Rotate: a hitbox with default values created 8 pixels in front of the ‘Slasher’. Changing ‘Slasher’s orientation you can appreciate the hitbox follows. 
	//         This is useful for a melee attack and if the hitbox lasts more than one frame and you want to give input tolerance to change attack orientation or the casting instance is moving quickly.
		hitbox_create(x + lengthdir_x(8, image_angle), y + lengthdir_y(8, image_angle), sHitMask_Small, id, true).set_destroy_on_timer(120).set_image_angle(image_angle);
		call_later(10, time_source_units_frames, function() {image_angle  += 10; });
		call_later(20, time_source_units_frames, function() {image_angle  += 10; });
		call_later(30, time_source_units_frames, function() {image_angle  += 10; });
		break;	
	case rMovementMovement:
	// 3.3.Movement: a hitbox with default values created 8 pixels in front of the ‘Slasher’. Moving the ‘Slasher’ you can appreciate the hitbox follows. 
	//         This is useful for a melee attack and if the hitbox lasts more than one frame and you want to give input tolerance to change attack orientation or the casting instance is moving quickly.
		hitbox_create(x + 8 * image_xscale, y, sHitMask_Small, id).set_destroy_on_timer(120);
		hspeed = image_xscale;
		call_later(120, time_source_units_frames, function() {image_xscale *= -1; hspeed=0; });
		break;	
	case rMovementMovementHigh:
	// 3.3.Movement: a hitbox with default values created 8 pixels in front of the ‘Slasher’. Moving the ‘Slasher’s quickly you can appreciate the hitbox follows. 
	//         This is useful for a melee attack and if the hitbox lasts more than one frame and you want to give input tolerance to change attack orientation or the casting instance is moving quickly.
		hitbox_create(x + 8 * image_xscale, y, sHitMask_Small, id).set_destroy_on_timer(120);
		hspeed = 24 * image_xscale;
		call_later(120, time_source_units_frames, function() {image_xscale *= -1; hspeed=0; });
		break;	
	case rMovementNoFollowScale:
	// 3.4.Follow: a hitbox with 'follow' attribute set to false. Fliping the ‘Slasher’s you can appreciate the hitbox does not follow. 
		hitbox_create(x,  y, sHitMask_Small, id, true).set_destroy_on_timer(120).set_follow_angle(false);
		call_later(40, time_source_units_frames, function() {image_xscale *= -1; });
		break;	
	case rMovementNoFollowPos:
	// 3.4.Follow: a hitbox with 'follow' attribute set to false. Fliping the ‘Slasher’s you can appreciate the hitbox does not follow. 
		hitbox_create(x,  y + 4 * image_yscale, sHitMask_Bullet).set_destroy_on_timer(260).set_follow_angle(false).set_follow_position(false).set_speed_x(image_xscale * 3);
		hspeed = image_xscale;
		call_later(120, time_source_units_frames, function() {image_xscale *= -1; hspeed=0; });
		break;	
}