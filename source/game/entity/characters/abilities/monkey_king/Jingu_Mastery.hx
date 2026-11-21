package game.entity.characters.abilities.monkey_king;

import flixel.FlxG;
import flixel.util.FlxCollision;

class Jingu_Mastery extends Ability
{
	public var damage:Int = 0;

	public function new()
	{
		super(true, 325, attack, 3, 5, 100, 4, true, "assets/player/characters/monkey_king/jingu_mastery.png", false);
		super.setOptionPoint('damage', [35, 80, 135, 180]);
	}

	override function functionSpell()
	{
		super.functionSpell();

		if (!attackEntity.hasEffectType(Jingu_Mastery_Effet) && !selfEntity.hasEffectType(Jingu_Mastery_Effect))
		{
			if (attackEntity.typeEntity == CHARACTER)
				attackEntity.addEffect(new Jingu_Mastery_Effet(selfEntity, damage));
		}

		if (attackEntity.hasEffectType(Jingu_Mastery_Effet)
			&& !selfEntity.hasEffectType(Jingu_Mastery_Effect)
			&& attackEntity.typeEntity == CHARACTER)
		{
			for (i in attackEntity.effects)
			{
				if (Std.isOfType(i, Jingu_Mastery_Effet))
				{
					var w:Jingu_Mastery_Effet = cast i;
					w.damage = damage;
					w.count += 1;
					break;
				}
			}
		}

			if (selfEntity.hasEffectType(Jingu_Mastery_Effect))
		{
			for (i in selfEntity.effects)
			{
				if (Std.isOfType(i, Jingu_Mastery_Effect))
				{
					var w:Jingu_Mastery_Effect = cast i;
			
					w.count -= 1;
					break;
				}
			}
		}
		
	}
}

class Jingu_Mastery_Effet extends Effect
{
	var whogive:Entity;

	public var damage = 0;

	public function new(who:Entity, damag:Int)
	{
		super(true,Path.getPathCharacter("monkey_king","jingu_mastery.png"),"Jingu_Mastery","Hits from Monkey King");

		whogive = who;

		damage = damag;
	}

	override function activity()
	{
		setStatusEffect(NONEE, 15, function name()
		{
			selfEntity.addVisualEffect(new Jingu_Mastery_VisualEffect_DeBuff(this));
		}, function name() {
				for (w in selfEntity.visualEffects)
				{
					if (Std.isOfType(w, Jingu_Mastery_VisualEffect_DeBuff))
					{
						selfEntity.removeVisualEffect(w);
						break;
					}
				}
		}, function name(elapsed:Float)
		{
			if (count >= 4)
			{
				whogive.addEffect(new Jingu_Mastery_Effect(damage));
				for (w in selfEntity.visualEffects)
				{
					if (Std.isOfType(w, Jingu_Mastery_VisualEffect_DeBuff))
					{
						selfEntity.removeVisualEffect(w);
						break;
					}
				}
				this.removeEffect();
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class Jingu_Mastery_Effect extends Effect
{
	var damage:Int = 0;
	var functios:Void->Void;

	public function new(damag:Int)
	{
		super(true,Path.getPathCharacter("monkey_king","jingu_mastery.png"),"Jingu_Mastery","Bonus Damage and Lifesteal");

		count = 4;

		functios = function()
		{
			count--;
		}

		damage = damag;
	}

	override function activity()
	{
		setStatusEffect(NONEE, 15, function name()
		{
			Sound.playCharacter('monkey_king','jingu');
			//selfEntity.attackSomeone.add(functios);
			selfEntity.addVisualEffect(new Jingu_Mastery_VisualEffect_Buff());
			selfEntity.addFlatBonus('damagePhysic', damage);
		}, function name()
		{
			for (w in selfEntity.visualEffects)
			{
				if (Std.isOfType(w, Jingu_Mastery_VisualEffect_Buff))
				{
					selfEntity.removeVisualEffect(w);
					break;
				}
			}
			selfEntity.removeFlatBonus('damagePhysic', damage);
			//selfEntity.attackSomeone.remove(functios);
		}, function name(elapsed:Float)
		{
			if (count <= 0)
			{
				selfEntity.removeFlatBonus('damagePhysic', damage);
				//selfEntity.attackSomeone.remove(functios);
				removeEffect();
			}
		});
	}
}

class Jingu_Mastery_VisualEffect_Buff extends VisualEffect
{
	var image:FlxSprite;

	public function new()
	{
		super();

		image = new FlxSprite(0, 0, 'assets/player/characters/monkey_king/jingu.png');
		add(image);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		image.x = selfEntity.textName.x;
		image.y = selfEntity.textName.y - image.height;
	}
}

class Jingu_Mastery_VisualEffect_DeBuff extends VisualEffect
{
	var textCount:FlxText;
	var efect:Jingu_Mastery_Effet;

	public function new(effect:Jingu_Mastery_Effet)
	{
		super();

		efect = effect;

		textCount = new FlxText(0, 0, 0, '', 32);
		textCount.color = FlxColor.YELLOW;
		add(textCount);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		textCount.text = "" + efect.count;

		textCount.x = selfEntity.entityHitbox.x + 25;
		textCount.y = selfEntity.entityHitbox.y - 125;
	}
}
