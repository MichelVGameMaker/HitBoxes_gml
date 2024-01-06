function sprite_data(_asset, _frame = 0, _xscale, _yscale, _angle, _visible = true) constructor {
	if ( instanceof(other) = "instance" )
	{
		if _asset  == undefined _asset  = other.sprite_index;
		if _xscale == undefined _xscale = other.image_xscale;
		if _yscale == undefined _yscale = other.image_yscale;
		if _angle  == undefined _angle  = other.image_angle;
	}
	else
	{
		if _asset  == undefined _asset  = undefined;
		if _xscale == undefined _xscale = 1;
		if _yscale == undefined _yscale = 1;
		if _angle  == undefined _angle  = 0;
	}
	// Simple variables
	sprite_index = _asset;
	image_index  = _frame;
	image_xscale = _xscale;
	image_yscale = _yscale;
	image_angle  = _angle;
	image_speed  = 1;
	image_alpha  = 1;
	image_blend  = c_white;
	visible      = _visible;
	// frame to image_index mechanic
	/*__frame      = _frame;					// current frame - an image_index can have multiple frames if using stretched frame
	image_ref    = [];
	var _data = sprite_get_info(_asset);

	var _array = _data.frame_info;
	if _array != undefined
	{
		var _len = sprite_get_number(_asset), _i = 0;
		repeat (_len)
		{
			repeat _array[_i].duration { array_push(_array, _i); }
			++_i;
		}
	}
	*/
	#region Private Methods
	/// @desc  increment image_index based on image_speed and speed type, can be instructed to cycle to a specified start_frame after a specified end_frame
	static __increment_image_index = function(_cycle = true, _end_frame = sprite_get_number(sprite_index) - 1, _start_frame = 0) {
		var _sprite = sprite_index;
		var _speed  = (sprite_get_speed_type(_sprite) == spritespeed_framespergameframe) ? sprite_get_speed(_sprite) * image_speed : sprite_get_speed(_sprite) * image_speed / game_get_speed(gamespeed_fps);
		image_index += _speed;
		if ( image_index > _end_frame + 1)
		{
			if ( _cycle ) { image_index -= _end_frame + 1 - _start_frame;  }
			else          { image_index  = _end_frame + 1 - 0.5 * _speed;  }
		}
		else if ( image_index == _end_frame + 1) // I tried wihout it and it did not work... floating thing I think
		{
			if ( _cycle ) { image_index = _start_frame;  }
			else          { image_index = _end_frame + 1 - 0.5 * _speed;  }
		}
	}
	#endregion
	
	#region Public Methods
	///@function will_end()
	/// @description	return true if animation will end on its next __increment_image_index() call - usually ran in end_step event so you can test will_end in step event
	static will_end = function() {
		var _sprite = sprite_index;
		var _speed  = (sprite_get_speed_type(_sprite) == spritespeed_framespergameframe) ? sprite_get_speed(_sprite) * image_speed : sprite_get_speed(_sprite) * image_speed / game_get_speed(gamespeed_fps);
		return ((image_index + _speed) >= sprite_get_number(_sprite));
	}
	///@function draw(x, y, xscale, yscale, angle, blend, alpha)
	/// @description	draw the animation's sprite at x, y coordinates
	static draw = function(_x, _y, _image_xscale = image_xscale, _image_yscale = image_yscale, _image_angle = image_angle, _image_blend = image_blend, _image_alpha = image_alpha) {
		if !visible exit;
		draw_sprite_ext(sprite_index, image_index, _x, _y, _image_xscale, _image_yscale, _image_angle, _image_blend, _image_alpha);
	}
	#endregion
	
	#region Getters and Setters
	static get_sprite_index = function()         {
		return sprite_index;
	}
	static get_image_index  = function()         {
		return image_index;
	}
	static get_image_xscale = function()         {
		return image_xscale;
	}
	static get_image_yscale = function()         {
		return image_yscale;
	}
	static get_image_angle  = function()         {
		return image_angle;
	}
	static get_image_speed  = function()         {
		return image_speed;
	}
	static get_image_alpha  = function()         {
		return image_alpha;
	}
	static get_image_blend  = function()         {
		return image_blend;
	}
	static get_visible      = function()         {
		return visible;
	}
	static set_sprite_index = function(_asset)   {
		sprite_index = _asset;
	}
	static set_image_index  = function(_frame)   {
		image_index  = _frame;
	}
	static set_image_xscale = function(_xscale)  {
		image_xscale = _xscale;
	}
	static set_image_yscale = function(_yscale)  {
		image_yscale = _yscale;
	}
	static set_image_angle  = function(_angle)   {
		image_angle  = _angle;
	}
	static set_image_speed  = function(_speed)   {
		image_speed  = 1;
	}
	static set_image_alpha  = function(_alpha)   {
		image_alpha  = 1;
	}
	static set_image_blend  = function(_blend)   {
		image_blend  = c_white;
	}
	static set_visible      = function(_visible) {
		visible      = _visible;
	}
	#endregion
}