function shw_w()
{
	if argument_count > 0 var _string = string(argument[0]) + "- Warning.\t";
	else                  var _string = "[Empty Warning Message]";
	if argument_count > 1 
	{
		var _n = argument_count - 1
	    var _i      = 1;
		repeat(_n)
	    {
			_string += string(argument[_i]);
	        ++_i;
	    }  
	}
	show_debug_message(_string)
}
// Optional information message
function shw_i()
{
	if argument_count > 0 var _string = string(argument[0]) + "- Info.\t";
	else                  var _string = "[Empty Information Message]";
	if argument_count > 1 
	{
		var _n = argument_count - 1
	    var _i      = 1;
		repeat(_n)
	    {
			_string += string(argument[_i]);
	        ++_i;
	    }  
	}	
	show_debug_message(_string)
}
// Major Log event
function shw_l()
{
	if argument_count > 0 var _string = string(argument[0]) + "- LOG.\t";
	else                  var _string = "[Empty LOG Message]";
	if argument_count > 1 
	{
		var _n = argument_count - 1
	    var _i      = 1;
		repeat(_n)
	    {
			_string += string(argument[_i]);
	        ++_i;
	    }  
	}	
	show_debug_message(_string)
}
// Report Major Error
function shw_e()
{
	if argument_count > 0 var _string = string(argument[0]) + "- ERROR.\t";
	else                  var _string = "[Empty ERROR Message]";
	if argument_count > 1 
	{
		var _n = argument_count - 1
	    var _i      = 1;
		repeat(_n)
	    {
			_string += string(argument[_i]);
	        ++_i;
	    }  
	}	
	show_debug_message(_string)
}
function shw()
{
    var _string = "";
    var _i      = 0;
    repeat(argument_count)
    {
		_string += string(argument[_i]);
        ++_i;
    }
	show_debug_message(_string)
}