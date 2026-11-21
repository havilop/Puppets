package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.MapEditorState;

class Main extends Sprite
{
	public static var fps:FPS;
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState,75,75,true));
		fps = new FPS(200,0,0xFFFFFFFF);
		fps.visible = false;
		addChild(fps);

		FlxG.fixedTimestep = false;
		
	}
}
