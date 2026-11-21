package backend;

import flixel.input.keyboard.FlxKey;

enum PuppetsDataKeyEnum 
{
    cancel;
    attack;
    ability1;
    ability2;
    ability3;
    ability4;

    ability5;
    ability6;

    item1;
    item2;
    item3;
    item4;
    item5;
    item6;

    shop;

}

class Data 
{
    public static function get(path:String,data:String):Dynamic
    {
        var json = Json.parse(File.getContent(path));
        

        var parts = data.split("/");
        var current = json;
        
        for (part in parts) {
            
            current = Reflect.field(current, part);

            if (current == null) {
                return null;
            }
        }
        
        return current;
        
    }

    public static function save(path:String,data:String,value:Dynamic) 
    {
        var storedData = Json.parse(File.getContent(path));

        Reflect.setProperty(storedData,data,value);

        File.saveContent(path,Json.stringify(storedData,null,""));
    }

    public static function getKey(data:PuppetsDataKeyEnum):FlxKey
    {
        return FlxKey.fromString(Data.get("assets/player/data/keys.json",data + ""));
    }
}