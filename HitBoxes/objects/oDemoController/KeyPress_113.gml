/// @description Next Room
if room_exists(room_next(room))
{
    room_goto_next();
}
else
{
    room_goto(room_first);
}