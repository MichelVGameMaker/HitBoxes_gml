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

## BEHIND THE HOOD:
Hitlib relies on hitboxes, virtual sprite-shaped entities that deal damages upon collision with hurtable instances.  
Hitboxes are struct entities. They are managed by 'controller' objects called Hitbox_manager.  
Note that the same result could be achieved with independant objects.  
Hitbox_manager objects are mainly there for processing collision and drawing the associated sprites (thus, there is one Hitbox_manager per layer, no matter the number of Hitboxes). If you make your Hit Boxes invisible, you should create all of them at the same depth.  

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

