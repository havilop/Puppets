package states;

import flixel.group.FlxGroup.FlxTypedGroup;

class MenuState extends PuppetsState
{
    public static var options:Array<String> = ['play','settings','mapeditor','exit'];
    public static var currentOption:String = "";
    public static var groupItems:FlxTypedGroup<MenuItem>;

    override public function create() {

        //enableCustomFunctionEscape = true;

        currentOption = options[0];   

        groupItems = new FlxTypedGroup<MenuItem>();
        add(groupItems);
        
        for (key => i in options)
        {
            var button = new MenuItem((key * 50),i);
            groupItems.add(button);
        }

         super.create();

    }    
    override function update(elapsed:Float) {
        super.update(elapsed);

        if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)
        {
              for (key => i in options)
            {
                if (i == currentOption)
                {
                    if (options[key - 1] != null)
                    {
                        currentOption = options[key - 1];
                     
                        break;
                    } else if (options[key - 1] == null)
                    {
                        currentOption = options[options.length - 1];
                     
                        break;
                    }
                }
            }

            
        }

         if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
        {
            for (key => i in options)
            {
                if (i == currentOption)
                {
                    if (options[key + 1] != null)
                    {
                        currentOption = options[key + 1];
                   
                        break;
                    } else if (options[key + 1] == null)
                    {
                        currentOption = options[0];
                      
                        break;
                    }
                }
            }
        }
    }
}
class MenuItem extends FlxSpriteGroup 
{
    var text:FlxText;
    var name:String = '';
    
    var controlKeys:Bool = false;

    public function new(Y,NAME_OPTION)     
    {
        super(0,0);

        name = NAME_OPTION;

        text = new FlxText(0,Y,0,NAME_OPTION,32);
        add(text);

        this.screenCenter(XY);


    }   

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.anyJustPressed([W,S,UP,DOWN]))
        {
            controlKeys = true;
            FlxG.mouse.visible = false;
        }
        if (FlxG.mouse.justMoved)
        {
            controlKeys = false;
            FlxG.mouse.visible = true;
        }
        if (this.overlapsPoint(FlxG.mouse.getWorldPosition()))
        {   
            
            if (controlKeys == false)
            {

            
            MenuState.currentOption = name;

            if (FlxG.mouse.justPressed)
            {
                callBack();
            }

            }
        }

        if (name == MenuState.currentOption)
        {
            text.color = FlxColor.YELLOW;
        } else {
            text.color = FlxColor.WHITE;
        }

        if (name == MenuState.currentOption)
        {
             if (FlxG.keys.justPressed.ENTER)
             {   
                 callBack();
             }   
        }
    }
    function callBack()
    {
           switch name
            {
                case "play":
                    FlxG.mouse.visible = true;
				PlayState.mapPath = 'assets/maps/puppets';
                    FlxG.switchState(PlayState.new);
                case "mapeditor":
				//   FlxG.switchState(MapEditorState.new);
                case "settings":
                    trace(name);
                case "exit":
                    Sys.exit(0);
            }
    }
}