package game.entity.characters.abilities.necrophos;

import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxCollision;

class Death_Pulse extends Ability
{
	var heal:Int = 0;
	var damage:Int = 0;
	var isCall = false;

	public function new()
	{
		super(false, 250, non_directional_aura, 0, 0, 0, 4, false, "assets/player/characters/necrophos/death_pulse.png");
		this.description = "The hero releases the skulls on enemy and deals damage, and heal himself";
		super.setOptionPoint("range", [250, 300, 325, 340]);
		super.setOptionPoint("cooldown", [0, 7, 6, 5]);
		super.setOptionPoint("manacost", [115, 130, 145, 160]);
		super.setOptionPoint("damage", [150, 200, 250, 300]);
		super.setOptionPoint("heal", [100, 125, 150, 180]);

		// super.updateOptionsPoints();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		this.forEachOfType(Skull, function(skull:Skull) {
            if (!skull.alive)
            {

            
            skull.destroy();
			this.remove(skull, true);

            }
        });

	}

	override function functionSpell()
	{
		selfEntity.heal(heal);
		Sound.playCharacter('necrophos','death_pulse');

		PlayState.groupEntities.forEachAlive(function(player:Entity)
		{
			if (player.typeEntity != BUILDING && player.typeEntity != COURIER)
			{
				if (player != selfEntity && player.team != selfEntity.team && !player.dead)
				{
					if (FlxCollision.pixelPerfectCheck(rangeHitBox, player.entityHitbox))
					{
						var skull = new Skull(selfEntity.entityHitbox.x, selfEntity.entityHitbox.y, player, damage, selfEntity);
						add(skull);

						
					}
				}
			}
		});
	}
}

class Skull extends FlxSprite
{
	var player:Entity;
	var damage:Float = 0;
	var selfEntity:Entity;

	public function new(X:Float, Y:Float, PLAYER:Entity, Damage:Float, selfEntityy:Entity)
	{
		super(X, Y);
		player = PLAYER;
		damage = Damage;
		selfEntity = selfEntityy;
		this.loadGraphic("assets/player/characters/necrophos/skull.png");
		this.setGraphicSize(42, 42);
		this.updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var angle:Float = Math.atan2(this.player.entityHitbox.y - this.y, this.player.entityHitbox.x - this.x);
		this.velocity.x = Math.cos(angle) * 400;
		this.velocity.y = Math.sin(angle) * 400;

		if (this.overlaps(this.player.entityHitbox))
		{
			this.player.takeDamage(magic, damage, selfEntity);
			this.kill();
		}
	}
}
