package game.hud;

import game.hud.MapIcon;
import states.PlayState.MapHud;
import sys.FileSystem;



class MapIconCHARACTER extends MapIcon
{
	public function new(PLAYER:Entity, MAP:MapHud)
	{
		super(PLAYER, MAP);

		remove(icon);
		icon = new FlxSprite(0, 0, getSprite(entity));
		icon.setGraphicSize(20, 20);
		icon.updateHitbox();
		add(icon);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		icon.visible = !entity.dead;
	}

	function getSprite(entity:Entity)
	{
		var nameCharacter = Type.getClassName(Type.getClass(entity)).split(".");
		var tempNameCharacter = nameCharacter[nameCharacter.length - 1];

		if (nameCharacter != null)
		{
			var path = 'assets/player/characters/' + tempNameCharacter.toLowerCase() + '/icon.png';
			if (FileSystem.exists(path))
			{
				return path;
			}
			else
			{
				return 'assets/player/characters/null_icon.png';
			}
		}

		return 'assets/player/characters/null_icon.png';
	}
}