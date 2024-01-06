function listencode(_list){
	var _len   = ds_list_size(_list);
	var _i     = 0;
	var _str   = ""
	repeat( _len )
	{
		_str = _str + ", " + string(_list[| _i]);
		_i++;
	}
	return _str
}