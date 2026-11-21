package backend;

class Color 
{
    public static function get(what:String):FlxColor
    {
        if (what == "xp")
        {
            return FlxColor.fromRGB(255,174,66);
        }
        return FlxColor.WHITE;
    }    
}