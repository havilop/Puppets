package game.entity.characters.abilities.monkey_king;

import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.sound.FlxSound;
import flixel.util.FlxCollision;

class Bounderless_Strike extends Ability
{
	public var damage:Int = 0;
	public var hitboxPalka:FlxSprite;
	var sound:FlxSound;
	var turn:Bool = false;
	var crit:Int = 0;
	var stunduration:Int = 0;

	public function new()
	{
		super(false, 425, point, 0.35, 5, 100, 4, true, "assets/player/characters/monkey_king/palka.png", false);
		super.setOptionPoint('damage', [35, 80, 135, 180]);
		super.setOptionPoint('crit',[135,165,195,225]);
		super.setOptionPoint('stunduration',[1.3,1.6,1.9,2.3]);
		super.setOptionPoint('cooldown',[21,19,17,15]);
		super.setOptionPoint('manacost',[85,90,95,100]);

		sound = new FlxSound();
			sound.loadEmbedded('assets/player/characters/monkey_king/caststrike.ogg',false,true);
			
	}

	override function functionSpell()
	{
		super.functionSpell();

		hitboxPalka = new FlxSprite(0, 0);
		hitboxPalka.revive();
		hitboxPalka.makeGraphic(450, 25, FlxColor.BROWN);

		var centerX = selfEntity.entityHitbox.x + selfEntity.entityHitbox.width / 2;
		var centerY = selfEntity.entityHitbox.y + selfEntity.entityHitbox.height / 2;

		var dx = mouseX - centerX;
		var dy = mouseY - centerY;

		// Origin — левый центр палки (рукоять)
		hitboxPalka.origin.set(0, hitboxPalka.height / 2);

		// Ставим рукоять в центр персонажа
		hitboxPalka.x = centerX;
		hitboxPalka.y = centerY - hitboxPalka.height / 2;

		// Угол
		hitboxPalka.angle = Math.atan2(dy, dx) * 180 / Math.PI;

		add(hitboxPalka);

		
		FlxG.sound.play('assets/player/characters/monkey_king/palka.ogg');
		

		for (i in PlayState.groupEntities)
		{
			if (i.typeEntity != BUILDING && i.typeEntity != COURIER)
			{
				if (!i.dead && i != selfEntity && i.team != selfEntity.team)
				{
					
					if (FlxCollision.pixelPerfectCheck(i.entityHitbox,hitboxPalka))
					{
						var dmg = damage + selfEntity.damagePhysic;
						i.applieAttack(dmg + (dmg + crit / 100), selfEntity, true);
						i.addEffect(new Bounderless_Strike_Effect(stunduration));
					}
				}
			}
		}
		new FlxTimer().start(2, function(time:FlxTimer)
		{
			hitboxPalka.kill();
		}, 1);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (isOnCast && !turn)
		{
			turn = true;
			sound.play(true);
		}
		if (!isOnCast && turn)
		{
			turn = false;
			sound.pause();
		}
	}
}

class Bounderless_Strike_Effect extends Effect
{
	var dur:Int = 0;

	public function new(DURATION)
	{
		super(true,Path.getPathCharacter('monkey_king',"palka.png"),'Bounderless_Strike_Stun',"Stunned");

		dur = DURATION;
	}

	override function activity()
	{
		setStatusEffect(STUN, dur);
	}
}
