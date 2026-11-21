package game.entity.items.abilities;

import flixel.FlxG;
import flixel.util.FlxCollision;

class Ability_Radiance extends Ability
{
	public function new()
	{
		super(true, 400, non_directional_aura, 3, 5, 0, 1, false, "assets/player/characters/necrophos/aura.png");
		this.skillpoints = 1;
		setUpdate(1);
	}

	override function functionSpell()
	{
		PlayState.groupEntities.forEachAlive(function(player:Entity)
		{
			if (player.typeEntity == CHARACTER)
			{
				if (player != selfEntity && player.team != selfEntity.team && !player.dead)
				{
					if (FlxCollision.pixelPerfectCheck(rangeHitBox, player.entityHitbox))
					{
						player.takeDamage(magic, 60, selfEntity);
					}
				}
			}
		});

		
	}
}