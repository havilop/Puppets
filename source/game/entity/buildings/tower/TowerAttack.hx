package game.entity.buildings.tower;

import flixel.util.FlxCollision;

class TowerAttack extends Ability
{
	public function new()
	{
		super(true, 500, non_directional_aura, 0, 0, 0, 1, false);
		this.skillpoints = 1;
		this.setUpdate(2);
	}

	override function functionSpell()
	{
		super.functionSpell();

		for (player in PlayState.groupEntities)
		{
			if (player.typeEntity == CHARACTER || player.typeEntity == PuppetsTypeEntityEnum.CREEP_LINE)
			{
				if (player != selfEntity && player.team != selfEntity.team && !player.dead && player.attackAble)
				{
					if (!player.hasStatusEffect(ETHEREAL))
					{
						if (FlxCollision.pixelPerfectCheck(rangeHitBox, player.entityHitbox))
						{
							var p = new TowerAttackProjectile(selfEntity.entityHitbox.x, selfEntity.entityHitbox.y, player, 90, selfEntity);
							add(p);
							break;
						}
					}
				}
			}
		}
	}
}

class TowerAttackProjectile extends FlxSprite
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

		this.x = X + (selfEntity.entityHitbox.width - this.width) / 2;
		this.y = Y + (selfEntity.entityHitbox.height - this.height) / 2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var angle:Float = Math.atan2(this.player.entityHitbox.y - this.y, this.player.entityHitbox.x - this.x);
		this.velocity.x = Math.cos(angle) * 400;
		this.velocity.y = Math.sin(angle) * 400;

		if (this.overlaps(this.player.entityHitbox))
		{
			this.player.applieAttack(damage, selfEntity);
			this.destroy();
		}
	}
}
