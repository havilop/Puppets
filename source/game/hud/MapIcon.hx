package game.hud;
import states.PlayState.MapHud;

class MapIcon extends FlxSpriteGroup
{
	public var entity:Entity;
	public var icon:FlxSprite;
	public var map:MapHud;

	public function new(PLAYER:Entity, MAP:MapHud)
	{
		super();

		entity = PLAYER;
		map = MAP;

		icon = new FlxSprite(0, 0);
		icon.setGraphicSize(20, 20);
		icon.updateHitbox();
		add(icon);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (entity != null && entity.exists)
		{
			icon.x = map.x + (entity.entityHitbox.x - 0) / (FlxG.worldBounds.width - 0) * map.bgmap.width;
			icon.y = map.y + (entity.entityHitbox.y - 0) / (FlxG.worldBounds.height - 0) * map.bgmap.height;
		}
		if (entity == null || !entity.exists)
		{
            removeIcon();
        }
	}

    public function removeIcon() {
        this.destroy();
        map.iconsGroup.remove(this,true);
    }
}
