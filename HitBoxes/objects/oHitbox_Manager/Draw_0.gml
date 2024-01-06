var _hitbox_list = struct_list;
var _len = ds_list_size(_hitbox_list);
var _i   = _len - 1;
repeat( _len )
{
	var _hb_i = _hitbox_list[| _i];
	with(_hb_i)
	{
		if ( _hb_i.__destroyed )
		{	
			_hb_i.clean(); // to clean data structures
			ds_list_delete(_hitbox_list, _i);
			--_i;
			continue;
		}
		draw();
		--_i;
	}  
}