Welcome to the Hit Box demo.
I have tried to demonstrate most of the features creating hitboxes from an instance of an Object I called ‘oSlasher’:

1.  Hurt once or multiple times:
1.1.Basics: a hitbox with default values. You can appreciate a ‘Target’ is only hurted once per hitbox even if the hitbox last many steps, which is the most useful configuration.
1.2.Rehurt: a hitbox with default values that is reset. It is useful for threats that reload like traps.
1.3.Multi hurt: a hitbox that can hurt Target several times, if 30 steps elapsed . It is useful for threats like lazer or fall zones.
2.  Movement
2.1.Follow: a hitbox with default values created 8 pixels in front of the ‘Slasher’. Changing ‘Slasher’s orientation you can appreciate the hitbox follows. This is useful for a melee attack and if the hitbox lasts more than one frame and you want to give input tolerance to change attack orientation or the casting instance is moving quickly.
2.2.Bullet: a moving hitbox to showcase the basic movement capability. A better way to approach projectiles is to attach a hitbox to a projectile object you would create on your side with more features.
3.  collider: a hitbox with default values. A collider is sitting between the ‘Slasher’ and the ‘Target’ showcasing the collider feature.

