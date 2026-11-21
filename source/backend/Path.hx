package backend;

class Path 
{
    public static var font:String = 'assets/fonts/main.ttf';
    public static function getPathCharacter(character:String,source:String) 
    {
        return 'assets/player/characters/$character/$source';
    }
    public static var null_icon:String = 'assets/player/null.png';
}