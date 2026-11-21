package backend.states;

import openfl.display.BitmapData;

class PuppetsState extends FlxState 
{
    //public var enableCustomFunctionEscape:Bool = false;

   // public var console:Console;
    override public function create() 
    {

        super.create();
   //     FlxG.camera.flash(FlxColor.BLACK,0.5);

        FlxSprite.defaultAntialiasing = true;
        FlxG.autoPause = false;

    /*    @:privateAccess {
    if (haxe.ui.Toolkit._initialized) {
        FlxG.signals.postGameStart.add(haxe.ui.core.Screen.instance.onPostGameStart);
        FlxG.signals.postStateSwitch.add(haxe.ui.core.Screen.instance.onPostStateSwitch);
        FlxG.signals.preStateCreate.add(haxe.ui.core.Screen.instance.onPreStateCreate);
    } else {
        haxe.ui.Toolkit.init();
    }
} */

       // final className = Type.getClassName(Type.getClass(this)).split('.');
        
     //   initStyles(className[className.length - 1]);

    // console = new Console();
    // add(console);

    }
    override function update(elapsed:Float) 
    {
        super.update(elapsed);

      //  if (enableCustomFunctionEscape == false)
      //  {
        //    if (FlxG.keys.justPressed.ESCAPE)
       // {
            
         //     FlxG.camera.fade(FlxColor.BLACK,0.5,false,function name() {
         //       Main.fps.visible = false;
         //       FlxG.switchState(MenuState.new);
         //   });    
        //}

       // if (FlxG.keys.justPressed.F1)
      //  {
       //     if (console.alive)
       //     {
       ///         console.kill();
        //    }
       //     if (!console.alive)
       //     {
       //         console.revive();
       //     }
      //  }

        if (FlxG.keys.justPressed.ESCAPE)
        {
            Main.fps.visible = false;
                FlxG.switchState(MenuState.new);
        }
    }

    override function destroy() 
    {
        if (Texture.atlases != [])
        {

        
        for (i in Texture.atlases)
        {
            Texture.atlases.remove(i);
            break;
        }
    }
        super.destroy();
    }
        
}


  /*  private function initStyles(nameStyle:String) 
    {
        if (nameStyle != null)
        {
            if (nameStyle == "MapEditorState")
            {
                Toolkit.styleSheet.parse("
                Button  {
                        font-name: 'assets/fonts/main.ttf';
                        font-size: 16;
                        color: #ffffff;
                        background-color: #242424;
                    }
                        ");
            }
        }
    } */
//}