#region Readme
/*
INTRODUCTION
HitLib is a library I have built over 2 projects to process hiting/hurting enemies or other entities called 'hurtable'. The library comes with many options and is quite ok... I think.

FEATURES:
- add Hurtable behavior by parenting or attach Hurt Boxes to instances. 
- adjust how Hurt Bowes follow / mimic their 'owning' instances.
- create Hit Boxes with hitbox_create() function.
- adjust how Hit Bowes follow / mimic their 'owninh' instance.
- add speed to Hit Boxes, manage high speed movement collision. 
- cancel Hit Boxes on collision with walls.
- customize parameters (damages, attack types, callback function...) to fit your game features.

BEHIND THE HOOD:
Hitlib relies on hitboxes, virtual sprite-shaped entities that deal damages upon collision with hurtable instances.
Hitboxes are struct entities. They are managed by 'controller' objects called Hitbox_manager. 
Note that the same result could be achieved with independant objects.
Hitbox_manager objects are mainly there for processing collision and drawing the associated sprites (thus, there is one Hitbox_manager per layer, no matter the number of Hitboxes). If you make your Hit Boxes invisible, you should create all of them at the same depth.

HOW TO USE:
Just create hitboxes with hitbox_create() and then they are processed automatically. 
For example, hitbox_create(x, y, sprite_slash) will create an hitbox that follows the calling instance (useful for a slash).

Parameters when defining a hitbox:
- x					   no default               x coordinate.
- y					   no default               y coordinate.
- sprite_index		   no default               sprite - mask is used to detect collision.
- owner				   calling instance         owning instance.
- follow			   true                     if true, the Hit Box will follow owning instance position, angle and scales.
- damages			   no default               x coordinate
- can_hit_obj          _HITBOX_DEFAULT_HURTABLE objects that can be hit (objects and all their children because we use parenting).
- properties		   {}                       struct of custom data you want to pass.
- hurt_func			   undefined                custom hurt function
- hit_func			   undefined                custom hit function, if you want to separate instructions.
- timer				   -1                       destroy alarm.
- destroy_on_end	   false                    if true, Hit Box destroy on animation end.
- visible              true                     if false, Hit Box is invisible.
- o_manager            no default               you can specify your own controller if you do not want to use the native one.

You also can set some key parameters 
- Collider: If the line from the owner origin of the hitbox and the origin of the entity go through a collider, the entity is not hurt.
- You can pass the x-y coordinates, sprite_index, owning instance
- The sprite is used to detect collision, so angle and scales are important.
- The hitbox will follow the owner intance (x, y, but also scales and angles). Following can be disabled in the hitbox_create() arguments.
    Please note, that the relative position of the hitbox to the owner is kept while following 
    (upon creation the hitbox stores how it should be offset compared to the owner's origin for the hitbox to be at x,y defined in hitbox_create() arguments.) 
- It is important to know that when following its owner, the hitbox will turn (angle) and scale (xscale, yscale) with its owner.sprite at every step. 
- The struct also has image_angle, image_speed, image_alpha, image_blend variables that are managed through setters.
- Hitboxes hurt entities over their movements with a precision step of 8 pixels, you can adjust that if needed with the coll_accuracy variable.
- You will likely want to customize what happen when hurting an instance. You can do that in the hitbox library if the hurt behavior is the same for all your weapon (reducing hp).
    You can also add hitbox specific features through call back defined in hitbox_create() argument.

- Destruction can be triggered on animation_end (if set to true) or after a timer (if timer is > 0) (I would advise to choose between the two and not let hitbox indefinitively alive).
Please note it is the hitbox that hurts the entity when moving. It is ok to have quickly moving hitboxes. But it is not designed to cover quickly moving target entities going through the Hit Box
If an entity is moving quickly enough to go through the hitbox (such as it is not colliding before movement and not colliding after movement) it will not trigger.
*/
#endregion

///    ------------------------------------------------------------------------------------------------------------------------------------------
///        HitLib Options
///    ------------------------------------------------------------------------------------------------------------------------------------------
#macro __HITLIB_DEFAULT_COLLIDER  oColliderTest
#macro __HITBOX_DEFAULT_HURTABLE  [oTarget_Par, oHurtbox]
#macro __HITBOX_FRIENDLY          undefined
#macro __HITBOX_CONTROLLER_OBJECT oHitbox_Manager 

///    ------------------------------------------------------------------------------------------------------------------------------------------
///        Creating Hurt Boxes
///    ------------------------------------------------------------------------------------------------------------------------------------------
function hurtbox_create(_sprite_index = mask_index, _x = x, _y = y, _id = id)  {
	var _new_hurtbox = instance_create_depth(_x, _y, depth, oHurtbox)
	_new_hurtbox.owner_set(_id);
 	_new_hurtbox.mask_set(_sprite_index);
	return _new_hurtbox;
}

///    ------------------------------------------------------------------------------------------------------------------------------------------
///        Creating Hit Boxes
///    ------------------------------------------------------------------------------------------------------------------------------------------
function hitbox_create(_x, _y, _sprite_index, _owner = id, _follow = true, _damages = 1, _can_hit_obj = __HITBOX_DEFAULT_HURTABLE, _properties = {}, _hurt_func = undefined, _hit_func = undefined,  _timer = -1, _destroy_on_end = false, _visible = true, _o_manager = noone)  {
/// @description contruct a struc as described by args, then
/// if no manager is defined in argument, the function will retrieve/create a ohitbox_manager object, and register the struct id to this ohitbox_manager's list so that it can process step & draw 'events'
/// if a manager is defined in argument, the function will just create the struct, the manager will need to take care of calling step / draw / destroy functions
    if !is_array(_can_hit_obj) _can_hit_obj = [_can_hit_obj];
    if ( _o_manager == noone )
    {
        _o_manager = instance_nearest(0, 0, __HITBOX_CONTROLLER_OBJECT);
        if ( _o_manager = noone ) { _o_manager = instance_create_depth(0, 0, 0, __HITBOX_CONTROLLER_OBJECT); }
        var _new_hitbox = new __hitbox_struct(_x, _y, _sprite_index, _owner, _follow, _damages, _properties, _hurt_func, _hit_func, _can_hit_obj, _timer, _destroy_on_end, _visible, _o_manager);
        ds_list_add(_o_manager.struct_list, _new_hitbox);
    }
    else
    {
        var _new_hitbox = new __hitbox_struct(_x, _y, _sprite_index, _owner, _follow, _damages,  _properties, _hurt_func, _hit_func, _can_hit_obj, _timer, _destroy_on_end, _visible, _o_manager);
    }
    return _new_hitbox;
}

///    ------------------------------------------------------------------------------------------------------------------------------------------
///        Hit Box Struct
///    ------------------------------------------------------------------------------------------------------------------------------------------
function __hitbox_struct(_x, _y, _sprite_index, _owner = id, _follow = true, _damages = 1,  _properties = {}, _hurt_func = undefined, _hit_func = undefined, _can_hit_obj = __HITBOX_DEFAULT_HURTABLE, _timer = -1, _destroy_on_end = false,  _visible = true, _manager = undefined) 
: sprite_data(_sprite_index, 0, 1, 1, undefined, _visible)  constructor {
    /// @description constructor for struct

	#region Initialization
	// system variables
	__manager       = _manager;                     // internal id to access the managing instance.
	__destroyed     = false;                        // internal boolean used to trigger destruction.
	__active        = true;                         // allow to de-activate (invisible and frozen).
	paused          = false;                        // allow to pause animation and collision/step event.
	hurting         = true;                         // allow the damages to be dealt (with false, you can keep the hitbox active for visual purposed but prevent it to hurt entities).
	// hurted variables                             
	__life_timer    = 0;                            // integer counting steps of life for this struct.
	mono_hurt       = true;                         // internal boolean - true means an instance can only be hurt once by this hitbox. It does the same as a rehurt_timing set to infinity.
	rehurt_timing   = 30;                           // parameter how much tme for an instance to be hurt again.
	hurted_id_list  = ds_list_create();             // internal list of already hurted instances.
	hurted_time_list= ds_list_create();             // internal list of already timing for already hurted instances (timer since last hurt).
	temp_hit_list   = ds_list_create();             // internal list of hit instances that are hit this step, this is temporary and reset every step.
	// collision variables                         
	coll_accuracy   = 8;                            // the finest x-y step that is checked when looking for colliding instance.
	collider        = __HITLIB_DEFAULT_COLLIDER;    // collider that blocks the hitbox and prevent hurting instances that are on the other side.
	// lifespan variables
	destroy_on_timer= _timer;                       // life destroy_on_timer. hitbox will be destroyed when destroy_on_timer become negative. Ignored if set to zero.
	destroy_on_end  = _destroy_on_end;              // is the hitbox destroy when animation ends.
	destroy_on_hit  = false;                        // is the hitbox destroyed on collision (with target or solid).
	// position variables                         
	x               = _x;                           // current x position.
	y               = _y;                           // current y position.
	xprevious       = _x;                           // previous x position - set at the end of the hitbox step function.
	yprevious       = _y;                           // previous y position - set at the end of the hitbox step function.
	// speed variables                             
	x_vel           = 0;                            // ignored if follow is true.
	y_vel           = 0;                            // ignored if follow is true.
	// owner variables                             
	follow_angle    = _follow;                      // if the hitbox is following its owner scale and angle.
	follow_position = _follow;                      // if the hitbox is following its owner    coordinates.
	x_offset        = 0;        // delete           // delta between hitbox x and its owner's x, the offset is be kept when the hitbox follows the owner. 
	y_offset        = 0;        // delete           // delta between hitbox y and its owner's x, the offset is be kept when the hitbox follows the owner.
	__offset_length = 0;                            // distance between hitbox's origin and its owner's origin, when owner has an image_angle of zero and image_xscale &  image_xscale of one. 
	__offset_angle  = 0;                            // angle between hitbox's origin and its owner's origin, when owner has an image_angle of zero and image_xscale &  image_xscale of one. 
	set_owner(_owner, true);                        // instance that created the hitbox. by default hitbox will follow this instance. in case there is an owner the relative position to the owner is kept for following behavior.
	if _follow 
	{
		set_image_xscale(_owner.image_xscale)
		set_image_yscale(_owner.image_yscale);
	}
	// hit variables
	damages         = _damages;                     // how much damages is dealt.
	__properties    = _properties					// various hit properties.
	__hurt_func     = _hurt_func;                   // function to trigger special effect when hurting / dealing damages.
	__hit_func      = _hit_func;                    // function to trigger special effect when hitting.
	__collide_func  = undefined;                    // function to trigger special effect when colliding.
    if !is_array(_can_hit_obj)
	{
		__can_hit_obj = [_can_hit_obj]; // does the hitbox deals damage to the monsters / enemies / NPC / items
	}
	else 
	{
		__can_hit_obj = _can_hit_obj;
	}

	#endregion
	
	#region Private Methods
	/*static set_offset_origin = function(_x, _y)
	{
	    // get the offset between the sprite_index and the owner
	    xoff   = _x - __owner.x;
	    yoff   = _y - __owner.y;
		return self;
	}*/
	static hitbox_place_list = function(_x, _y, _object, _list) {
	    with (__manager)
	    {
	        sprite_index = other.sprite_index;
	        image_index  = other.image_index;
	        image_xscale = other.image_xscale;
	        image_yscale = other.image_yscale;
	        image_angle  = other.image_angle;
	        instance_place_list(_x, _y, _object, _list, false);
	    }
	}
	static hitbox_move_list = function(_x1 = x, _y1 = y, _x2 = x, _y2 =y, _list) {
	    var _step = ceil(max(abs(_x2-_x1), abs(_y2-_y1)) / coll_accuracy);
	    var _xgap = (_x2-_x1) / _step;
	    var _ygap = (_y2-_y1) / _step;
	    var _x_i  = _x1;
	    var _y_i  = _y1;
	    repeat (_step + 1)
	    {
	        if __can_hit_obj != undefined
	        {
	            var _len = array_length(__can_hit_obj);
	            var _i = _len -1;
	            repeat (_len)
	            {
	                hitbox_place_list(_x_i, _y_i, __can_hit_obj[_i], _list, false);
	                --_i;
	            }
	        }
	        _x_i += _xgap;
	        _y_i += _ygap;
	    }
	}
	static hurt_list = function(_x1 = x, _y1 = y, _x2 = x, _y2 = y, _collider, _list) {
	    var _i   = ds_list_size(_list);
	    repeat( _i )
	    {
			_i--;
	        var _hit_id_i = _list[| _i];
			var _hurted   = ds_list_find_index(hurted_id_list, _hit_id_i) 
			if ( _hurted == -1 or (!mono_hurt and hurted_time_list[| _i] <= __life_timer ) ) // if not in the exception list // or if it is, if multi_hurt is accepted and last time hurt is ok
			{
	            var _blocker = noone;
	            if _collider != false and _collider != undefined
	            {
	                // simple ray casting in case the hitbox collide with target and solid at the same time -> check target is on the same size as the hit box
	                with (_hit_id_i) 
	                { 
	                    if !is_array(_collider) _blocker = collision_line(_x1, _y1, _hit_id_i.x, _hit_id_i.y, _collider, false, true); 
	                    else
	                    {
	                        var _j = array_length(_collider);
	                        repeat (_j) 
	                        {
	                            --_j;
								var _try_j = collision_line(_x1, _y1, _hit_id_i.x, _hit_id_i.y, _collider[_j], false, true);
	                            if _try_j != noone { _blocker = _try_j; break; }
	                        }
	                    }
	                } 
	            }
	            if ( _blocker )
	            {
	                // var _dir = point_direction(_x1, _y1, _hit_id_i.x, _hit_id_i.y);
	                // blocked fx spark_create_depth(_hit_id_i.x - lengthdir_x(8, _dir), _hit_id_i.y - lengthdir_y(8, _dir), e_depth.level_fx - 1, sFX_Spark_16, _hit_id_i, 0, 0, 1, 1, 0, 0, 0, true);
	                // blocked sound
	            }
	            else 
	            {
	                if mono_hurt 
					{
						ds_list_add(hurted_id_list, _hit_id_i);
					}
					else 
					{
						if _hurted != -1
						{
							hurted_time_list[| _hurted] = __life_timer + rehurt_timing;
						}
						else
						{
							ds_list_add(hurted_id_list, _hit_id_i);
							ds_list_add(hurted_time_list, __life_timer + rehurt_timing);
						}
					}
	                if __hit_func != undefined
	                {
	                    __hit_func(_hit_id_i);
	                } 
	                _hit_id_i.hurt(damages, __owner, __properties, __hurt_func);
	            }
	        }
	    }
	}
	/// @description    move hitbox to owner position and clone x and y scales and image_angle from owner
	static follow_owner_position = function(_id = __owner) {
	    if ( _id != noone and instance_exists(_id) )
	    {
			var _angle  = __offset_angle;
			if variable_instance_exists(_id, "sprite")
			{
				if _id.sprite.image_xscale < 0
				{
					_angle = 180 - _angle;
				}
				if _id.sprite.image_yscale < 0
				{
					_angle = -_angle;
				}
				_angle += _id.sprite.image_angle;
			}
			else
			{
				if _id.image_xscale < 0
				{
					_angle = 180 - _angle;
				}
				if _id.image_yscale < 0
				{
					_angle = -_angle;
				}
				_angle += _id.image_angle;
			}
			x = _id.x + lengthdir_x(__offset_length, _angle);
			y = _id.y + lengthdir_y(__offset_length, _angle);
		}
	}
	/// @description    clone x scale, y scale and image_angle from owner
	static follow_owner_angle = function(_id = __owner) {
		if ( _id != noone and instance_exists(_id) )
		{
			if variable_instance_exists(_id, "sprite")
			{
			    image_xscale = _id.sprite.image_xscale;
			    image_yscale = _id.sprite.image_yscale;
			    image_angle  = _id.sprite.image_angle;
			}
			else
			{
			    image_xscale = _id.image_xscale;
			    image_yscale = _id.image_yscale;
			    image_angle  = _id.image_angle;
			}
	    }
	}
	#endregion
	
	#region Public Methods
	/// @function step()
	/// @description    step function that will animate sprite, move hitbox, detect collision and hurt the colliding items
	static step = function()                                      {
	    // exceptions
	    if !__active                         { exit; }
	    if __destroyed                       { exit; }
	    if ( destroy_on_timer > 0 and -- destroy_on_timer <= 0 ) { destroy(); exit; }
		// get older and clean hurt instances every 60 steps
		__life_timer++;
		if ( __life_timer mod 60 == 0 )
		{
			var _list = hurted_time_list;
			var _i    = ds_list_size(_list);
			repeat( _i )
		    {
				--_i;
				if ( _list[| _i] < __life_timer )
				{
					ds_list_delete(_list, _i);
					ds_list_delete(hurted_id_list, _i);					
				}
			}
		}
	    // animate
	    if will_end(sprite_get_number(sprite_index)) 
	    { 
	        if destroy_on_end
	        {
	            image_index = sprite_get_number(sprite_index) - 0.1;
	            destroy();
	            exit;
	        }
	    }
	    // increment_image_index
		var _sprite = sprite_index;
		var _end_frame = sprite_get_number(sprite_index);
		var _speed  = (sprite_get_speed_type(_sprite) == spritespeed_framespergameframe) ? sprite_get_speed(_sprite) * image_speed : sprite_get_speed(_sprite) * image_speed / game_get_speed(gamespeed_fps);
		image_index += _speed;
		if ( image_index > _end_frame + 1)
		{
			image_index -= _end_frame + 1;
		}
		else if ( image_index == _end_frame + 1) // I tried wihout it and it did not work... floating thing I think
		{
			image_index = 0;
		}
		// move 
	    if follow_angle 
		{
			follow_owner_angle(__owner);
		}
		if follow_position
	    {
	        follow_owner_position(__owner);
	    }
	    else 
	    {
	        x += x_vel;
	        y += y_vel;
	    }

	    // hit
	    ds_list_clear(temp_hit_list);
	    hitbox_move_list(xprevious, yprevious, x, y, temp_hit_list);
	    if !hurting exit;
	    hurt_list(xprevious, yprevious, x, y, collider, temp_hit_list);
	    // save previous position for next step
	    xprevious = x;
	    yprevious = y;
	}
	/// @function draw()
	/// @description    draw the sprite, inherited from sprite_data
	static draw = function(_x = x, _y = y)                        {
		// if !__active exit; // please use visible
		if __destroyed  { exit; }
		if !visible     { exit; }
		draw_sprite_ext(sprite_index, image_index, _x, _y, image_xscale, image_yscale, image_angle, image_blend, image_alpha);
	}
	/// @description    reset ability to hurt instances
	static reset = function()                                     {
		ds_list_clear(temp_hit_list);
		ds_list_clear(hurted_id_list);
		ds_list_clear(hurted_time_list);
		return self; 
	}
	/// @description    mark as destroyed, will not do anything and will be cleaned in next step by oHitbox_Manager.
	static destroy = function()                                   {
		__destroyed = true;
		return self; 
	}
	/// @description    clean data structures
	static clean = function()                                     {
		ds_list_destroy(temp_hit_list);
		ds_list_destroy(hurted_id_list);
		ds_list_destroy(hurted_time_list);
		return self; 
	}
	#endregion
	
	#region Getters and Setters - can be chained
	static get_properties      = function(_name)                  {
		return __properties;
	}
	static get_property        = function(_name)                  {
		return variable_struct_get(__properties, _name);
	}
	static set_active          = function(_active, _reset = true) {
		__active  = _active;
		visible   = _active
		if _reset reset();
		return self; 
	}
	static set_paused          = function(_bool = true)           {
		paused = !paused
		return self; 
	}  
	static set_hurting         = function(_hurting)               {
		hurting         = _hurting;
		return self; 
	}
	static set_speed_x         = function(_vel)                   {
		x_vel           = _vel;
		return self; 
	}
	static set_speed_y         = function(_vel)                   {
		y_vel           = _vel
		return self; 
	}
	static set_owner           = function(_owner, _do_offset)     {
		__owner         = _owner;
		if ( _do_offset and __owner != noone and instance_exists(__owner) )
		{
			x_offset = x - _owner.x;
			y_offset = y - _owner.y;
			var _x     = _owner.x;
			var _y     = _owner.y;	
			__offset_length   = point_distance (_x, _y, x, y);
			__offset_angle    = point_direction(_x, _y, x, y);
			if variable_instance_exists(_owner, "sprite")
			{
				__offset_angle -= _owner.sprite.image_angle;
				if _owner.sprite.image_xscale < 0
				{
						__offset_angle = 180 - __offset_angle;
				}
				if _owner.sprite.image_yscale < 0 
				{ 
					__offset_angle *= -1;
				}
			}
			else
			{
				__offset_angle -= _owner.image_angle;
				if _owner.image_xscale < 0
				{
						__offset_angle = 180 - __offset_angle;
				}
				if _owner.image_yscale < 0 
				{ 
					__offset_angle *= -1;
				}
			}
		}
		return self; 
	}
	static set_mono_hurt       = function(_mono)                  {
		mono_hurt       = _mono;
		return self; 
	}
	static set_rehurt_timing   = function(_timing)                {
		rehurt_timing   = _timing;
		return self; 
	}
	static set_follow_angle    = function(_follow)                {
		follow_angle    = _follow;
		return self; 
	}
	static set_follow_position = function(_follow)                {
		follow_position = _follow;
		return self; 
	}
	static set_coll_accuracy   = function(_accuracy)              {
		coll_accuracy   = _accuracy;
		return self; 
	}
	static set_collider        = function(_collider)              {
		collider        = _collider;
		return self; 
	}
	static set_destroy_on_timer= function(_timer)                 {
		destroy_on_timer           = _timer;
		return self; 
	}
	static set_destroy_on_end  = function(_destroy)               {
		destroy_on_end  = _destroy;
		return self; 
	}
	static set_destroy_on_hit  = function(_destroy)               {
		destroy_on_hit  = _destroy;
		return self; 
	}
	static set_property        = function(_name, _value)          {
	    if (is_array(_value))
		{
			var _len    = array_length(_value);
			var _output = array_create(_len);
			var _i = 0;
			repeat(_len) 
			{
				_output[_i] = _value[_i];
				++_i;
			}
			variable_struct_set(__properties, _name, _output);
	    }
	    else if (is_struct(_value))
		{
			var _output = {};
			var names   = variable_struct_get_names(_value);
			var _i      = variable_struct_names_count(_value), _name_i; 
			repeat(_i) 
			{
				--_i;
				_name_i = names[_i];
				variable_struct_set(_output, _name_i, variable_struct_get(_value, _name_i ));
			}	
			variable_struct_set(__properties, _name, _output);
		}
		else
		{
			variable_struct_set(__properties, _name, _value);
		}
		return self; 
	}
	static set_damages         = function(_damages)               {
		damages         = _damages;
		return self; 
	}
	static set_hurt_function   = function(_hurt_function)         {
		__hurt_func     = _hurt_function;
		return self; 
	}
	static set_hit_function    = function(_hit_function)          {
		__hit_func      = _hit_function;
		return self; 
	}
	static set_collide_function= function(_col_function)          {
		__collide_func  = _col_function;
		return self; 
	}
	static set_can_hit_object  = function(_can_hit)               {
		__can_hit_obj = _can_hit;
		return self; 
	}
	#endregion
}
