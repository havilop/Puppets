package game.hud;

import states.PlayState.MapHud;

class MapIconBUILDING extends MapIcon 
{
    public function new(entityy:Entity,mapp:MapHud) 
    {
        super(entityy,mapp);

        remove(icon);
		icon = new FlxSprite(0, 0).makeGraphic(20,20,FlxColor.RED);
		icon.setGraphicSize(20, 20);
		icon.updateHitbox();
		add(icon);
    }    
    override function update(elapsed:Float) {
        super.update(elapsed);
       
    }
}