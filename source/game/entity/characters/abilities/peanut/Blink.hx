package game.entity.characters.abilities.peanut;

class Blink extends Ability
{
	public function new()
	{
		super(false, 0, null, 0, 15, 0, 1, false);
	}

	override function functionSpell()
	{
		super.functionSpell();

		if (!selfEntity.hasEffectType(Blink_Effect))
			selfEntity.addEffect(new Blink_Effect());
		else if (selfEntity.hasEffectType(Blink_Effect))
		{
			for (i in selfEntity.effects)
			{
				if (Std.isOfType(i, Blink_Effect))
				{
					var w:Blink_Effect = cast i;
					w.removeEffect();
					break;
				}
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}

class Blink_Effect extends Effect
{
	var text:FlxText;
	var storedtime:Float = 0;

	public function new()
	{
		super(false);
		text = new FlxText(0, 0, 0, '', 16);
		text.screenCenter(XY);
		text.camera = PlayState.cameraHud;
		add(text);
	}

	override function activity()
	{
		setStatusEffect(ROOT, 50, function name() {}, function name() {}, function name(elapsed:Float)
		{
			if (storedtime <= 2.5)
				storedtime += elapsed;

			text.text = (2.5 - storedtime) + "";
			var iskill:Bool = false;

			if (storedtime >= 2.5)
			{
				if (selfEntity.isClient)
				{
					if (FlxG.mouse.justPressedRight)
					{
						for (player in PlayState.groupEntities)
						{
							if (player.typeEntity == CHARACTER && !player.dead && player.team != selfEntity.team)
							{
								if (player.entityHitbox.overlapsPoint(FlxG.mouse.getWorldPosition()))
								{
                                   
                                     var random =  FlxG.random.int(1,3);
                                   
									Sound.playCharacter("peanut", "dead" + random);
									player.takeDamage(pure, player.health, selfEntity);
									iskill = true;

									break;
								}
							}
						}

						selfEntity.setEntityPosition(FlxG.mouse.x, FlxG.mouse.y);
						if (!iskill)
							Sound.playCharacter("peanut", "teleport");
						storedtime = 0;
					}
				}
			}
		}, true);
	}
}
