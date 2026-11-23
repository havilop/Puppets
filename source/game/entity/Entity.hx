package game.entity;

import flixel.addons.display.shapes.FlxShapeCircle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.util.FlxCollision;
import flixel.util.FlxSignal;
import game.entity.Effect.PuppetsStatusEffectEnum;
import game.entity.items.Boots;
import game.entity.items.Boots_Of_Speed;
import openfl.media.Sound;

enum PuppetsTypeDamageEnum
{
	physic;
	magic;
	pure;
}

enum PuppetsTypeAttackEnum
{
	RANGE;
	MELLE;
}

enum PuppetsTypeAttributeEnum
{
	STRENGTH;
	AGILITY;
	INTELLECT;
}

enum PuppetsTypeEntityEnum
{
	CHARACTER;
	CREEP_LINE;
	CREEP_FOREST;
	CREEP_FOREST_ANCIENT;
	WARD;
	BUILDING;
	CREEP_NEUTRAL;
	COURIER;
	SUMMONS;
	CLONES_SUMMONS;
}

class Entity extends FlxGroup
{
	var init = false;

	public var entityHitbox:FlxSprite;

	// public var entityHitbox:FlxSprite;
	public var bgBar:FlxSprite;
	public var id:Int = 0;

	public var textName:FlxText;
	public var textLevel:FlxText;
	public var isStatusEffect:Bool = false;

	public var healthBar:FlxBar;
	public var manaBar:FlxBar;

	public var playerCamera:FlxSprite;

	var hitboxMovement:FlxSprite;

	public var rangeXpHitBox:FlxShapeCircle;

	var moxx:Float = 0;
	var moyy:Float = 0;

	public var dead:Bool = false;
	public var onKilledSomeone:FlxSignal = new FlxSignal();
	public var attackSomeone:FlxSignal = new FlxSignal();

	public var respawnTime:Float = 12;

	public var currentRespawnTime:Float = 0;

	public var coins:Int = 600;
	public var kills:Int = 0;
	public var deaths:Int = 0;
	public var assists:Int = 0;

	public var killStreakLength:Int = 0;

	public var isClient:Bool = false;
	public var isSelectable:Bool = true;
	public var isSelect:Bool = false;

	public var team:PuppetsTeamEnum = neutral;
	public var typeEntity:PuppetsTypeEntityEnum = CHARACTER;
	public var name:String = "";
	public var enemy:Bool = false;

	public var rangeAttackHitBox:FlxShapeCircle;
	public var attackAble:Bool = false;
	public var typeAttack:PuppetsTypeAttackEnum = RANGE;
	public var rangeAttack:Int = 100;
	public var rangeSpeedAttack:Int = 0;
	public var intervalAttack:Float = 1.5;
	public var speedAttack:Int = 100;

	public var damagePhysic:Float = 50;
	public var damageMagic:Int = 0;

	public var evasion:Float = 0;

	public var lifeStealPhysic:Float = 50;
	public var lifeStealMagic:Float = 0;

	public var level:Int = 1;
	public var levelPoints:Int = 1;
	public var xp:Int = 0;
	public var maxXp:Int = 240;

	public var mainAttribute:PuppetsTypeAttributeEnum = STRENGTH;
	public var base_strength:Float = 1;
	public var base_agility:Float = 1;
	public var base_intellect:Float = 1;

	public var strength:Float = 1;
	public var agility:Float = 0;
	public var intellect:Float = 0;

	public var increase_strength:Float = 1;
	public var increase_agility:Float = 0;
	public var increase_intellect:Float = 0;

	public var basehealth:Float = 120;
	public var health:Float = 0;
	public var maxhealth:Int = 1;
	public var maxmana:Int = 1;
	public var mana:Float = 0;
	public var basemana:Float = 75;

	public var base_health_regeneration:Float = 1;
	public var health_regeneration:Float = 0;
	public var mana_regeneration:Float = 1;
	public var base_mana_regeneration:Float = 1;

	public var armor:Int = 0;
	public var magic_resist:Int = 25;

	public var speed:Int = 0;
	public var base_speed:Int = 200;
	public var spell_damage:Float = 0;

	public var flat_bonus_damagePhysic:Float = 0;
	public var flat_bonus_damagePhysic_list:Array<Float> = [];

	public var flat_bonus_strength:Float = 0;
	public var flat_bonus_strength_list:Array<Float> = [];

	public var flat_bonus_agility:Float = 0;
	public var flat_bonus_agility_list:Array<Float> = [];

	public var flat_bonus_intellect:Float = 0;
	public var flat_bonus_intellect_list:Array<Float> = [];

	public var flat_bonus_health_regeneration:Float = 0;
	public var flat_bonus_health_regeneration_list:Array<Float> = [];

	public var flat_bonus_mana_regeneration:Float = 0;
	public var flat_bonus_mana_regeneration_list:Array<Float> = [];

	public var flat_bonus_speed:Float = 0;
	public var flat_bonus_speed_list:Array<Float> = [];

	public var flat_bonus_maxhealth:Float = 0;
	public var flat_bonus_maxhealth_list:Array<Float> = [];

	public var flat_bonus_lifeStealPhysic:Float = 0;
	public var flat_bonus_lifeStealPhysic_list:Array<Float> = [];

	public var flat_bonus_evasion:Float = 0;
	public var flat_bonus_evasion_list:Array<Float> = [];

	public var groupAbilities:FlxTypedGroup<Ability>;

	public var groupItems:FlxTypedGroup<Item>;

	public var effects:FlxTypedGroup<Effect>;

	public var visualEffects:FlxTypedGroup<VisualEffect>;

	public var disableControl:Array<PuppetsDisableControl> = [];

	public function new()
	{
		super(0);

		new FlxTimer().start(0.1, function name(timer:FlxTimer)
		{
			if (!this.dead)
				heal(health_regeneration / 10);
		}, 0);

		new FlxTimer().start(0.1, function name(timer:FlxTimer)
		{
			if (!this.dead)
				addMana(mana_regeneration / 10);
		}, 0);

		playerCamera = new FlxSprite(0, 0, "assets/player/camera.png");
		add(playerCamera);

		bgBar = new FlxSprite(0, 0);
		add(bgBar);

		// entityHitbox = new FlxSprite(0, 0, "assets/player/hitbox.png");
		// entityHitbox.visible = true;
		// entityHitbox.immovable = true;
		// add(entityHitbox);

		entityHitbox = new FlxSprite(0, 0, "assets/player/hitboxDefault.png");
		entityHitbox.visible = true;
		entityHitbox.immovable = true;
		add(entityHitbox);

		healthBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10);
		healthBar.createGradientFilledBar([FlxColor.fromRGB(0, 140, 0), FlxColor.fromRGB(0, 255, 0), FlxColor.fromRGB(0, 140, 0)]);
		add(healthBar);

		manaBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10);
		manaBar.createColoredEmptyBar(FlxColor.fromRGB(0, 0, 80));

		manaBar.createGradientFilledBar([
			FlxColor.fromRGB(0, 0, 110),
			FlxColor.fromRGB(25, 89, 209),
			FlxColor.fromRGB(0, 0, 110)
		]);

		add(manaBar);

		textName = new FlxText(0, 0, 0, "", 20);
		textName.setFormat(Path.font, 20, FlxColor.LIME, null, OUTLINE, FlxColor.BLACK);
		add(textName);

		textLevel = new FlxText(0, 0, 0, '', 18);
		textLevel.setFormat(Path.font, 18, Color.get("xp"), null, OUTLINE, FlxColor.BLACK);
		add(textLevel);

		rangeXpHitBox = new FlxShapeCircle(0, 0, 1000, {thickness: 3, color: Color.get("xp"), capsStyle: ROUND}, FlxColor.fromRGB(255, 200, 0, 25));
		rangeXpHitBox.visible = true;
		add(rangeXpHitBox);

		rangeAttackHitBox = new FlxShapeCircle(0, 0, rangeAttack, {thickness: 3, color: FlxColor.LIME, capsStyle: ROUND}, FlxColor.fromRGB(0, 200, 0, 25));
		rangeAttackHitBox.visible = true;
		add(rangeAttackHitBox);

		groupAbilities = new FlxTypedGroup<Ability>();
		add(groupAbilities);

		groupItems = new FlxTypedGroup<Item>();
		add(groupItems);

		effects = new FlxTypedGroup<Effect>();
		effects.memberRemoved.add(function(effect:Effect)
		{
			updateHud('effects');
			for (key => i in effects)
			{
				if ((key + 1) == effects.length && i.type != NONEE)
				{
					i.visible = true;
					break;
				}
			}
		});
		add(effects);

		visualEffects = new FlxTypedGroup<VisualEffect>();
		add(visualEffects);

		init = true;
	}

	override function update(elapsed:Float)
	{
		if (dead)
		{
			currentRespawnTime += elapsed;

			if (currentRespawnTime >= respawnTime)
			{
				revive();
			}
		}

		super.update(elapsed);

		calculateWholeStatistics();

		initalizing();

		if (hasDisableControl(disable_movement))
		{
			cancelMovement();
		}

		if (isClient)
		{
			if (!PlayState.console.isEditing)
			{
				entityManagement();
			}
		}

		position();

		if (entityHitbox.velocity.x != 0 || entityHitbox.velocity.y != 0)
		{
			if (FlxG.overlap(entityHitbox, PlayState.groupSpriteColision))
				cancelMovement();
		}

		PlayState.groupEntities.forEach(function(entity:Entity)
		{
			if (entity.dead)
				return;
			if (this.dead)
				return; // ← если Я мёртв — не инициирую коллизии
			if (entity == this)
				return; // ← себя не проверяю
			FlxG.collide(entityHitbox, entity.entityHitbox);
		});

		healthBar.value = health;
		manaBar.value = mana;

		textLevel.text = level + "";
	}

	override function revive()
	{
		if (typeEntity == CHARACTER)
		{
			dead = false;
			// alive = true;

			setEntityPosition();

			entityHitbox.visible = true;
			bgBar.visible = true;
			textLevel.visible = true;
			textName.visible = true;
			healthBar.visible = true;
			manaBar.visible = true;
			effects.visible = true;

			health = maxhealth;
			mana = maxmana;

			entityHitbox.velocity.x = 0;
			entityHitbox.velocity.y = 0;
		}
		else
		{
			dead = false;

			health = maxhealth;
			mana = maxmana;

			entityHitbox.velocity.x = 0;
			entityHitbox.velocity.y = 0;
		}
	}

	override function kill()
	{
		if (typeEntity == CHARACTER)
		{
			dead = true;

			for (i in groupAbilities)
			{
				i.cancelCast();
			}

			for (i in effects)
			{
				i.removeEffect();
			}
			// alive = false;
			currentRespawnTime = 0;

			entityHitbox.visible = false;
			bgBar.visible = false;
			textLevel.visible = false;
			textName.visible = false;
			healthBar.visible = false;
			manaBar.visible = false;

			effects.visible = false;

			var table = [
				{level: 1, respawnTime: 12},
				{level: 2, respawnTime: 15},
				{level: 3, respawnTime: 18},
				{level: 4, respawnTime: 21},
				{level: 5, respawnTime: 25},
				{level: 6, respawnTime: 28},
				{level: 7, respawnTime: 31},
				{level: 8, respawnTime: 35},
				{level: 9, respawnTime: 39},
				{level: 10, respawnTime: 45}

			];

			for (i in table)
			{
				if (i.level == level)
				{
					respawnTime = i.respawnTime;
					break;
				}
			}

			deaths++;
			killStreakLength = 0;
		}
		else if (typeEntity == CREEP_LINE)
		{
			trace("sex");
			PlayState.destroyEntity(this);
		}
		else
		{
			PlayState.destroyEntity(this);
		}
	}

	public function setEntityPosition(?X:Null<Float>, ?Y:Null<Float>)
	{
		if (X != null || Y != null)
		{
			entityHitbox.x = X != null ? X : 0;
			entityHitbox.y = Y != null ? Y : 0;
		}

		if (X == null && Y == null)
		{
			FlxG.state.forEachOfType(SpawnerPlayersPuppets, function name(spawner:SpawnerPlayersPuppets)
			{
				if (team == puppets)
				{
					entityHitbox.x = spawner.x + FlxG.random.int(0, 340);
					entityHitbox.y = spawner.y + FlxG.random.int(0, 140);
				}
				if (team == people)
				{
					entityHitbox.x = 100;
					entityHitbox.y = 100;
				}
			});
		}
	}

	public function killedSomeone(entity:Entity)
	{
		onKilledSomeone.dispatch();

		if (entity.typeEntity == CHARACTER && typeEntity == CHARACTER)
		{
			kills++;
			killStreakLength++;

			if (killStreakLength >= 3)
				PlayState.setKillingStreakAnimation(this);

			coins += Std.int(((50 * entity.level) / 2) * (entity.killStreakLength == 0 ? 1 : entity.killStreakLength) + 30);
		}

		if (entity.typeEntity == CREEP_LINE && typeEntity == CHARACTER)
		{
			coins += 50;
		}

		if (entity.typeEntity == BUILDING && typeEntity == CHARACTER)
		{
			for (i in PlayState.groupEntities)
			{
				if (i.typeEntity == CHARACTER && i.team == this.team)
				{
					i.coins += 100;
				}
			}
		}

		for (entites in PlayState.groupEntities)
		{
			entites.addXpToEntities(entity);
		}
	}

	public function addXpToEntities(entity:Entity)
	{
		if (this != entity && !this.dead)
		{
			if (this.team != entity.team)
			{
				if (this.typeEntity == CHARACTER)
				{
					if (FlxG.overlap(this.rangeXpHitBox, entity.entityHitbox))
					{
						if (entity.typeEntity == CHARACTER)
							this.xp += Std.int(100 + 0.13 * (entity.xp * entity.level / 2));

						if (entity.typeEntity == CREEP_LINE)
							this.xp += 150;

						updateXp();
					}
				}
			}
		}
	}

	public function updateXp()
	{
		var table = [
			{level: 1, maxXp: 240},
			{level: 2, maxXp: 400},
			{level: 3, maxXp: 520},
			{level: 4, maxXp: 600},
			{level: 5, maxXp: 680},
			{level: 6, maxXp: 760},
			{level: 7, maxXp: 760},
			{level: 8, maxXp: 800},
			{level: 9, maxXp: 900},
			{level: 10, maxXp: 1000},
			{level: 11, maxXp: 1200},
			{level: 12, maxXp: 1300},
			{level: 13, maxXp: 1400},
			{level: 14, maxXp: 1500},
			{level: 15, maxXp: 1600},
			{level: 16, maxXp: 1700}

		];

		for (i in table)
		{
			if (i.level == level)
			{
				maxXp = i.maxXp;
				break;
			}
		}
		if (level == 12)
			maxXp = 1300;

		if (level == 13)
			maxXp = 1400;

		if (level == 14)
			maxXp = 1500;

		if (level == 15)
			maxXp = 1600;

		if (level == 16)
			maxXp = 1700;

		if (level < 30)
		{
			if (xp >= maxXp)
			{
				xp -= maxXp;
				upgradeNewLevel();
			}
		}
	}

	public function calculateWholeStatistics()
	{
		strength = (base_strength + (level - 1) * increase_strength) + flat_bonus_strength;
		agility = (base_agility + (level - 1) * increase_agility) + flat_bonus_agility;
		intellect = (base_intellect + (level - 1) * increase_intellect) + flat_bonus_intellect;

		health_regeneration = (base_health_regeneration + (0.1 * strength)) + flat_bonus_health_regeneration;
		mana_regeneration = (base_mana_regeneration + (0.05 * intellect)) + flat_bonus_mana_regeneration;

		maxhealth = Std.int(basehealth + (strength * 22) + flat_bonus_maxhealth);
		maxmana = Std.int(basemana + (12 * intellect));

		damagePhysic = 0 + flat_bonus_damagePhysic;

		lifeStealPhysic = 0 + flat_bonus_lifeStealPhysic;

		evasion = 0 + flat_bonus_evasion;

		speed = base_speed + Std.int(flat_bonus_speed);
	}

	public function addFlatBonus(Type:String, Value:Float)
	{
		var flat_bonus_field_list = Reflect.field(this, 'flat_bonus_$Type' + '_list');

		var flat_bonus_list:Array<Float> = cast flat_bonus_field_list;

		flat_bonus_list.push(Value);

		Reflect.setField(this, 'flat_bonus_$Type', 0);

		var total:Float = 0;

		for (bonus in flat_bonus_list)
		{
			total += bonus;
		}

		Reflect.setField(this, 'flat_bonus_$Type', total);
	}

	public function removeFlatBonus(Type:String, Value:Float)
	{
		var flat_bonus_field_list = Reflect.field(this, 'flat_bonus_$Type' + '_list');

		var flat_bonus_list:Array<Float> = cast flat_bonus_field_list;

		flat_bonus_list.remove(Value);

		Reflect.setField(this, 'flat_bonus_$Type', 0);

		var total:Float = 0;

		for (bonus in flat_bonus_list)
		{
			total += bonus;
		}

		Reflect.setField(this, 'flat_bonus_$Type', total);
	}

	public function addDisableControl(List:Array<PuppetsDisableControl>)
	{
		for (i in List)
		{
			disableControl.push(i);
		}
	}

	public function removeDisableControl(list:Array<PuppetsDisableControl>)
	{
		for (i in list)
		{
			disableControl.remove(i);
		}
	}

	public function hasDisableControl(type:PuppetsDisableControl):Bool
	{
		for (i in disableControl)
		{
			if (i == type)
			{
				return true;
				break;
			}
		}

		return false;
	}

	public function hasStatusEffect(type:PuppetsStatusEffectEnum):Bool
	{
		for (i in effects)
		{
			if (i.type == type)
			{
				return true;
				break;
			}
		}

		return false;
	}

	public function hasEffectType(type:Class<Dynamic>)
	{
		for (i in effects)
		{
			if (Std.isOfType(i, type))
			{
				return true;
				break;
			}
		}

		return false;
	}

	public function initalizing()
	{
		if (isClient)
			isSelectable = true;

		manaBar.setRange(0, maxmana);

		healthBar.setRange(0, maxhealth);

		if (enemy)
		{
			manaBar.visible = false;
			healthBar.createGradientFilledBar([FlxColor.fromRGB(100, 0, 0), FlxColor.RED, FlxColor.fromRGB(100, 0, 0)]);
			healthBar.createColoredEmptyBar(FlxColor.fromRGB(55, 0, 0));
			textName.color = FlxColor.RED;
		}

		if (manaBar.visible)
			bgBar.makeGraphic(Std.int((textLevel.fieldWidth + 5) + healthBar.width), Std.int(healthBar.height + manaBar.height + 5 + 6),
				FlxColor.fromRGB(30, 30, 30));
		else if (!manaBar.visible)
		{
			bgBar.makeGraphic(Std.int((textLevel.fieldWidth + 5) + healthBar.width), Std.int(healthBar.height + 6 + 2), FlxColor.fromRGB(30, 30, 30));
			bgBar.updateHitbox();
		}

		bgBar.updateHitbox();
		textName.text = name;

		if (init)
		{
			init = false;

			INIT();
		}
	}

	public function INIT()
	{
		rangeXpHitBox.visible = false;
		rangeAttackHitBox.visible = false;

		if (typeEntity == BUILDING)
		{
			manaBar.visible = false;
			textLevel.visible = false;
			textName.visible = false;

			remove(healthBar);
			healthBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 150, 10);
			add(healthBar);
		}

		revive();

		if (isClient)
		{
			PlayState.setFocusOnPlayerAndUpdateHud(this, true);
			entityHitbox.immovable = false;
		}
		attackAble = true;
	}

	public function addEffect(effect:Effect)
	{
		effect.selfEntity = this;
		effects.memberAdded.add(function(efect:Effect)
		{
			updateHud('effects');
			for (i in effects)
			{
				if (i == effect && effect.type != NONEE)
				{
					i.visible = true;
				}
				else if (i != effect && effect.type != NONEE)
				{
					i.visible = false;
				}
			}
		});
		effects.add(effect);
	}

	public function addVisualEffect(visualeffect:VisualEffect)
	{
		visualeffect.selfEntity = this;
		visualEffects.add(visualeffect);
	}

	public function removeVisualEffect(visualeffect:VisualEffect)
	{
		visualEffects.remove(visualeffect, true);
	}

	public function addItem(item:Item)
	{
		item.selfEntity = this;
		if (item.storedAbility != null)
		{
			item.setAbility(item.storedAbility, this);
		}

		if (groupItems.length == 0)
		{
			item.key = 0;
		}
		else
		{
			var table:Array<Int> = [];

			for (i in groupItems)
			{
				table.push(i.key + 1);
			}

			for (i in 0...6)
			{
				var zanyto:Bool = false;

				for (sl in table)
				{
					if ((i + 1) == sl)
					{
						zanyto = true;
						break;
					}
				}

				if (!zanyto)
				{
					item.key = (i);
					break;
				}
			}
		}

		groupItems.add(item);

		item.updateHud();

		if (item.flat_bonus != [])
		{
			for (flatbonus in item.flat_bonus)
			{
				var neww = flatbonus.split('/');
				addFlatBonus(neww[0], Std.parseFloat(neww[1]));
			}
		}
	}

	public function removeItem(item:Item)
	{
		groupItems.remove(item, true);

		item.updateHud();
		if (item.flat_bonus != [])
		{
			for (flatbonus in item.flat_bonus)
			{
				var neww = flatbonus.split('/');
				removeFlatBonus(neww[0], Std.parseFloat(neww[1]));
			}
		}
	}

	public function setAbilities(list:Array<Class<Dynamic>>)
	{
		clearAbilities();

		for (ability in list)
		{
			var abilit:Ability = Type.createInstance(ability, []);
			abilit.selfEntity = this;
			groupAbilities.add(abilit);
		}
	}

	public function addAbility(abilty:Class<Dynamic>)
	{
		var ablit:Ability = Type.createInstance(abilty, []);
		ablit.selfEntity = this;
		groupAbilities.add(ablit);
	}

	public function clearAbilities()
	{
		for (i in groupAbilities)
		{
			i.destroy();
		}

		groupAbilities.clear();
	}

	public function heal(number:Float)
	{
		health = health + number;

		if (health >= maxhealth)
			health = maxhealth;
	}

	public function addMana(number:Float)
	{
		mana = mana + number;

		if (mana >= maxmana)
			mana = maxmana;
	}

	public function takeDamage(typeDamage:PuppetsTypeDamageEnum, number:Float, ENTITYHWODEALDAMAGE:Entity)
	{
		if (typeDamage == physic)
		{
			if (!this.hasStatusEffect(ETHEREAL))
			{
				health = health - Std.int(Math.round(number));

				if (this.typeEntity != BUILDING && this.typeEntity != COURIER && this.typeEntity != WARD)
					ENTITYHWODEALDAMAGE.heal(number * (ENTITYHWODEALDAMAGE.lifeStealPhysic / 100));
			}
		}

		if (typeDamage == magic)
		{
			var damage = number + (number * ENTITYHWODEALDAMAGE.spell_damage / 100);
			health = health - Std.int(Math.round(damage - (damage * magic_resist / 100)));
		}

		if (typeDamage == pure)
			health = health - Std.int(Math.round(number));

		if (health <= 0)
		{
			if (!dead)
			{
				ENTITYHWODEALDAMAGE.killedSomeone(this);
				this.kill();
			}
		}
	}

	function entityManagement()
	{
		if (FlxG.keys.anyJustPressed([
			Data.getKey(ability1),
			Data.getKey(ability2),
			Data.getKey(ability3),
			Data.getKey(ability4),
			Data.getKey(ability5),
			Data.getKey(ability6),
			Data.getKey(item1),
			Data.getKey(item2),
			Data.getKey(item3),
			Data.getKey(item4),
			Data.getKey(item5),
			Data.getKey(item6),
		]))
		{
			var pressedKey:Int = 0;
			var pressedKeyItem:Int = 0;

			if (FlxG.keys.anyJustPressed([Data.getKey(ability1)]))
				pressedKey = 1;
			else if (FlxG.keys.anyJustPressed([Data.getKey(ability2)]))
				pressedKey = 2;
			else if (FlxG.keys.anyJustPressed([Data.getKey(ability3)]))
				pressedKey = 3;
			else if (FlxG.keys.anyJustPressed([Data.getKey(ability4)]))
				pressedKey = 4;
			else if (FlxG.keys.anyJustPressed([Data.getKey(ability5)]))
				pressedKey = 5;
			else if (FlxG.keys.anyJustPressed([Data.getKey(ability6)]))
				pressedKey = 6;

			if (FlxG.keys.anyJustPressed([Data.getKey(item1)]))
				pressedKeyItem = 1;
			else if (FlxG.keys.anyJustPressed([Data.getKey(item2)]))
				pressedKeyItem = 2;
			else if (FlxG.keys.anyJustPressed([Data.getKey(item3)]))
				pressedKeyItem = 3;
			else if (FlxG.keys.anyJustPressed([Data.getKey(item4)]))
				pressedKeyItem = 4;
			else if (FlxG.keys.anyJustPressed([Data.getKey(item5)]))
				pressedKeyItem = 5;
			else if (FlxG.keys.anyJustPressed([Data.getKey(item6)]))
				pressedKeyItem = 6;

			for (key => abilka in groupAbilities)
			{
				var canUpgrade:Bool = false;

				if (abilka.selfEntity.levelPoints != 0)
				{
					if (abilka.skillpoints != abilka.maxSkillPoints)
					{
						if (abilka.ultimate)
						{
							if (abilka.selfEntity.level >= 6 && abilka.skillpoints == 0)
							{
								canUpgrade = true;
							}
							if (abilka.selfEntity.level >= 12 && abilka.skillpoints == 1)
							{
								canUpgrade = true;
							}
							if (abilka.selfEntity.level >= 18 && abilka.skillpoints == 2)
							{
								canUpgrade = true;
							}
						}

						if (!abilka.ultimate)
						{
							canUpgrade = true;
						}
					}
				}
				else
				{
					canUpgrade = false;
				}
				if (FlxG.keys.pressed.CONTROL)
				{
					if (key == pressedKey - 1)
					{
						if (abilka.skillpoints != abilka.maxSkillPoints && canUpgrade)
						{
							abilka.upgradeAbility();
							updateHud("abilities");
						}
						break;
					}
				}
			}

			for (key => ability in groupAbilities)
			{
				if (!ability.passive && key == pressedKey - 1 && !FlxG.keys.pressed.CONTROL)
				{
					if (hasDisableControl(disable_ability) == false)
					{
						ability.useAbility();
						PlayState.setFocusOnPlayerAndUpdateHud(this);
						break;
					}
					else
					{
						PlayState.error("You in Stun or Silence");
					}
				}
			}
			for (key => item in groupItems)
			{
				if (item.storedAbility != null)
				{
					if (!item.ability.passive && item.key == pressedKeyItem - 1)
					{
						if (hasDisableControl(disable_items) == false)
						{
							item.ability.useAbility();
							PlayState.setFocusOnPlayerAndUpdateHud(this);
							break;
						}
						else
						{
							PlayState.error("You in Stun or Mute");
						}
					}
				}
			}
		}

		if (FlxG.keys.anyJustPressed([Data.getKey(attack)]))
		{
			for (entitie in PlayState.groupEntities)
			{
				if (!hasDisableControl(disable_attack))
				{
					if (entitie != this && !this.dead && entitie.team != this.team && entitie.attackAble && !entitie.dead)
					{
						if (!entitie.hasStatusEffect(ETHEREAL))
						{
							if (entitie.entityHitbox.overlapsPoint(FlxG.mouse.getWorldPosition())
								&& FlxCollision.pixelPerfectCheck(rangeAttackHitBox, entitie.entityHitbox))
							{
								entitie.applieAttack(damagePhysic, this);
								break;
							}
						}
					}
				}
				else
				{
					PlayState.error('u under ghost');
					break;
				}
			}
		}

		if (FlxG.mouse.justPressedRight && !PlayState.isOverlapsHud && !dead)
		{
			PlayState.setFocusOnPlayerAndUpdateHud(this);

			if (hasDisableControl(disable_movement) == false)
			{
				var mox = FlxG.mouse.x;
				var moy = FlxG.mouse.y;

				var dx = FlxG.mouse.x - entityHitbox.x;
				var dy = FlxG.mouse.y - entityHitbox.y;

				var distance = Math.sqrt(dx * dx + dy * dy);

				if (distance > 5)
				{
					var normDx = dx / distance;
					var normDy = dy / distance;

					entityHitbox.velocity.x = normDx * speed;
					entityHitbox.velocity.y = normDy * speed;
				}

				moxx = mox;
				moyy = moy;
			}
		}

		var dx = (entityHitbox.x) - moxx;
		var dy = (entityHitbox.y) - moyy;

		var distance = Math.sqrt(dx * dx + dy * dy);

		if (distance < 5)
		{
			cancelMovement();
		}

		if (FlxG.keys.anyJustPressed([Data.getKey(cancel)]))
		{
			cancelMovement();

			for (i in groupAbilities)
			{
				i.cancelCast();
			}
		}
	}

	public function applieAttack(number:Float, hwodeals:Entity, ?trueStrike:Bool)
	{
		function attackFunction()
		{
			for (i in hwodeals.groupAbilities)
			{
				if (i.typeAbility == attack)
				{
					i.attackEntity = this;
					i.activatePassive();
				}
			}

			for (i in hwodeals.groupItems)
			{
				if (i.ability.typeAbility == attack)
				{
					i.ability.attackEntity = this;
					i.ability.activatePassive();
				}
			}

			takeDamage(physic, number, hwodeals);

			hwodeals.attackSomeone.dispatch();
		}
		if (trueStrike == true)
		{
			attackFunction();
		}
		else
		{
			var random = FlxG.random.int(1, 100);

			if (random <= evasion)
			{
				this.addVisualEffect(new VisualEffect_Attack_Missed());
			}
			else
			{
				attackFunction();
			}
		}
	}

	function position()
	{
		// entityHitbox.y = entityHitbox.y - entityHitbox.height + entityHitbox.height;
		// entityHitbox.x = entityHitbox.x - entityHitbox.width + entityHitbox.width;

		rangeXpHitBox.x = entityHitbox.x - rangeXpHitBox.radius + (entityHitbox.width / 2);
		rangeXpHitBox.y = entityHitbox.y - rangeXpHitBox.radius + (entityHitbox.height / 2);

		rangeAttackHitBox.x = entityHitbox.x - rangeAttackHitBox.radius + (entityHitbox.width / 2);
		rangeAttackHitBox.y = entityHitbox.y - rangeAttackHitBox.radius + (entityHitbox.height / 2);

		textName.x = entityHitbox.x - (textName.fieldWidth / 2) + (entityHitbox.width / 2);

		if (!manaBar.visible)
		{
			textLevel.y = entityHitbox.y - 37;
		}
		else
		{
			textLevel.y = entityHitbox.y - 31;
		}

		if (!isStatusEffect)
		{
			textName.y = entityHitbox.y - 31 - textName.fieldHeight - 5;
		}
		if (isStatusEffect)
		{
			textName.y = entityHitbox.y - 46 - 15 - 5 - 25 - 2;
		}

		playerCamera.x = entityHitbox.x + (entityHitbox.width - playerCamera.width) / 2;
		playerCamera.y = entityHitbox.y + (entityHitbox.height - playerCamera.height) / 2;

		healthBar.x = entityHitbox.x + (entityHitbox.width - healthBar.width) / 2;
		healthBar.y = entityHitbox.y - 31;

		manaBar.x = entityHitbox.x + (entityHitbox.width - healthBar.width) / 2;
		manaBar.y = entityHitbox.y - 16;

		textLevel.x = healthBar.x - textLevel.fieldWidth - 2;

		bgBar.x = textLevel.x;

		if (manaBar.visible)
			bgBar.y = textLevel.y - 3;

		if (!manaBar.visible)
			bgBar.y = textLevel.y + 2;
	}

	public function cancelMovement()
	{
		entityHitbox.velocity.x = 0;
		entityHitbox.velocity.y = 0;
	}

	public function upgradeNewLevel()
	{
		level++;
		levelPoints++;

		updateXp();
	}

	public function updateHud(?WHAT:String)
	{
		if (PlayState.clientSelfEntity == this)
			PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true, WHAT);

		if (PlayState.selfEntity == this)
			PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true, WHAT);
	}

	public function removeAllTypeEffectsFromPerson(Classs:Class<Dynamic>)
	{
		for (i in effects)
		{
			trace(i);
			i.removeEffect();
		}
	}
}
class VisualEffect_Attack_Missed extends VisualEffect
{
	var text:FlxText;
	var stored:Float = 0;

	public function new()
	{
		super();

		text = new FlxText(0, 0, 0, 'missed', 12);
		text.color = FlxColor.GRAY;
		text.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(text);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		stored += elapsed;

		if (stored >= 1.24)
		{
			selfEntity.removeVisualEffect(this);
		}

		text.x = selfEntity.entityHitbox.x + selfEntity.entityHitbox.width + 15;
		text.y = selfEntity.entityHitbox.y;
	}
}