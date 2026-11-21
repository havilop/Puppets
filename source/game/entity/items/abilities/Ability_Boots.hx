package game.entity.items.abilities;

import flixel.FlxG;
import flixel.util.FlxCollision;

class Ability_Boots extends Ability
{
	public function new()
	{
		super(false, 325, non_directional_aura, 3, 5, 100, 1, false, "assets/player/characters/necrophos/aura.png");
		this.skillpoints = 1;
		//setUpdate(0.5);
	}

	override function functionSpell()
	{
		super.functionSpell();

		item.removeItem();

	}
}