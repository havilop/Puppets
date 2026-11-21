package game.entity;

import flixel.math.FlxPoint;
import flixel.util.FlxCollision;
import haxe.macro.ComplexTypeTools;
import sys.FileSystem;

enum PuppetsAbilityTypeEnum
{
	point;
	non_directional;
	non_directional_aura;
	directional_entity;
	directional_entity_enemy;
	directional_entity_alias;
	directional_entity_enemy_character;
	directional_entity_aliis_character;
	directional_entity_character;
	attack;
}

class Ability extends FlxGroup
{
	public var icon:String = "assets/player/hud/ability_null.png";
	public var description:String = "";
	public var manacost:Int = 0;
	public var maxSkillPoints:Int = 0;

	var init = false;

	public var skillpoints:Int = 0;
	public var cooldown:Float = 0;
	public var passive:Bool = false;
	public var typeAbility:PuppetsAbilityTypeEnum;
	public var item:Item;

	public var castTime:Float = 0;
	public var castTimeStored:Float = 0;
	public var isBreakble = false;
	public var isOnCast = false;
	public var ultimate:Bool = false;
	public var rangeHitBox:FlxShapeCircle;
	public var isupdaterangehitbox:Bool = false;
	public var range:Float = 1;
	public var isUsed:Bool = false;

	var timer:Float = 0;
	var time:Float = 0;

	public var isUpdatbleAbility:Bool = false;

	public var IGNORECAST:Bool = false;

	public var coolDownTimer:Float = 0;
	public var isOnCoolDown:Bool = false;

	public var selfEntity:Entity;
	public var enemyEntity:Entity;
	public var justEntity:Entity;
	public var aliasEntity:Entity;
	public var attackEntity:Entity;
	public var mouseX:Float;
	public var mouseY:Float;
	public var storedOptionsPoints:Array<String> = [];

	public function new(?Passive:Bool, ?Range:Float, ?TypeAbility:PuppetsAbilityTypeEnum, ?CastTime:Float, ?CoolDown:Float, ?ManaCost:Int,
			?MaxSkillPoints:Int, ?IsBreakble:Bool, ?Icon:String, ?Ultimate:Bool)
	{
		super();

		passive = Passive;

		range = Range;

		typeAbility = TypeAbility;

		maxSkillPoints = MaxSkillPoints;

		castTime = CastTime;

		cooldown = CoolDown;

		manacost = ManaCost;

		maxSkillPoints = MaxSkillPoints;

		isBreakble = IsBreakble;
		if (Ultimate == null)
		{
			ultimate = false;
		}

		if (Ultimate != null)
		{
			ultimate = Ultimate;
		}

		if (Icon == null)
		{
			icon = "assets/player/hud/ability_null.png";
		}
		if (Icon != null)
		{
			
			if (FileSystem.exists(Icon))
				icon = Icon;

			if (!FileSystem.exists(Icon))
				icon = "assets/player/hud/ability_null.png";
		}


		rangeHitBox = new FlxShapeCircle(0, 0, Range, {thickness: 3, color: FlxColor.GREEN, capsStyle: ROUND}, FlxColor.fromRGB(0, 255, 0, 25));
		rangeHitBox.visible = true;
		add(rangeHitBox);

		isupdaterangehitbox = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		isUsed = false;

		if (isOnCoolDown)
		{
			coolDownTimer -= elapsed;

			if (coolDownTimer <= 0)
			{
				coolDownTimer = 0;
				isOnCoolDown = false;
			}
		}

		if (isOnCast)
		{
			castTimeStored -= elapsed;

			if (castTimeStored <= 0)
			{
				functionSpell();
				clearActivity();
				selfEntity.removeDisableControl([disable_movement, disable_ability, disable_attack, disable_items]);
				castTimeStored = 0;
				isOnCast = false;
			}
		}

		if (selfEntity.hasDisableControl(disable_ability) == true && IGNORECAST)
		{
			cancelCast();
			IGNORECAST = false;
		}

		if (isupdaterangehitbox)
		{
			updateRangeHitbox();
			isupdaterangehitbox = false;
		}
		if (!selfEntity.dead)
		{
			if (enemyEntity != null)
			{
				if (enemyEntity.dead == true && isOnCast)
				{
					this.cancelCast();
				}
			}

			if (passive && isUpdatbleAbility)
			{
				timer += elapsed;

				if (timer >= time)
				{
					timer = 0;

					if (skillpoints != 0)
					{
						if (isBreakble == false)
						{
							functionSpell();
						}
						if (isBreakble == true)
						{
							if (selfEntity.hasDisableControl(disable_passive_abilties) == false)
							{
								functionSpell();
							}
						}
					}
				}
			}
		}
		rangeHitBox.x = selfEntity.entityHitbox.x - range + (selfEntity.entityHitbox.width / 2);
		rangeHitBox.y = selfEntity.entityHitbox.y - range + (selfEntity.entityHitbox.height / 2);
	}

	public function updateOptionsPoints()
	{
		for (option in storedOptionsPoints)
		{
			var op = option.split('/');
			Reflect.setField(this, op[0], op[skillpoints]);

			if (op[0] == "range")
				updateRangeHitbox();
		}
	}

	public function updateRangeHitbox()
	{
		rangeHitBox.radius = range;

		rangeHitBox.redrawShape();

		rangeHitBox.visible = false;

		rangeHitBox.x = selfEntity.entityHitbox.x - range + (selfEntity.entityHitbox.width / 2);
		rangeHitBox.y = selfEntity.entityHitbox.y - range + (selfEntity.entityHitbox.height / 2);
	}

	function clearActivity()
	{
		selfEntity.mana = selfEntity.mana - manacost;
		coolDownTimer = cooldown;
		isOnCoolDown = true;
	}

	public function addSignals() {}

	public function activity()
	{
		if (typeAbility == directional_entity_enemy_character)
		{
			for (player in PlayState.groupEntities)
			{
				if (player.typeEntity == CHARACTER)
				{
					if (player != selfEntity && player.team != selfEntity.team && !player.dead)
					{
						if (FlxCollision.pixelPerfectCheck(rangeHitBox, player.entityHitbox)
							&& player.entityHitbox.overlapsPoint(FlxG.mouse.getWorldPosition()))
						{
							enemyEntity = player;
							if (castTime <= 0)
							{
								functionSpell();
								clearActivity();
								break;
							}
							else
							{
								if (isOnCast == false)
								{
									selfEntity.addDisableControl([disable_movement, disable_ability, disable_attack, disable_items]);
									castTimeStored = castTime;
									isOnCast = true;
									break;
								}
							}
						}
					
					}
				}
			}
		}
		else if (typeAbility == point)
		{
			if (rangeHitBox.overlapsPoint(FlxG.mouse.getWorldPosition()))
			{
				mouseX = FlxG.mouse.x;
				mouseY = FlxG.mouse.y;
				if (castTime <= 0)
				{
					functionSpell();
					clearActivity();
				}
				else
				{
					if (isOnCast == false)
					{
						selfEntity.addDisableControl([disable_movement, disable_ability, disable_attack, disable_items]);
						castTimeStored = castTime;
						isOnCast = true;
					}
				}
			}
			else
			{
				PlayState.error("U are under Circle");
			}
		}
		else
		{
			if (castTime <= 0)
			{
				functionSpell();
				clearActivity();
			}
			else
			{
				if (isOnCast == false)
				{
					selfEntity.addDisableControl([disable_movement, disable_ability, disable_attack, disable_items]);
					castTimeStored = castTime;
					isOnCast = true;
				}
			}
		}
	}

	public function activatePassive()
	{
		if (!selfEntity.dead)
		{
			if (passive)
			{
				if (skillpoints != 0)
				{
					if (isBreakble == false)
					{
						functionSpell();
					}
					if (isBreakble == true)
					{
						if (selfEntity.hasDisableControl(disable_passive_abilties) == false)
						{
							functionSpell();
						}
					}
				}
			}
		}
	}

	public function functionSpell()
	{
		isUsed = true;
	}

	public function useAbility()
	{
		if (!selfEntity.dead)
		{
			if (skillpoints != 0)
			{
				if (coolDownTimer == 0)
				{
					if (selfEntity.mana >= manacost)
					{
						activity();
					}
					else
					{
						PlayState.error("Not enough mana");
					}
				}
				else
				{
					PlayState.error("Ability is on cooldown");
				}
			}
			else
			{
				PlayState.error("Ability is not upgrade");
			}
		}
		else
		{
			PlayState.error("You Dead!");
		}
	}

	public function setUpdate(Time:Float)
	{
		time = Time;
		isUpdatbleAbility = true;
	}

	public function setOptionPoint(Name:String, List:Array<Float>)
	{
		for (field in Reflect.fields(this))
		{
			if (field == Name)
			{
				var storedtext = "";

				for (i in List)
				{
					storedtext = storedtext + '/$i';
				}
				storedOptionsPoints.push('$Name' + storedtext);
				break;
			}
		}
	}

	public function upgradeAbility()
	{
		selfEntity.levelPoints--;
		skillpoints += 1;
		updateOptionsPoints();
	}

	public function cancelCast()
	{
		if (isOnCast == true)
		{
			selfEntity.removeDisableControl([disable_movement, disable_ability, disable_attack, disable_items]);
			isOnCast = false;
			castTimeStored = 0;
		}
	}
}
