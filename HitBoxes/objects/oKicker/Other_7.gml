/// @description Transition to Idle State
//  oKicker

 if ( state == "kick" )
{
	// Go to idle state
	state        = "idle";
	sprite_index = sKicker_Idle;
	alarm[0]     = 60;
}