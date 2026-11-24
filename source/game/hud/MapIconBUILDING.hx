package game.hud;

import states.PlayState.MapHud;

class MapIconBUILDING extends MapIcon 
{
    public function new(entityy:Entity,mapp:MapHud) 
    {
        super(entityy,mapp);

        remove(icon);
		var className = Type.getClassName(Type.getClass(entity)).split('.');
		var name = className[className.length - 1];

		icon = new FlxSprite(0, 0);

		if (name == 'Tower')
		{
			icon.makeGraphic(12, 12, entity.team != PlayState.selfEntity.team ? FlxColor.RED : FlxColor.GREEN);
		}
		

		icon.updateHitbox();
		add(icon);
    }    
    override function update(elapsed:Float) {
        super.update(elapsed);

    }
}