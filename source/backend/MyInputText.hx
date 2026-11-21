package backend;

import flixel.text.FlxInputText;

class MyInputText extends FlxInputText
{
	public var fixedCaretHeight:Int = 0;
	
	override function updateCaretSize():Void
	{
		if (_caret == null) return;
		_regenCaretSize = false;
		
		var lineHeight:Float = 0;
		
		if (fixedCaretHeight > 0)
		{
			lineHeight = fixedCaretHeight;
		}
	
		
		_caret.makeGraphic(caretWidth, Std.int(lineHeight));
		clipSprite(_caret);
	}
}