package backend;

import flixel.sound.FlxSound;

class Sound extends FlxObject
{
	public var sound:FlxSound;

	public function new(X:Float, Y:Float)
	{
		super(X, Y, 1, 1);
	}

	public static function playError()
	{
		FlxG.sound.play("assets/sounds/error.ogg");
	}

	public static function playCharacter(first:String, two:String)
	{
		FlxG.sound.play('assets/player/characters/$first/$two.ogg', 0.5);
	}
}
