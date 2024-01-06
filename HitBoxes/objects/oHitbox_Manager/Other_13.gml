/// @description Regular step
var _hb_list = struct_list;
var _len = ds_list_size(_hb_list);
var _i   = _len - 1;
repeat( _len )
{
	var _hb_i = _hb_list[| _i];
	with(_hb_i)
	{
		if ( _hb_i.__destroyed )
		{
			_hb_i.clean(); // to clean data structures I am the only one to destroy to make sur I clean data structures
			ds_list_delete(_hb_list, _i);
			--_i;
			continue;
		}
		else
		{
			step();
		}
		--_i;
	}
}