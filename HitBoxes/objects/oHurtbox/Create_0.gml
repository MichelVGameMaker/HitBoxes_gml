/// @description Declare Variables & Methods
//  oHurtbox

hurt                   = function(_damages, _from, _props, _hurt_func)  {
	if !owner_exists() instance_destroy();             // Auto-clean orphan hurt boxes.
	__owner.hurt(_damages, _from, _props, _hurt_func);
}

// Hurt Boxes are attached to an 'owning' instance. They serves a specific collision masks for the HitLib 'engine'. 
// Hurt Boxes just pass the hurt 'signal', they receive when hurt by a Hit Box, to their owning instance.
//
// Hurt Boxes are attached to the owning instance as follow:
// By default, Hurt Boxes both follow and mimic shapes attributes (angle and scales attributes) from the owning instance every step. This can be disabled selectively with mimic_xx_enable and follow_xx_enable methods.
//  mimic_  methods dictate what the Hurt Box looks like: namely if the Hurt Box scales and rotates with its owning instances. This does not affect the origin of the Hurt Box.
//  follow_ methods dictate where the Hurt Box is positioned: namely if the origin rotates around its owning instances and adjust to its owning instances' scales. This does not affect the shape of the Hurt Box.
// Please note that when mimicing, the Hurt Box does it relatively to its creation state: If the Hurt Box was created with a scale of 2, when its owning instance scale by two, the Hurt Box scale is set to 4 (even if the owning intance changed from 1 to 2).
// Please note that when following, the Hurt Box does it relatively to its creation state: If the Hurt Box was created north/up/90° to the owning instance, when its owning instance rotate by 90, the Hurt Box goes to west/left/180° to the owning instance.
// This state is defined upon the Hurt Box creation but is updated when using position_set, angle_set, xscale_set, yscale_set methods. This update can be prevented by passing false as an argument.

#region methods			------------------------------------------------------------------------
// @description saves the relative position, angle and scales of the Hurt Box compared to its owning instance. This allows to 'attach' the box to the instance and allows following and mimicing as explained abovze.
__update_offset        = function()                                     {
	if !instance_exists(__owner) 
	{
		shw_e("[HurtBox]", "Hurtbox is associated to an owner that is not an existing instance.");
		return false;	
	}
	var _instance   = __owner;
	if variable_instance_exists(_instance, "sprite")
	{
		var _owner_angle  = _instance.sprite.image_angle;
		var _owner_xscale = _instance.sprite.image_xscale;
		var _owner_yscale = _instance.sprite.image_yscale;
	}
	else
	{
		var _owner_angle  = _instance.image_angle;
		var _owner_xscale = _instance.image_xscale;
		var _owner_yscale = _instance.image_yscale;
	}
	var _d_x  = (x - _instance.x) / abs(_owner_xscale);
	var _d_y  = (y - _instance.y) / abs(_owner_yscale);
	var _dist = point_distance( 0, 0, _d_x, _d_y);
	var _a    = point_direction(0, 0, _d_x, _d_y);
	var _d_angle  = degtorad(_a - _owner_angle);
	var _sin = sin(_d_angle);
	var _cos = cos(_d_angle);
	__offset_x             = (_cos   * _dist) * sign(_owner_xscale);
	__offset_y             = (- _sin * _dist) * sign(_owner_yscale);
	__offset_image_angle   = image_angle - _owner_angle;
	__offset_image_xscale  = image_xscale / _owner_xscale;
	__offset_image_yscale  = image_yscale / _owner_yscale; 
	__start_image_xscale   = _owner_xscale;
	__start_image_yscale   = _owner_yscale; 
}
// @description intended to be run every step. Adjusts shape and position to mimic and follow the owning instace every step.
__step_mimic_follow    = function()                                     {
	var _id = __owner;
	if variable_instance_exists(_id, "sprite")
	{
		var _owner_angle  = _id.sprite.image_angle;
		var _owner_xscale = _id.sprite.image_xscale;
		var _owner_yscale = _id.sprite.image_yscale;
		}
	else
	{
		var _owner_angle  = _id.image_angle;
		var _owner_xscale = _id.image_xscale;
		var _owner_yscale = _id.image_yscale;
	}
	// Mimic Shape
	if ( __mimic_angle   ) image_angle  = _owner_angle  + __offset_image_angle;
	if ( __mimic_xscale  ) image_xscale = _owner_xscale / __start_image_xscale;
	if ( __mimic_yscale  ) image_yscale = _owner_yscale / __start_image_yscale;
	// Mimic Position
	if ( !__follow_xy    ) exit;
	if ( __follow_xscale )
	{
		var _dx     = __offset_x * _owner_xscale;
	}
	else
	{
		var _dx     = __offset_x * __start_image_xscale;
	}	
	if ( __follow_yscale   )
	{
		var _dy     = __offset_y * _owner_yscale;
	}
	else
	{
		var _dy     = __offset_y * __start_image_yscale;
	}		
	if ( __follow_angle   )
	{
		var _angle  = degtorad(_owner_angle);
		var _sin    = sin(_angle);
		var _cos    = cos(_angle);
		x = _id.x + _cos * _dx + _sin * _dy;
		y = _id.y + _cos * _dy - _sin * _dx;
	}
	else
	{
		x = _id.x +  _dx;
		y = _id.y +  _dy;
	}
}
// @description owner setter & getters
owner_exists           = function()                                     {
	return instance_exists(__owner);
}
owner_get	           = function()                                     {
	return __owner;
}
owner_set              = function(_instance, _do_offset = true)         {
	if !instance_exists(_instance) 
	{
		shw_e("[HurtBox]", "Hurtbox is associated to an owner that is not an existing instance.");
		return self;	
	}
	else if !variable_instance_exists(_instance, "hurt")	
	{
		shw_w("[HurtBox]", "Hurtbox is associated to an instance that does not have an associated hurt method. A default is defined.");
		with(_instance)
		{
			hurt = function(_damages, _owner, _props, ___hurt_func) {
				// default hurt behavior goes here
			}
		}
	}
	else if !is_method(_instance.hurt)	
	{
		shw_e("[HurtBox]", "Hurtbox is associated to an instance that has a hurt variable, but it is not a method.");
		return self;
	}
	__owner           = _instance;	
	if _do_offset 
	{
		__update_offset();
	}
	return self;
}
// @description mask setter. Current scales, angles and positions are kept.
mask_set               = function(_sprite)                              {
	sprite_index = _sprite;
	mask_index   = _sprite;	
	return       self;
}
// @description shapes setters (angle and scales), that will refresh the attachment position.
angle_set              = function(_angle)                               {
	image_angle = _sprite;
	if _do_offset 
	{
		__update_offset();
	}
	return       self;
}
xscale_set             = function(_scale)                               {
	image_xscale = _scale;
	if _do_offset 
	{
		__update_offset();
	}
	return       self;
}
yscale_set             = function(_scale)                               {
	image_yscale = _scale;
	if _do_offset 
	{
		__update_offset();
	}
	return       self;
}
// @description position setter, that will refresh the attachment position.
position_set           = function(_x = x, _y = y, _do_offset = true)    {
	x           = _x;
	y           = _y;
	xprevious   = _x;
	yprevious   = _y;
	if _do_offset 
	{
		__update_offset();
	}
	return       self;
}
// @description user can define attachment manually. Parameters should be passed in the owner's referential = considering owner has a default angle and scales (angle = 0, scales = 1) = how the owner'sprite appears in the Sprite editor.
attachment_set         = function(_x = 0, _y = 0)                       {
	__offset_x           = _x
	__offset_y           = _y;
	return       self;
}
shape_set              = function(_xscalefac = 0, _yscalefac = 0, _angle = 0) {
	__offset_image_xscale= _xscale
	__offset_image_yscale= _yscale;
	__offset_image_angle = _angle
	return       self;
}
// @description setters for mimicing and following owner 
mimic_angle_enable     = function(_mimic)                               {
	__mimic_angle  = _mimic;
	return       self;
}
mimic_xscale_enable    = function(_mimic)                               {
	__mimic_xscale = _mimic;
	return       self;
}
mimic_yscale_enable    = function(_mimic)                               {
	__mimic_yscale = _mimic;
	return       self;
}
follow_xy_enable       = function(_follow)                              {
	__follow_xy    = _follow;
	return       self;
}
follow_angle_enable    = function(_follow)                              {
	__follow_angle = _follow;
	return       self;
}
follow_xscale_enable   = function(_follow)                              {
	__follow_xscale= _follow;
	return       self;
}
follow_yscale_enable   = function(_follow)                              {
	__follow_yscale= _follow;
	return       self;
}
#endregion

#region variables		------------------------------------------------------------------------
__owner               = noone;                                             // intance_id	point the instance owning this Hurt Box.
__mimic_angle         = true;                                              // boolean		if true, angle changes applied to the owning instance are also applied to the Hurt Box (every begin step).
__mimic_xscale        = true;                                              // boolean		if true, xscale changes applied to the owning instance are also applied to the Hurt Box (every begin step).
__mimic_yscale        = true;                                              // boolean		if true, yscale changes applied to the owning instance are also applied to the Hurt Box (every begin step).
__follow_xy           = true;                                              // boolean		if true, Hurt Box will follow owning instance's coordinates, every step. This allow to 'attach' the box to the instance and to follow movement
__follow_angle        = true;                                              // boolean		if true, Hurt Box position rotates with owner's image_angle while following. Does nothing if follow_xy is false.
__follow_xscale       = true;                                              // boolean		if true, Hurt Box position adjust to owner's image_xscale while following. Does nothing if follow_xy is false.
__follow_yscale       = true;                                              // boolean		if true, Hurt Box position adjust to owner's image_yscale while following. Does nothing if follow_xy is false.
__offset_x            = 0;                                                 // real		x coordinate of the Hurt Box in the owning instance's coordinates referential (when owner has an image_angle of zero and image_xscale &  image_xscale of one).
__offset_y            = 0;                                                 // real		y coordinate of the Hurt Box in the owning instance's coordinates referential (when owner has an image_angle of zero and image_xscale &  image_xscale of one).
__offset_image_angle  = 0;                                                 // real		angle variation of the Hurt Box compared to the owning instance. (when owner has an image_angle of zero and image_xscale &  image_xscale of one).
__offset_image_xscale = 1;                                                 // real		scale factor of the Hurt Box compared to the owning instance. (when owner has an image_angle of zero and image_xscale &  image_xscale of one).
__offset_image_yscale = 1;                                                 // real		scale factor of the Hurt Box compared to the owning instance. (when owner has an image_angle of zero and image_xscale &  image_xscale of one).
__start_image_xscale  = 1;                                                 // real		default scale factor of the owning instance. I got lazy to fix a bug with mimic scale.
__start_image_yscale  = 1;                                                 // real		default scale factor of the owning instance. I got lazy to fix a bug with mimic scale.
#endregion