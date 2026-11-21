package game.entity.items.abilities;

class Ability_Blink_Dagger extends Ability
{
	var chance:Float = 25;

	public function new()
	{
		super(false, 500, point, 0, 15, 0, 1, false);
		this.skillpoints = 1;
	}

	override function functionSpell()
	{
		super.functionSpell();

		selfEntity.setEntityPosition(mouseX,mouseY);
	}
}
