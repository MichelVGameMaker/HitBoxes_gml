/// @description Previous Room
if room_exists(room_previous(room))
{
    room_goto_previous();
}
else
{
    room_goto(room_last);
}