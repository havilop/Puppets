package game.entity.characters.abilities.peanut;

class Shit extends Ability
{
	public function new()
	{
		super(false, 0, null, 0, 30, 0, 1, false);
	}

	override function functionSpell()
	{
		super.functionSpell();

		Sound.playCharacter("peanut",'poop');
	}
}
