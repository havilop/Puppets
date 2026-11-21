package backend;

import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;

class Texture {
    

    public static var atlases:Array<FlxAtlasFrames> = [];
    
/**
     * Загружает атлас и сохраняет его в кеш
     */
    public static function loadAtlas(name:String):Void 
    {

            var atlas = FlxAtlasFrames.fromTexturePackerXml('$name.png', '$name.xml');

            for (keys in atlas.frames)
            {
                 FlxG.bitmap.add(keys.parent.bitmap,true,keys.name);

             //    trace(keys.name);
              //   trace(FlxG.bitmap.checkCache(keys.name));
            }


          //  atlases.push(atlas);
   
    }
    
    /**
     * Получает текстуру из загруженного атласа по имени
     */
  /*   public static function getTexture(name:String):FlxFrame {
        if (name == null || name == "") {
            trace('ERROR');
            return null;
        }
        
        for (atlas in atlases) {
            if (atlas.exists(name)) {
                return atlas.getByName(name);
            }
        }
        
        trace('dont ind $name in atlases');
        return null;
    } */
    
    /**
     * Проверяет, загружен ли атлас
     */
     
     public static function getTexture(name:String):FlxGraphic {
        trace(FlxG.bitmap.checkCache(name));
        return FlxG.bitmap.get(name); 
    }
}
