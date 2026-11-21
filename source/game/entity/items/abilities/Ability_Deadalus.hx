package game.entity.items.abilities;

class Abilitiy_Deadalus extends Ability
{
	var chance:Float = 25;

	public function new()
	{
		super(true, 0, attack, 0, 0, 0, 1, false);
		this.skillpoints = 1;
	}

	override function functionSpell()
	{
		super.functionSpell();

		if (attackEntity.typeEntity == CHARACTER)
		{
			var number = FlxG.random.float(0, 100);

			

          
			if (number <= 15)
			{
                var damage = (selfEntity.damagePhysic + (selfEntity.damagePhysic * 125 / 100)) - selfEntity.damagePhysic;
				attackEntity.takeDamage(physic, damage, selfEntity);
				chance = 25;
                attackEntity.addVisualEffect(new CRIT_VisualEffect(damage));
			} else {
                chance += 1.5;
            }
		}
	}
}
class CRIT_VisualEffect extends VisualEffect
{
    var textCount:FlxText;
    var storedValue:Float = 0;
    public function new(number:Float) 
    {
        super();    

		textCount = new FlxText(0, 0, 0, '', 28);
		textCount.color = FlxColor.RED;
        textCount.font = Path.font;
        textCount.text = "" + Std.int(number);
		add(textCount);
	}

	override function update(elapsed:Float)
	{
        storedValue += elapsed;

        if (storedValue >= 1)
            selfEntity.removeVisualEffect(this);

		super.update(elapsed);

		textCount.x = selfEntity.entityHitbox.x + selfEntity.entityHitbox.width / 2;
		textCount.y = selfEntity.entityHitbox.y - 125;
	}
    
}