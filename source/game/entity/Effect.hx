package game.entity;

enum PuppetsStatusEffectEnum
{
	STUN;
	SILENCE;
	BREAK;
	MUTE;
	HEX;
	ROOT;
	ETHEREAL;
	SLOW;
	NONEE;
}

enum PuppetsDisableControl
{
	disable_movement;
	disable_attack;
	disable_ability;
	disable_items;
	disable_passive_abilties;
}

class Effect extends FlxGroup
{
	public var statusBar:FlxBar;
	public var textStatusBar:FlxText;
	public var type:PuppetsStatusEffectEnum;

	public var icon:String;
	public var name:String;
	public var description:String;

	public var selfEntity:Entity;
	public var onBegin:Void->Void;
	public var onEnd:Void->Void;
	public var onUpdate:Float->Void;
	public var timeStatusEffectDefault:Float = 0;
	public var timeStatusEffectDefaultStored:Float = 0;
	public var isStatusEffect:Bool = false;
	public var infintyTime:Bool = false;
	public var dispellable:Bool = false;
	public var good:Bool = false;

	public var count:Int = 0;

	var init:Bool = false;
	var isAddedStatusEffect:Bool = false;
	var isEndStatusEffect:Bool = false;

	public var listDisableControl:Array<PuppetsDisableControl> = [];

	public function new(IsDefaultStatusEffect:Bool, ?Icon:String, ?Name:String, ?Description:String, ?Good:Bool, ?Dispellable:Bool)
	{
		super();
		isStatusEffect = IsDefaultStatusEffect;

		if (Icon == null)
		{
			icon = Path.null_icon;
		} else {
			icon = Icon;
		}

		if (Dispellable == null)
		{
			dispellable = false;
		}
		else
		{
			dispellable = Dispellable;
		}

		name = "" + Name;

		description = "" + Description;

		if (Good == null)
		{
			good = false;
		}
		else
		{
			good = Good;
		}

		statusBar = new FlxBar(0, 0, LEFT_TO_RIGHT, 100, 10);
		statusBar.createColoredFilledBar(FlxColor.fromRGB(100, 100, 100, 255));
		statusBar.createColoredEmptyBar(FlxColor.fromRGB(50, 50, 50, 255));
		statusBar.setRange(0, 5);
		statusBar.visible = false;
		statusBar.value = 3.2;

		add(statusBar);

		textStatusBar = new FlxText(0, 0, 0, '', 8);
		textStatusBar.setFormat(Path.font, 16, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.GRAY);
		textStatusBar.visible = false;
		add(textStatusBar);

		init = true;
	}

	override function update(elapsed:Float)
	{
		if (isAddedStatusEffect)
		{
			if (!isEndStatusEffect)
			{
				if (!infintyTime)
					timeStatusEffectDefaultStored += elapsed;

				if (onUpdate != null)
				{
					onUpdate(elapsed);
				}

				if (type != NONEE)
				{
					selfEntity.isStatusEffect = true;
				}

				if (!infintyTime)
					statusBar.value = timeStatusEffectDefault - timeStatusEffectDefaultStored;

				if (!infintyTime)
				{
					if (timeStatusEffectDefaultStored >= timeStatusEffectDefault)
					{
						statusBar.visible = false;
						textStatusBar.visible = false;

						removeEffect();
						
					}
				}
			}

			statusBar.x =  selfEntity.entityHitbox.x + (selfEntity.entityHitbox.width - statusBar.width) / 2;
			statusBar.y = selfEntity.entityHitbox.y - 45;

			textStatusBar.x = selfEntity.entityHitbox.x + (selfEntity.entityHitbox.width - statusBar.width) / 2 - (textStatusBar.fieldWidth / 2) + (statusBar.width / 2);
			textStatusBar.y = selfEntity.entityHitbox.y - 46 - textStatusBar.fieldHeight - 3;
		}

		super.update(elapsed);

		if (init)
		{
			activity();
			if (onBegin != null)
			{
				onBegin();
			}
			if (type == NONEE)
			{
				selfEntity.isStatusEffect = false;
			}
			else if (type == STUN)
			{
				for (i in selfEntity.groupAbilities)
				{
					i.IGNORECAST = true;
				}
			}
			else
			{
				selfEntity.isStatusEffect = true;
			}

			init = false;
		}
	}

	public function setStatusEffect(Name:PuppetsStatusEffectEnum, Time:Float, ?OnBegin:Void->Void, ?OnEnd:Void->Void, ?OnUpdate:Float->Void, ?InfinityTime:Bool)
	{
		if (InfinityTime == null)
		{
			infintyTime = false;
		}
		else
		{
			infintyTime = InfinityTime;
		}

		timeStatusEffectDefault = Time;
		isAddedStatusEffect = true;
		isEndStatusEffect = false;

		if (infintyTime == true)
		{
			statusBar.visible = false;
			textStatusBar.visible = true;
		}
		else
		{
			statusBar.visible = true;
			textStatusBar.visible = true;
		}

		type = Name;

		onEnd = OnEnd;
		onBegin = OnBegin;
		onUpdate = OnUpdate;

		if (Name == STUN)
		{
			textStatusBar.text = "STUNNED";
			listDisableControl = [disable_movement, disable_ability, disable_attack, disable_items];
		}
		if (Name == BREAK)
		{
			textStatusBar.text = "BREAK";
			listDisableControl = [disable_passive_abilties];
		}
		if (Name == ETHEREAL)
		{
			textStatusBar.text = "ETHEREAL";
			listDisableControl = [disable_attack];
		}
		if (Name == ROOT)
		{
			textStatusBar.text = "ROOT";
			listDisableControl = [disable_movement];
		}

		if (Name == NONEE)
		{
			statusBar.visible = false;
			textStatusBar.visible = false;
			listDisableControl = [];
		}

		selfEntity.addDisableControl(listDisableControl);
		statusBar.setRange(0, timeStatusEffectDefault);
	}

	public function clearStatusEffect()
	{
		statusBar.visible = false;
		textStatusBar.visible = false;

		timeStatusEffectDefault = 0;
		timeStatusEffectDefaultStored = 0;

		isAddedStatusEffect = false;
		isEndStatusEffect = true;
	}

	public function removeEffect()
	{
		if (onEnd != null)
		{
			onEnd();
		}

		selfEntity.isStatusEffect = false;
		selfEntity.removeDisableControl(listDisableControl);

		selfEntity.effects.remove(this, true);
	}

	public function activity()
	{
		// removeEffect();
	}
}
