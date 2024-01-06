# Hit Boxes
 Library to manage Hit Boxes and Hurt Boxes
 HitLib is a library I have built over 2 projects to process hiting/hurting enemies or other entities called 'hurtable'. The library comes with many options and is quite ok... I think.

# FEATURES:
- add Hurtable behavior by parenting or attach Hurt Boxes to instances. 
- adjust how Hurt Bowes follow / mimic their 'owning' instances.
- create Hit Boxes with hitbox_create() function.
- adjust how Hit Bowes follow / mimic their 'owninh' instance.
- add speed to Hit Boxes, manage high speed movement collision. 
- cancel Hit Boxes on collision with walls.
- customize parameters (damages, attack types, callback function...) to fit your game features.

# BEHIND THE HOOD:
Hitlib relies on hitboxes, virtual sprite-shaped entities that deal damages upon collision with hurtable instances.
Hitboxes are struct entities. They are managed by 'controller' objects called Hitbox_manager. 
Note that the same result could be achieved with independant objects.
Hitbox_manager objects are mainly there for processing collision and drawing the associated sprites (thus, there is one Hitbox_manager per layer, no matter the number of Hitboxes). If you make your Hit Boxes invisible, you should create all of them at the same depth.

# HOW TO USE:
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
- image_xscale, _image_yscale, image_angle. The sprite is used to detect collision, so angle and scales are important. Please note that if follow is enable, those variables will be overiddent each step.
- Collider: If the line from the owner origin of the hitbox and the origin of the entity go through a collider, the entity is not hurt.
- Follow position: The hitbox will follow the owning intance: x, y. The relative position of the hitbox to the owner (upon creation) is kept while following.
- Follow angle: The hitbox will hmimic the owning intance shape attributes:scales and angles).
- The struct also has image_alpha, image_blend, image_speed variables that can be managed through setters.
- Accuracy: Hitboxes hurt entities over their movements with a precision step of 8 pixels, you can adjust that if needed with the coll_accuracy variable.
  > Please note it is the hitbox that hurts the entity when moving. It is ok to have quickly moving hitboxes. But it is not designed to cover quickly moving target entities going through the Hit Box
  > If an entity is moving quickly enough to go through the hitbox (such as it is not colliding before movement and not colliding after movement) it will not trigger.
- Hurting: You will likely want to customize what happen when hurting an instance. You can do that in the hitbox library if the hurt behavior is the same for all your weapon (reducing hp).
    You can also add hitbox specific features through call back defined in hitbox_create() argument.
- Destruction: can be triggered on animation_end (if set to true) or after a timer (if timer is > 0) (I would advise to choose between the two and not let hitbox indefinitively alive).

