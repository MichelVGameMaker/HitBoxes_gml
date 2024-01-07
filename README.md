# Hit Boxes
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
Hitboxes are struct entities. They are managed by 'controller' objects called Hitbox_manager.  
Note that the same result could be achieved with independant objects.  
Hitbox_manager objects are mainly there for processing collision and drawing the associated sprites (thus, there is one Hitbox_manager per layer, no matter the number of Hitboxes). If you make your Hit Boxes invisible, you should create all of them at the same depth.  

## HOW TO INSTALL IN GAME MAKER YOUR PROJECT:
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
There is no intialization function required. You can create hitboxes with hitbox_create() and then they are processed automatically.  
For example, hitbox_create(x, y, sprite_slash) will create an hitbox that follows the calling instance (useful for a slash).  
You need to manually  detroy your Hit Boxes. The best approach is to set destroy_on_end or a destroy_timer, but this might not be convenient for projectiles.

### Parameters for hitbox_create:
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

### Additional parameters:
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
- 

### ASSOCIATED SETTERS (and 2 getters)
- get_properties      (_name)                	  get the properties struct.
- get_property        (_name)                	  get one specific property by its name.
- set_active          (_active, _reset = true)    set the active state. When disable, Hit Box is visible (drawn) but does not process its instructions (moves and hurts). 
- set_paused          (_bool = true)         	  not implemented yet. Use set_active
- set_hurting         (_hurting)             	  set the hurting state. When disable, Hit Box moves and hit (hit_func) but does not hurt (hurt_func).
- set_speed_x         (_vel)                 	  set the horizontal speed. Ignored if follow_position is enabled.
- set_speed_y         (_vel)                 	  set the vertical speed. Ignored if follow_position is enabled.
- set_owner           (_owner, _do_offset)   	  set the owner. If _do_offset is true, the position offset is updated.
- set_rehurt_timing   (_timing)              	  set the required elapsed time (in steps) for the Hit Box to hurt the same entity twice.
- set_mono_hurt       (_mono)                	  when true, the rehurt_timing is set to infinity.
- set_follow_angle    (_follow)              	  set the follow behavior, if true Hit Boxes will mimic owning intance's shape attributes: scales and angles.
- set_follow_position (_follow)              	  set the follow behavior, if true Hit Boxes will follow the owning intance. The relative position of the hitbox to the owner (upon creation) is kept while following.
- set_coll_accuracy   (_accuracy)            	  set the collision accuracy for moving Hit Boxes.
- set_collider        (_collider)            	  set the colliding instance that will disable the Hit Box.
- set_destroy_on_timer(_timer)               	  when >0, Hit Box is destroyed after this time (in steps). 
- set_destroy_on_end  (_destroy)             	  when true, Hit Box is destroyed on animation end.
- set_destroy_on_hit  (_destroy)             	  not implemented
- set_property        (_name, _value)        	  set a specific property into the properties struct.
- set_damages         (_damages)             	  set the damage attribute.
- set_hurt_function   (_hurt_function)       	  set the hurt function(), it is passed as an argument to the instance's method called by the hit instance. hurt(damages, owner, properties, __hurt_func)
- set_hit_function    (_hit_function)        	  set the hit function(), it is called with the id of the hit instance as argument hit_func(hit_id).
- set_collide_function(_col_function)        	  not implemented
- set_can_hit_object  (_can_hit)             	  set the objects that can be hit. Uses an array of object index.
