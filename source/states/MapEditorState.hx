package states;

import haxe.ui.core.Screen;

class MapEditorState extends PuppetsState
{
    var bg:FlxSprite;

    var cameraUI:FlxCamera;

    var groupUI:FlxSpriteGroup;

    var containerUpItems:HBox;
    
    override function create() 
    {
       
        super.create();
    
        bg = new FlxSprite();
        bg.x = 0;
        bg.y = 0;
        bg.makeGraphic(FlxG.width,FlxG.height,FlxColor.WHITE);
        add(bg);

        cameraUI = new FlxCamera(0,0,FlxG.width,FlxG.height);
        cameraUI.bgColor = FlxColor.TRANSPARENT;

        FlxG.cameras.add(cameraUI,false);

        groupUI = new FlxSpriteGroup(0,0);
        groupUI.cameras = [cameraUI];
        add(groupUI);

        addUI();
    

    }   
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.pressed.CONTROL && FlxG.mouse.wheel == 1)
        {
            FlxG.camera.zoom += 0.05;
        }

        if (FlxG.keys.pressed.CONTROL && FlxG.mouse.wheel == -1)
        {
            FlxG.camera.zoom -= 0.05; 
        }
    }
    override function destroy() {
        super.destroy();

        FlxG.cameras.remove(cameraUI);
    }
    private function addUI() 
    {
        containerUpItems = new HBox();
        containerUpItems.x = 0;
        containerUpItems.y = 0;
       

        var button = new Button();
        button.text = "File";

        var button1 = new Button();
        button.text = "SeT";

        containerUpItems.addComponent(button);
        containerUpItems.addComponent(button1);
    
        groupUI.add(containerUpItems);

    }
} 