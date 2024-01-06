var _hitbox_list = struct_list;
var _len = ds_list_size(_hitbox_list);
var _i   = _len - 1;
repeat( _len )
{
	var _hb_i = _hitbox_list[| _i];
	_hb_i.destroy();
	_hb_i.clean(); // to clean data structures
	--_i;
}
ds_list_destroy(struct_list);