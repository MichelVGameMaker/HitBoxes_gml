# Hit Boxes Library
![Hit Boxes Demo](https://github.com/MichelVGameMaker/HitBoxes_gml/assets/62699812/bb361f54-6a72-45d7-8caf-7c4bfc8a06ae)  
*manage Hit Boxes and Hurt Boxes.*  



## WELCOME!
HitLib is a library I have built over 2 projects to process hiting/hurting enemies or other entities called 'hurtable'. The library comes with many options and is quite ok... I think. HitLib is a library I have built over 2 projects to process hiting/hurting enemies or other entities called 'hurtable'. The library comes with many options and is quite ok... I think.

## FEATURES:
- add Hurtable behavior by parenting or attach Hurt Boxes to instances. 
- adjust how Hurt Bowes follow / mimic their 'owning' instances.
- create Hit Boxes with hitbox_create() function.
- adjust how Hit Bowes follow / mimic their 'owninh' instance.
- add speed to Hit Boxes, manage high speed movement collision. 
- cancel Hit Boxes on collision with walls.
- customize parameters (damages, attack types, callback function...) to fit your game features.

## LICENSE:
G2L is fully free. Do whatever you want with it.

## BEHIND THE HOOD:
Hitlib relies on hitboxes, virtual sprite-shaped entities that deal damages upon collision with hurtable instances.  
Hit Boxes are struct entities. They are managed by 'controller' objects called Hitbox_manager.  
Note that the same result could be achieved with independant objects.  

Hitbox_manager objects are mainly there for processing collision and drawing the associated sprites (thus, there is one Hitbox_manager per layer, no matter the number of Hitboxes). If you make your Hit Boxes invisible, you should create all of them at the same depth.  

Hurt Boxes are instances of the oHurtbox

## HOW TO INSTALL IN GAME MAKER YOUR PROJECT
Download the 'Hit Boxes Package.yymps' file from GITHUB. (the other package is a simple demo if you want to try it out).  
Import it inside your project. You can do this by dragging the . yymps file from an explorer window onto the GameMaker IDE or by clicking "Import Local Package" within the Tools Menu. In both case, a window will pop up to define import parameters.  
Click “add all” and “OK”.  
This will create one folder in your Asset Browser labeled “Hitbox BY MICHELV”. The code is ready to be used.  

## HOW TO USE:
### Configuration: 
There are two macro you need to set to interface 'HitBoxes' with your code.
They are located in the 'hitboxlib.gml' script asset under the section 'HitLib Options'.
- #macro __HITLIB_DEFAULT_COLLIDER  oColliderTest: the name of a Collider / Solid Parent Object. Children will bloc Hit Boxes.
- #macro __HITBOX_DEFAULT_HURTABLE  [oTarget_Par, oHurtbox]: the names of all 'Hurtable' Parent Objects. All their children will gain the ability to be hurt by Hit Boxes.

### Usage:
There is no intialization function required. You can create Hit Boxes with hitbox_create() and then they are processed automatically.  
For example, 
- hitbox_create(x, y, sprite_slash) will create an Hit Box that follows the calling instance (useful for a slash).  
- hurtbox_create(sBig_Square) will create an Hit Box that follows the calling instance and its angle/scales with the sBig_Square mask.

You need to manually  detroy your Hit Boxes. The best approach is to set destroy_on_end or a destroy_timer, but this might not be convenient for projectiles.

### Hit Box:
#### Parameters for hitbox_create:
| parameter          | default                  | details                                                                           |
| ------------------ | ------------------------ | --------------------------------------------------------------------------------- |
| x                  | no default               | x coordinate. mandatory.                                                          |
| y                  | no default               | y coordinate. mandatory.                                                          |
| sprite_index       | no default               | sprite - mask is used to detect collision. mandatory.                             |
| owner              | calling instance         | owning instance.                                                                  |
| follow             | true                     | if true, the Hit Box will follow owning instance's position, angle and scales.    |
| damages            | no default               | number of health points lost.                                                     |
| can_hit_obj        | _HITBOX_DEFAULT_HURTABLE | objects that can be hit (objects and all their children because we use parenting).|
| properties         | {}                       | struct of custom data you want to pass to the hurt_func.                          |
| hurt_func          | undefined                | custom hurt function                                                              |
| hit_func           | undefined                | custom hit function, if you want to separate instructions.                        |
| timer              | -1                       | if >0, used as a destroy alarm, in steps                                          |
| destroy_on_end     | false                    | if true, Hit Box destroy on animation end.                                        |
| visible            | true                     | if false, Hit Box is invisible.                                                   |
| o_manager          | no default               | you can specify your own controller if you do not want to use the native one.     |

### Associated Getters
- is_active                                         get the active state. Destroyed HitBox are considere inacative.                                        
- is_paused                                         get the paused state.                                        
- get_owner                                         get the owning instance                                        
- get_sprite_index                                  get the sprite_index. 
- get_image_index                                   get the image_index. 
- get_image_xscale                                  get the image_xscale. 
- get_image_yscale                                  get the image_yscale. 
- get_image_angle                                   get the image_angle. 
- get_image_speed                                   get the image_speed. 
- get_image_alpha                                   get the image_alpha. 
- get_image_blend                                   get the image_blend. 
- get_visible                                       get the visibility.

### Associated Setters
- set_paused              (_bool = true)         	set the paused state. When paused, Hit Box is visible (drawn) but does not process its instructions (moves, animates and hurts). 
- set_hurting             (_hurting)             	set the hurting state. When disable, Hit Box moves and hit (hit_func) but does not hurt (hurt_func).
- set_speed_x             (_vel)                 	set the horizontal speed. Ignored if follow_position is enabled.
- set_speed_y             (_vel)                 	set the vertical speed. Ignored if follow_position is enabled.
- set_owner               (_owner, _do_offset)   	set the owner. If _do_offset is true, the position offset is updated.
- set_mono_hurt           (_mono)                	when true, the rehurt_timing is set to infinity.
- set_rehurt_timing       (_timing)              	set the required elapsed time (in steps) for the Hit Box to hurt the same entity twice.
- set_follow_angle        (_follow)              	set the follow behavior, if true Hit Boxes will mimic owning intance's shape attributes: scales and angles.
- set_follow_position     (_follow)              	set the follow behavior, if true Hit Boxes will follow the owning intance. The relative position of the hitbox to the owner (upon creation) is kept while following.
- set_coll_accuracy       (_accuracy)            	set the collision accuracy for moving Hit Boxes.
- set_collider            (_collider)            	set the colliding instance that will disable the Hit Box.
- set_destroy_on_timer    (_timer)               	when >0, Hit Box is destroyed after this time (in steps). 
- set_destroy_on_end      (_destroy)             	when true, Hit Box is destroyed on animation end.
- set_destroy_on_hit      (_destroy)             	not implemented
- set_property            (_name, _value)        	set a specific property into the properties struct.
- set_damages             (_damages)             	set the damage attribute.
- set_hurt_function       (_hurt_function)       	set the hurt function(), it is passed as an argument to the instance's method called by the hit instance. hurt(damages, owner, properties, __hurt_func)
- set_hit_function        (_hit_function)        	set the hit function(), it is called with the id of the hit instance as argument hit_func(hit_id).
- set_collide_function    (_col_function)        	not implemented
- set_can_hit_object      (_can_hit)             	set the objects that can be hit. Uses an array of object index.
- static set_sprite_index (_asset)					set the sprite_index, used for collision detection. 
- static set_image_index  (_frame)					set the image_index, used for collision detection. 
- static set_image_xscale (_xscale)					set the image_xscale, used for collision detection. 
- static set_image_yscale (_yscale)					set the image_yscale, used for collision detection. 
- static set_image_angle  (_angle)					set the image_angle, used for collision detection. 
- static set_image_speed  (_speed)					set the image_speed, used for collision detection. 
- static set_image_alpha  (_alpha)					set the image_alpha, used for collision detection. 
- static set_image_blend  (_blend)					set the image_blend, used for collision detection. 
- static set_visible      (_visible)				set the visibility. 

### Additional Hit Box details:
You also can set some key parameters through setters methods: 
- image_xscale, _image_yscale, image_angle. The sprite is used to detect collision, so angle and scales are important. Please note that if follow is enable, those variables will be overiddent each step.
- collider: collider can be specified by Hit Box. If the line from the owning intance's origin to the hitbox's origin goes through a collider, the entity is not hurt.
- follow position: the Hit Box will follow the owning intance: x, y coordinates. The relative position of the hitbox to the owner (upon creation) is kept while following.
- Follow angle: the Hit Box will mimic the owning intance's shape attributes: scales and angles.
- hurting: You will likely want to customize what happen when hurting an instance. You can do that in the Hit Bbox library if the hurt behavior is the same for all your Hit Boxes (reducing health points for instance).
    You can also add Hit Box specific features through call back functions hurt_func and hit_func.
- destruction: can be triggered on animation_end (if set to true) or after a timer (if timer is > 0) (I would advise to choose between the two and not let hitbox indefinitively alive).
- accuracy: Hit Boxes hurt entities over their movements with a precision step of 8 pixels, you can adjust that if needed with the coll_accuracy variable.
  > Please note it is the Hit Box that hurts the entity when moving.
  > It is ok to have quickly moving Hit Boxes. But it is not designed to cover quickly moving target entities going through the Hit Box
  > If an entity is moving quickly enough to go through the Hit Box (such as it is not colliding before movement and not colliding after movement) it will not trigger.
- image_alpha, image_blend, image_speed variables can also be managed through setters.

### Hurt Box:
#### Parameters for hitbox_create:
| parameter          | default                  | details                                                                           |
| ------------------ | ------------------------ | --------------------------------------------------------------------------------- |
| x                  | caller's x               | x coordinate. mandatory.                                                          |
| y                  | caller's y               | y coordinate. mandatory.                                                          |
| sprite_index       | caller's mask            | sprite is used to detect collision. mandatory.                             |
| owner              | calling instance         | owning instance.                                                                  |

### Associated GSetters
owner_exists                                        test if the owning instance exists.
owner_get                                           get the owning instance.

### Associated Setters
owner_set (_instance, _do_offset = true) 
- mask_set                (_sprite)                 set the mask_index. Current scales, angles and positions are kept.
- angle_set               (_angle)                  set the angle, that will refresh the attachment position so that Hurt Box is now attached like it is when calling this function.
- xscale_set              (_scale)                  set the xscale, that will refresh the attachment position so that Hurt Box is now attached like it is when calling this function.
- yscale_set              (_scale)                  set the yscale, that will refresh the attachment position so that Hurt Box is now attached like it is when calling this function.
- position_set            (_x, _y, _do_offset)      set the position,  that will refresh the attachment position so that Hurt Box is now attached like it is when calling this function.
- attachment_set          (_x, _y)                  set user-defined x-y attachment. Parameters should be passed in the owner's referential = considering owner has a default angle and scales (angle = 0, scales = 1) = how the owner'sprite appears in the Sprite editor.
- shape_set               (_xfac, _yfac, _angle)    set user-defined scales and angle. Parameters should be passed in the owner's referential = considering owner has a default angle and scales (angle = 0, scales = 1) = how the owner'sprite appears in the Sprite editor.
- mimic_angle_enable      (_mimic)                  set the mimicing behavior dealing with owning instance's angle.
- mimic_xscale_enable     (_mimic)                  set the mimicing behavior dealing with owning instance's xscale.
- mimic_yscale_enable     (_mimic)                  set the mimicing behavior dealing with owning instance's yscale.
- mimic_image_index_enable(_mimic)                  set the mimicing behavior dealing with owning instance's image_index.
- follow_xy_enable        (_follow)                 set the following behavior dealing with owning instance's coordinates.
- follow_angle_enable     (_follow)                 set the following behavior dealing with owning instance's angle.
- follow_xscale_enable    (_follow)                 set the following behavior dealing with owning instance's xscale.
- follow_yscale_enable    (_follow)                 set the following behavior dealing with owning instance's yscale.
