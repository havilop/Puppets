package game.entity;

import game.entity.characters.abilities.BaseAbility;
import game.entity.characters.abilities.monkey_king.Jingu_Mastery;

class Item extends FlxGroup
{
	public var ability:Ability = new BaseAbility();
	public var flat_bonus:Array<String> = []; // ["speed/50"]
	public var icon:String = "";
	public var cost:Int = 0;
	public var selfEntity:Entity;
	public var init:Bool = false;
	public var key:Int = 0;
	public var count:Int = 0;

	public var storedAbility:Class<Dynamic>;

	public function new(Icon:String, Flat_Bonus:Array<String>, Abilityy:Class<Dynamic>, Cost:Int)
	{
		super();

		if (Icon == null)
		{
			icon = "assets/player/items/ability_null.png";
		} else {
            icon = Icon;
        }

		flat_bonus = Flat_Bonus;
		cost = Cost;

		storedAbility = Abilityy;

		// init = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	public function removeItem()
	{
		selfEntity.removeItem(this);
	}

	public function setAbility(a:Class<Dynamic>, entity:Entity)
	{
		var abilit:Ability = Type.createInstance(a, []);
		abilit.selfEntity = entity;
		abilit.item = this;
		ability = abilit;

		add(abilit);
	}

	public function updateHud()
	{
		if (PlayState.clientSelfEntity == selfEntity)
			PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true, 'items');

		if (PlayState.selfEntity == selfEntity)
			PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true, 'items');
	}
}
