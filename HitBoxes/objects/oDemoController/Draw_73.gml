draw_text(3, 3, "Room:"+ room_get_name(room));
draw_text(3, 20, "F1/F2 - Prev/Next Room");
var _to = debug_mask ? "off" : "on";
draw_text(3, 37, "F8 - Turn Debug "+ _to);

if debug_mask
{
	with(oHitbox_Manager)
	{
		var _hitbox_list = struct_list;
		var _len = ds_list_size(_hitbox_list);
		var _i   = _len - 1;
		repeat( _len )
		{
			var _hb_i = _hitbox_list[| _i];
			with(_hb_i)
			{
				if !( _hb_i.__destroyed )
				{	
					draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_red, 0.5);	
				}
				--_i;
			}  
		}
	}
	with(oHurtbox)
	{
		draw_sprite_ext(sprite_index, 0, x, y, image_xscale, image_yscale, image_angle, c_green, 0.5);	
	}	
}