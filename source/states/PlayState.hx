package states;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxRect;
import flixel.system.debug.FlxDebugger;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar.FlxBarFillDirection;
import game.entity.buildings.tower.Tower;
import game.entity.items.Blink_Dagger;
import game.entity.items.Boots;
import game.entity.items.Boots_Of_Speed;
import game.entity.items.Deadalus;
import game.entity.items.Radiance;
import openfl.display.BitmapData;
import openfl.system.System;
import sys.FileSystem;

enum PuppetsTeamEnum
{
	puppets;
	people;
	neutral;
}

class PlayState extends PuppetsState
{

	public static var mapPath:String = "assets/maps/1.0.json";

	public static var cameraHud:FlxCamera;
	public static var groupHud:FlxGroup;

	public static var centerHud:FlxSprite;
	public static var itemsBgHud:FlxSprite;
	public static var leftHud:FlxSprite;
	public static var rightHud:FlxSprite;
	public static var storeHud:StoreHud;
	public static var mapHud:MapHud;
	public static var upItemsHud:UpItemHud;
	public static var effectsHud:FlxSpriteGroup;

	public static var textNameCharacter:FlxText;

	public static var healthBarHud:FlxBar;
	public static var manaBarHud:FlxBar;

	public static var xpBarHud:FlxBar;
	public static var textLevelHud:FlxText;

	public static var textHealthHud:FlxText;
	public static var textManaHud:FlxText;

	public static var textRegenHealthHud:FlxText;
	public static var textRegenManaHud:FlxText;

	public static var textCoins:FlxText;
	public static var imageCoins:FlxSprite;
	public static var buttonOpenStore:PuppetsButton;

	public static var textPlayerStats:FlxText;
	public static var textRespawnTime:FlxText;

	public static var textKillStreak:FlxText;
	public static var timerKillStreak:FlxTimer;

	public static var abilitiesHud:FlxSpriteGroup;
	public static var itemsHud:FlxSpriteGroup;
	public static var setUpdateAbilities:Bool = false;

	public static var textStat:StatText;
	public static var console:Console;

	public static var groupSpriteColision:FlxSpriteGroup;

	public static var groupSpriteMap:FlxSpriteGroup;

	public static var groupEntities:FlxTypedGroup<Entity>;

	public static var groupAllEntitiesVisualAbilities:FlxSpriteGroup;

	public static var selfEntity:Entity;
	public static var clientSelfEntity:Entity;

	public static var isDraggingItem:Bool = false;
	public static var choosenItemSprite:FlxSprite;
	public static var isOverlapsHud:Bool = false;

	// public static var selfEntites:Array<Entity> = [];
	public static var isInitialized:Bool = false;

	public static var isInitJust:Bool = false;

	var selectBox:FlxSprite;
	var isPressedSelectBox:Bool = false;

	var selectBoxX:Float;
	var selectBoxY:Float;

	var isDraggingCamera:Bool = false;

	var dragStartX:Float = 0;
	var dragStartY:Float = 0;

	var cameraStartX:Float = 0;
	var cameraStartY:Float = 0;

	override public function create()
	{
		cameraHud = new FlxCamera(0, 0, FlxG.width, FlxG.height);
		cameraHud.bgColor = 0x00000000;

		FlxG.cameras.add(cameraHud, false);

		applieWorldSettings();
		loadMap();

		groupEntities = new FlxTypedGroup<Entity>();
		groupEntities.memberAdded.add(function(entity:Entity)
		{
			if (entity.typeEntity == CHARACTER)
			{
				upItemsHud.updateHud();
				mapHud.addIcon(entity);
			}
			for (key => player in groupEntities)
			{
				if (player.isClient)
				{
					var currentPlayerIndex = key;

					var currentPlayer = groupEntities.members[key];

					var lastPlayer = groupEntities.members[groupEntities.members.length - 1];

					groupEntities.members[currentPlayerIndex] = lastPlayer;

					groupEntities.members[groupEntities.members.length - 1] = currentPlayer;

					clientSelfEntity = currentPlayer;
				}
			}

			if (clientSelfEntity != null)
			{
				updateVisualForEnemy();
			}
		});
		add(groupEntities);

		groupAllEntitiesVisualAbilities = new FlxSpriteGroup();
		add(groupAllEntitiesVisualAbilities);

		isInitialized = true;

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ONE)
		{
			addPlayer("Monkey_King", people, true);
		}

		if (FlxG.keys.justPressed.THREE)
		{
			addPlayer("Monkey_King", people, false);
		}
		if (FlxG.keys.justPressed.TWO)
		{
			addPlayer("Monkey_King", puppets, false);

			groupEntities.add(new Tower());
		}

		initializedJust();

		initializedUpdate();

		updateHudValues();

		keyBoardControl();

		mouseScroll();

		selectBoxFunction();
	}

	override function destroy()
	{
		super.destroy();

		cameraHud.destroy();

		selfEntity = null;
		clientSelfEntity = null;
		isInitialized = false;
		isInitJust = false;
	}

	public static function destroyEntity(entity:Entity)
	{
		entity.destroy();
		groupEntities.remove(entity, true);
	}

	public static function updateHud(?WHAT:String)
	{
		function updateabilities()
		{
			for (i in abilitiesHud)
			{
				i.destroy();
			}

			abilitiesHud.clear();

			for (key => ability in selfEntity.groupAbilities)
			{
				var abilityVisual = new AbilityHud(ability, key);

				abilityVisual.x = (key * 70);
				abilitiesHud.add(abilityVisual);
			}

			abilitiesHud.x = (FlxG.width - ((70 * abilitiesHud.length) - 10)) / 2;
		}
		function updateitems()
		{
			for (i in itemsHud)
			{
				i.destroy();
			}

			itemsHud.clear();

			for (item in selfEntity.groupItems)
			{
				var abilityVisual = new ItemHud(item, item.key, false);

				var row = Math.floor(item.key / 3);
				var col = item.key % 3;

				abilityVisual.y = row * 66;
				abilityVisual.x = col * 70;
				itemsHud.add(abilityVisual);
			}

			isDraggingItem = false;
		}
		function updateeffects()
		{
			for (i in effectsHud)
			{
				i.destroy();
			}

			effectsHud.clear();

			for (key => effect in selfEntity.effects)
			{
				var abilityVisual = new EffectHud(effect);

				var row = Math.floor(key / 10);
				var col = key % 10;

				abilityVisual.y = row * 50;
				abilityVisual.x = col * (35 + 5);
				effectsHud.add(abilityVisual);

				effectsHud.x = (FlxG.width - ((35 * (effectsHud.length <= 10 ? effectsHud.length : 10)) + 5)) / 2;
				effectsHud.y = centerHud.y - 40 - row * 50;
			}
		}
		if (WHAT == null)
		{
			updateabilities();
			updateitems();
			updateeffects();
		}
		if (WHAT == "effects")
		{
			updateeffects();
		}
		if (WHAT == "items")
		{
			updateitems();
		}
		if (WHAT == "abilities")
		{
			updateabilities();
		}
	}

	public static function setFocusOnPlayerAndUpdateHud(player:Entity, ?IGNORE:Bool, ?WHAT:String)
	{
		if (player != null)
		{
			if (selfEntity != player)
			{
				selfEntity = player;
				updateHud(WHAT);
			}

			if (IGNORE)
			{
				selfEntity = player;
				updateHud(WHAT);
			}
		}
	}

	public static function setKillingStreakAnimation(ENTITY:Entity)
	{
		var killstreak = ENTITY.killStreakLength;

		if (timerKillStreak != null && timerKillStreak.active)
			timerKillStreak.cancel();

		var table = [
			'3/killing-spree/GREEN',
			'4/dominating/PURPLE',
			'5/mega_kill/PINK',
			'6/unstopable/YELLOW',
			'7/wicked-sick/#7c8a58',
			'8/monster-kill/MAGENTA',
			'9/godlike/YELLOW'
		];

		textKillStreak.visible = true;

		for (i in table)
		{
			var args = i.split("/");
			var name = args[1];

			if (Std.parseInt(args[0]) == killstreak)
			{
				FlxG.sound.play('assets/sounds/$name.ogg');

				textKillStreak.color = FlxColor.fromString(args[2]);
				textKillStreak.text = ENTITY.name + " is on " + name + "!";
				textKillStreak.y = 20;
				textKillStreak.x = (FlxG.width - textKillStreak.fieldWidth) / 2;
			}
		}

		if (killstreak >= 10)
		{
			FlxG.sound.play('assets/sounds/holy.ogg');

			textKillStreak.color = FlxColor.YELLOW;
			textKillStreak.text = ENTITY.name + " is on " + 'GODLIKE, someone kill them!!';
			textKillStreak.y = 20;
			textKillStreak.x = (FlxG.width - textKillStreak.fieldWidth) / 2;
		}

		FlxTween.tween(textKillStreak, {y: textKillStreak.y + 70}, 0.65);

		timerKillStreak = new FlxTimer().start(4, function name(timer:FlxTimer)
		{
			textKillStreak.visible = false;
		}, 1);
	}

	function keyBoardControl()
	{
		if (!console.isEditing)
		{
			if (FlxG.keys.justPressed.X)
			{
				setFocusOnPlayerAndUpdateHud(clientSelfEntity);
			}
			if (FlxG.keys.pressed.X)
			{
				if (clientSelfEntity != null)
					FlxG.camera.follow(clientSelfEntity.playerCamera, LOCKON);
			}
			if (FlxG.keys.justReleased.X)
			{
				FlxG.camera.follow(null);
			}
		}
	}

	function selectBoxFunction()
	{
		if (FlxG.mouse.justPressed && !isOverlapsHud)
		{
			selectBox.x = FlxG.mouse.x;
			selectBox.y = FlxG.mouse.y;

			selectBoxX = FlxG.mouse.x;
			selectBoxY = FlxG.mouse.y;

			isPressedSelectBox = true;
		}
		if (isPressedSelectBox)
		{
			if (FlxG.mouse.x <= selectBoxX)
			{
				selectBox.setFacingFlip(RIGHT, true, false);
				selectBox.makeGraphic(Std.int(selectBoxX - FlxG.mouse.x), Std.int(FlxG.mouse.y - selectBoxY), FlxColor.GREEN);
				selectBox.setFacingFlip(RIGHT, true, false);
				selectBox.updateHitbox();
			}
			else
			{
				selectBox.makeGraphic(Std.int(FlxG.mouse.x - selectBoxX), Std.int(FlxG.mouse.y - selectBoxY), FlxColor.GREEN);
				selectBox.updateHitbox();
			}
		}
		if (FlxG.mouse.justReleased)
		{
			for (player in groupEntities)
			{
				if (player.entityHitbox.overlaps(selectBox))
				{
					if (player.isSelectable == true && !player.dead)
					{
						if (player.isClient)
						{
							player.isSelect = true;
							setFocusOnPlayerAndUpdateHud(clientSelfEntity);
							break;
						}
						else
						{
							player.isSelect = true;
							setFocusOnPlayerAndUpdateHud(player);
						}
					}
				}
			}

			selectBox.makeGraphic(1, 1, FlxColor.TRANSPARENT);
			selectBox.updateHitbox();

			isPressedSelectBox = false;
		}
	}

	function mouseScroll()
	{
		if (FlxG.mouse.justPressedMiddle)
		{
			FlxG.camera.follow(null);
			isDraggingCamera = true;
			dragStartX = FlxG.mouse.viewX;
			dragStartY = FlxG.mouse.viewY;
			cameraStartX = FlxG.camera.scroll.x;
			cameraStartY = FlxG.camera.scroll.y;
		}

		if (isDraggingCamera)
		{
			var deltaX:Float = FlxG.mouse.viewX - dragStartX;
			var deltaY:Float = FlxG.mouse.viewY - dragStartY;

			FlxG.camera.scroll.x = cameraStartX - deltaX;
			FlxG.camera.scroll.y = cameraStartY - deltaY;
		}

		if (FlxG.mouse.justReleasedMiddle)
		{
			isDraggingCamera = false;
		}
	}

	function initializedUpdate()
	{
		if (isInitialized)
		{
			groupEntities.forEach(function(player:Entity)
			{
				if (player.entityHitbox != null && !player.dead)
				{
					FlxG.collide(player.entityHitbox, groupSpriteColision);
				}
			});

			if ((FlxG.mouse.overlaps(console, cameraHud) && console.visible == true)
				|| FlxG.mouse.overlaps(leftHud, cameraHud)
				|| FlxG.mouse.overlaps(centerHud, cameraHud)
				|| FlxG.mouse.overlaps(rightHud, cameraHud)
				|| FlxG.mouse.overlaps(itemsBgHud, cameraHud)
				|| FlxG.mouse.overlaps(storeHud.bg, cameraHud)
				|| FlxG.mouse.overlaps(mapHud.bg, cameraHud))
			{
				isOverlapsHud = true;
			}
			else
			{
				isOverlapsHud = false;
			}
		}
	}

	function initializedJust()
	{
		if (isInitialized && !isInitJust)
		{
			addHud();

			isInitJust = true;
		}
	}

	function updateVisualForEnemy()
	{
		for (entity in groupEntities)
		{
			if (entity != clientSelfEntity)
			{
				if (entity.team != clientSelfEntity.team)
				{
					entity.enemy = true;
				}
			}
		}
	}

	function loadMap()
	{
		var mapData = Json.parse(File.getContent(mapPath));

		groupSpriteMap = new FlxSpriteGroup(0, 0);
		add(groupSpriteMap);

		groupSpriteColision = new FlxSpriteGroup(0, 0);
		add(groupSpriteColision);

		for (i in 0...mapData.map.length)
		{
			var className = mapData.map[i].name_class;
			var arguments = mapData.map[i].arguments;

			if (className == "FlxSprite")
			{
				var position = mapData.map[i].position;
				var image = mapData.map[i].image;
				var size = mapData.map[i].size;
				var colision = mapData.map[i].colision;

				var sprite = new FlxSprite();

				if (size != null)
				{
					sprite.loadGraphic(image == null ? null : BitmapData.fromFile(image));
					sprite.setGraphicSize(size[0], size[1]);
					sprite.updateHitbox();
					sprite.x = position[0];
					sprite.y = position[1];
				}
				else
				{
					sprite.loadGraphic(image == null ? null : BitmapData.fromFile(image));
					sprite.updateHitbox();
					sprite.x = position[0];
					sprite.y = position[1];
					// sprite.immovable = true;
				}

				if (colision != null)
					groupSpriteColision.add(sprite);

				if (colision == null)
					groupSpriteMap.add(sprite);
			}
			else
			{
				add(createObject(className, arguments));
			}
		}

		groupSpriteColision.forEachAlive(function(sprite:FlxSprite)
		{
			sprite.immovable = true;
		});
	}

	public static function createObject(className:String, arguments, ?properties:Dynamic):Dynamic
	{
		var classReference = Type.resolveClass('game.map_objects.$className');

		var object = Type.createInstance(classReference, arguments);

		if (properties != null)
		{
			for (fieldName in Reflect.fields(properties))
			{
				var value = Reflect.field(properties, fieldName);
				try
				{
					Reflect.setField(object, fieldName, value);
				}
				catch (e:Dynamic)
				{
					trace('Failed to set $fieldName: $e');
				}
			}
		}
		return object;
	}

	function addHud()
	{
		groupHud = new FlxGroup();
		groupHud.cameras = [cameraHud];
		add(groupHud);

		selectBox = new FlxSprite(0, 0);
		selectBox.makeGraphic(1, 1, FlxColor.TRANSPARENT);
		selectBox.updateHitbox();

		add(selectBox);

		centerHud = new FlxSprite(0, 0, "assets/player/hud/center.png");
		groupHud.add(centerHud);

		itemsBgHud = new FlxSprite(0, 0, "assets/player/hud/items.png");
		groupHud.add(itemsBgHud);

		leftHud = new FlxSprite(0, 0, "assets/player/hud/left.png");
		groupHud.add(leftHud);

		rightHud = new FlxSprite(0, 0, "assets/player/hud/right.png");
		groupHud.add(rightHud);

		storeHud = new StoreHud();
		groupHud.add(storeHud);

		mapHud = new MapHud();
		groupHud.add(mapHud);

		textKillStreak = new FlxText(0, 0, 0, '', 24);
		textKillStreak.font = Path.font;
		textKillStreak.visible = false;
		textKillStreak.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		groupHud.add(textKillStreak);

		upItemsHud = new UpItemHud();
		groupHud.add(upItemsHud);

		textCoins = new FlxText(0, 0, 0, '', 16);
		textCoins.setFormat(Path.font, 20, Color.get("xp"), null, OUTLINE, FlxColor.BLACK);
		groupHud.add(textCoins);

		imageCoins = new FlxSprite(0, 0, 'assets/hud/coins.png');
		imageCoins.setGraphicSize(48, 25);
		imageCoins.updateHitbox();
		groupHud.add(imageCoins);

		buttonOpenStore = new PuppetsButton(0, 0, "OPEN", function()
		{
			storeHud.open();
		}, cameraHud);
		buttonOpenStore.makeGraphic(113, 22, FlxColor.GRAY);
		buttonOpenStore.updateHitbox();
		buttonOpenStore.text.color = FlxColor.WHITE;
		groupHud.add(buttonOpenStore);

		textNameCharacter = new FlxText(0, 0, 0, '', 16);
		textNameCharacter.setFormat(Path.font, 20, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		groupHud.add(textNameCharacter);

		healthBarHud = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 458, 20);
		groupHud.add(healthBarHud);

		manaBarHud = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 458, 20);
		manaBarHud.createColoredFilledBar(FlxColor.BLUE);
		manaBarHud.createColoredEmptyBar(FlxColor.fromRGB(0, 0, 55));
		groupHud.add(manaBarHud);

		xpBarHud = new FlxBar(0, 0, FlxBarFillDirection.BOTTOM_TO_TOP, 15, 105);
		xpBarHud.createColoredFilledBar(Color.get("xp"));
		xpBarHud.createColoredEmptyBar(FlxColor.fromRGB(66, 38, 0));
		groupHud.add(xpBarHud);

		textLevelHud = new FlxText(0, 0, 0, '', 20);
		textLevelHud.setFormat(Path.font, 20, Color.get("xp"), null, OUTLINE, FlxColor.fromRGB(66, 38, 0));
		groupHud.add(textLevelHud);

		textHealthHud = new FlxText(0, 0, 0, '', 25);
		textHealthHud.setFormat(Path.font, 20, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		groupHud.add(textHealthHud);

		textManaHud = new FlxText(0, 0, 0, '', 25);
		textManaHud.setFormat(Path.font, 20, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		groupHud.add(textManaHud);

		textRegenHealthHud = new FlxText(0, 0, 0, '');
		textRegenHealthHud.setFormat(Path.font, 15, FlxColor.LIME, null, OUTLINE, FlxColor.fromRGB(0, 55, 0));
		groupHud.add(textRegenHealthHud);

		textRegenManaHud = new FlxText(0, 0, 0, '');
		textRegenManaHud.setFormat(Path.font, 15, FlxColor.BLUE, null, OUTLINE, FlxColor.fromRGB(0, 0, 55));
		groupHud.add(textRegenManaHud);

		effectsHud = new FlxSpriteGroup();
		effectsHud.x = centerHud.x;
		groupHud.add(effectsHud);

		itemsHud = new FlxSpriteGroup();
		itemsHud.x = itemsBgHud.x;
		groupHud.add(itemsHud);

		abilitiesHud = new FlxSpriteGroup();
		groupHud.add(abilitiesHud);

		choosenItemSprite = new FlxSprite(0, 0);
		choosenItemSprite.visible = false;
		groupHud.add(choosenItemSprite);

		textPlayerStats = new FlxText(0, 0, 0, '');
		textPlayerStats.setFormat(Path.font, 18, FlxColor.WHITE, null, OUTLINE, FlxColor.fromRGB(0, 0, 0));
		groupHud.add(textPlayerStats);

		textStat = new StatText();
		textStat.visible = false;
		Main.fps.visible = false;
		groupHud.add(textStat);

		textRespawnTime = new FlxText(0, 0, 0, '', 8);
		textRespawnTime.setFormat(Path.font, 20, FlxColor.WHITE, null, OUTLINE, FlxColor.GRAY);
		groupHud.add(textRespawnTime);

		console = new Console();
		console.visible = false;
		console.camera = cameraHud;
		groupHud.add(console);
	}

	public static function error(Error:String)
	{
		Sound.playError();
		trace(Error);
	}

	public static function updateHudValues()
	{
		if (selfEntity != null)
		{
			groupHud.visible = true;

			if (!isDraggingItem)
				choosenItemSprite.y = FlxG.height * 2;

			if (abilitiesHud.length >= 7)
			{
				centerHud.setGraphicSize((70 * abilitiesHud.length - 10) + 20, centerHud.height);
				centerHud.updateHitbox();
			}
			else
			{
				centerHud.setGraphicSize(482, centerHud.height);
				centerHud.updateHitbox();
			}

			centerHud.x = (FlxG.width - centerHud.width) / 2;
			centerHud.y = FlxG.height - centerHud.height;

			itemsBgHud.x = centerHud.x + centerHud.width;
			itemsBgHud.y = FlxG.height - itemsBgHud.height;

			leftHud.x = centerHud.x - leftHud.width;
			leftHud.y = FlxG.height - leftHud.height;

			rightHud.x = FlxG.width - rightHud.width;
			rightHud.y = FlxG.height - rightHud.height;

			itemsHud.y = itemsBgHud.y + 8;

			abilitiesHud.y = centerHud.y + centerHud.height - 80;

			itemsHud.x = itemsBgHud.x + 10;

			textNameCharacter.text = selfEntity.name;
			textNameCharacter.y = centerHud.y + 2;
			textNameCharacter.x = centerHud.x + ((centerHud.width - textNameCharacter.fieldWidth) / 2);

			if (selfEntity.enemy)
			{
				healthBarHud.createColoredFilledBar(FlxColor.RED);
				healthBarHud.createColoredEmptyBar(FlxColor.fromRGB(55, 0, 0));
			}
			else
			{
				healthBarHud.createColoredFilledBar(FlxColor.LIME);
				healthBarHud.createColoredEmptyBar(FlxColor.fromRGB(0, 55, 0));
			}

			healthBarHud.x = (FlxG.width - healthBarHud.width) / 2;
			healthBarHud.y = textNameCharacter.y + textNameCharacter.fieldHeight;
			healthBarHud.setRange(0, selfEntity.maxhealth);
			healthBarHud.value = selfEntity.health;

			manaBarHud.x = (FlxG.width - manaBarHud.width) / 2;
			manaBarHud.y = healthBarHud.y + healthBarHud.height + 5;
			manaBarHud.setRange(0, selfEntity.maxmana);
			manaBarHud.value = selfEntity.mana;

			xpBarHud.x = centerHud.x - 20;
			xpBarHud.y = manaBarHud.y + 4;
			xpBarHud.setRange(0, selfEntity.maxXp);
			xpBarHud.value = selfEntity.xp;

			if (xpBarHud.overlapsPoint(FlxG.mouse.getWorldPosition(cameraHud)))
			{
				if (!selfEntity.enemy)
					selfEntity.rangeXpHitBox.visible = true;
			}
			else
			{
				selfEntity.rangeXpHitBox.visible = false;
			}

			textLevelHud.text = selfEntity.level + '';
			textLevelHud.x = xpBarHud.x + (xpBarHud.width / 2) - (textLevelHud.fieldWidth / 2);
			textLevelHud.y = xpBarHud.y - textLevelHud.fieldHeight + 4;

			textHealthHud.text = Std.int(selfEntity.health) + ' / ' + selfEntity.maxhealth;
			textHealthHud.x = healthBarHud.x + (healthBarHud.width / 2) - (textHealthHud.fieldWidth / 2);
			textHealthHud.y = healthBarHud.y + (healthBarHud.height / 2) - (textHealthHud.fieldHeight / 2);

			textManaHud.text = Std.int(selfEntity.mana) + ' / ' + selfEntity.maxmana;
			textManaHud.x = manaBarHud.x + (manaBarHud.width / 2) - (textManaHud.fieldWidth / 2);
			textManaHud.y = manaBarHud.y + (manaBarHud.height / 2) - (textManaHud.fieldHeight / 2);

			if (selfEntity.enemy)
				textRegenHealthHud.setFormat(Path.font, 15, FlxColor.RED, null, OUTLINE, FlxColor.fromRGB(55, 0, 0));
			else
				textRegenHealthHud.setFormat(Path.font, 15, FlxColor.LIME, null, OUTLINE, FlxColor.fromRGB(0, 55, 0));

			textRegenHealthHud.text = "+" + selfEntity.health_regeneration;
			textRegenHealthHud.x = healthBarHud.x + healthBarHud.width - textRegenHealthHud.fieldWidth;
			textRegenHealthHud.y = healthBarHud.y;

			textRegenManaHud.text = "+" + selfEntity.mana_regeneration;
			textRegenManaHud.x = manaBarHud.x + manaBarHud.width - textRegenManaHud.fieldWidth;
			textRegenManaHud.y = manaBarHud.y;

			if (selfEntity.enemy)
			{
				textCoins.text = "" + 0;
			}
			else
			{
				textCoins.text = selfEntity.coins + "";
			}

			imageCoins.x = rightHud.x + 20;
			imageCoins.y = rightHud.y + 8;
			textCoins.x = imageCoins.x + imageCoins.width + 5;
			textCoins.y = imageCoins.y;

			buttonOpenStore.x = rightHud.x + 12;
			buttonOpenStore.y = imageCoins.y + imageCoins.height + 5;

			textPlayerStats.x = 0;
			textPlayerStats.y = 0;
			textPlayerStats.text = 'K: ' + selfEntity.kills + ' | ' + 'D: ' + selfEntity.deaths + ' | ' + 'A: ' + selfEntity.assists;

			textRespawnTime.visible = selfEntity.dead ? true : false;
			textRespawnTime.text = (selfEntity.respawnTime - Std.int(selfEntity.currentRespawnTime)) + "";
			textRespawnTime.x = xpBarHud.x - 50;
			textRespawnTime.y = xpBarHud.y + (xpBarHud.height / 2);
		}
		else
		{
			groupHud.visible = false;
		}
	}

	function applieWorldSettings()
	{
		var wolrd_size = Data.get(mapPath, "settings_map/world_size");

		FlxG.worldBounds.set(0, 0, wolrd_size[0], wolrd_size[1]);
	}

	public function addPlayer(Character:String, Team:PuppetsTeamEnum, isClient:Bool)
	{
		var playerr:Entity = cast Type.createInstance(Type.resolveClass('game.entity.characters.$Character'), []);
		playerr.isClient = isClient;
		playerr.typeEntity = CHARACTER;
		playerr.team = Team;
		groupEntities.add(playerr);
	}
}

class StatText extends FlxSpriteGroup
{
	var bg:FlxSprite;
	var text:FlxText;
	var textfps:FlxText;

	public function new()
	{
		super(0, 0);

		bg = new FlxSprite(0, 0).makeGraphic(500, 250, 0xFF4B4B4B);
		add(bg);

		Main.fps.visible = true;

		text = new FlxText(0, 0, 0, '', 16);
		text.font = Path.font;
		text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		add(text);

		textfps = new FlxText(500, 0, 0, '', 16);
		textfps.font = Path.font;
		textfps.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		add(textfps);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.visible)
		{
			text.text = getText();
			textfps.text = System.totalMemoryNumber / (1024 * 1024) + "";
		}
	}

	function getText():String
	{
		final worldsize = FlxG.worldBounds.width + ',' + FlxG.worldBounds.height;
		final mouseposition = FlxG.mouse.x + ',' + FlxG.mouse.y;
		final mousepositionscren = FlxG.mouse.gameX + ',' + FlxG.mouse.gameY;
		final dc = PlayState.selfEntity.disableControl;
		var playerposition = '';
		final overlaps = PlayState.isOverlapsHud;
		var positionitems:String = "";

		var tttext = "";

		for (item in PlayState.itemsHud)
		{
			tttext = tttext + item.x + "/" + item.y + '\n';
		}

		positionitems = tttext;

		PlayState.groupEntities.forEachOfType(Entity, function(player:Entity)
		{
			if (player.isClient)
				playerposition = player.entityHitbox.x + ',' + player.entityHitbox.y;
		});

		final arrayOptions:Array<String> = [
			'World_Size = $worldsize',
			'MouseWorld_Position = $mouseposition',
			'MouseScreen_Position = $mousepositionscren',
			'Player_Position = $playerposition',
			'Disable_Control = $dc',
			'IsOverlapsHud = $overlaps',
			'Positions = $positionitems'

		];

		var ttext:String = "";

		for (i in arrayOptions)
		{
			ttext = ttext + i + '\n';
		}

		return ttext;
	}
}

class AbilityHud extends FlxSpriteGroup
{
	var abilka:Ability;
	var icon:FlxSprite;
	var textManaCost:FlxText;
	var textButton:FlxText;
	var textCoolDown:FlxText;
	var button:String;
	var maskCoolDown:FlxBar;
	var maskCast:FlxBar;
	var bg:FlxSprite;

	var bgtextName:FlxText;
	var bgtextDescr:FlxText;
	var bgtextType:FlxText;

	var groupTextFlatBonus:FlxSpriteGroup;

	var groupSkiilPoints:FlxTypedSpriteGroup<FlxSprite>;

	var buttonToUpgrade:FlxSprite;

	public function new(ABILITY:Ability, KEY:Int)
	{
		super(0, 0);
		abilka = ABILITY;

		icon = new FlxSprite(0, 0);
		icon.loadGraphic(abilka.icon);
		icon.setGraphicSize(60, 60);
		icon.updateHitbox();
		if (abilka.skillpoints == 0)
		{
			icon.setColorTransform(0.333, 0.333, 0.333, 1, 0, 0, 0, 0);
		}
		add(icon);

		maskCoolDown = new FlxBar(0, 0, FlxBarFillDirection.BOTTOM_TO_TOP, 60, 60);
		maskCoolDown.createColoredFilledBar(FlxColor.fromRGB(0, 0, 0, 130));
		maskCoolDown.createColoredEmptyBar(FlxColor.fromRGB(0, 0, 0, 0));
		if (abilka.cooldown == 0)
		{
			maskCoolDown.setRange(0, 1);
		}
		else
		{
			maskCoolDown.setRange(0, abilka.cooldown);
		}
		maskCoolDown.value = 0;
		add(maskCoolDown);

		maskCast = new FlxBar(0, 0, LEFT_TO_RIGHT, 60, 60);
		maskCast.createColoredEmptyBar(FlxColor.fromRGB(0, 0, 0, 25));
		maskCast.createColoredFilledBar(FlxColor.fromRGB(255, 255, 0, 155));
		maskCast.visible = true;
		if (abilka.castTime == 0)
		{
			maskCast.setRange(0, 1);
		}
		else
		{
			maskCast.setRange(0, abilka.castTime);
		}
		maskCast.value = 0;
		add(maskCast);

		if (KEY == 0)
			button = Data.getKey(ability1) + "";
		else if (KEY == 1)
			button = Data.getKey(ability2) + "";
		else if (KEY == 2)
			button = Data.getKey(ability3) + "";
		else if (KEY == 3)
			button = Data.getKey(ability4) + "";
		else if (KEY == 4)
			button = Data.getKey(ability5) + "";
		else if (KEY == 5)
			button = Data.getKey(ability6) + "";
		else
		{
			button = "";
		}

		textButton = new FlxText(0, 0, 0, '', 12);
		textButton.text = button + "";
		textButton.setFormat(Path.font, 16, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		textButton.x = (icon.width / 2) - (textButton.fieldWidth / 2);
		textButton.y = -10;
		add(textButton);

		textCoolDown = new FlxText(0, 0, 0, '', 18);
		textCoolDown.setFormat(Path.font, 20, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		textCoolDown.x = (icon.width / 2) - (textCoolDown.fieldWidth / 2);
		textCoolDown.y = (icon.height / 2) - (textCoolDown.fieldHeight / 2);
		add(textCoolDown);

		bg = new FlxSprite(0, 0, "assets/player/hud/ability_description.png");
		bg.visible = false;
		add(bg);

		bgtextName = new FlxText(0, 0, 0, '', 20);
		bgtextName.setFormat(Path.font, 30, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		bgtextName.visible = false;
		add(bgtextName);

		bgtextType = new FlxText(0, 0, 0, '', 20);
		bgtextType.setFormat(Path.font, 22, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		bgtextType.visible = false;
		add(bgtextType);

		bgtextDescr = new FlxText(0, 0, 0, '', 20);
		bgtextDescr.setFormat(Path.font, 18, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		bgtextDescr.visible = false;
		add(bgtextDescr);

		groupTextFlatBonus = new FlxSpriteGroup();
		add(groupTextFlatBonus);

		for (key => i in abilka.storedOptionsPoints)
		{
			var text = new FlxText(0, 0, 0, '', 20);
			text.setFormat(Path.font, 18, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);

			var table = i.split("/");
			var name = table[0];
			table.remove(name);

			var firstnumber = table[0];

			var yesodinakov = false;

			for (key => i in table)
			{
				if (table[key] == firstnumber)
				{
					yesodinakov = true;
				}
				else
				{
					yesodinakov = false;
				}
			}

			var theother = table.join("/");

			if (yesodinakov)
			{
				theother = '' + firstnumber;
			}

			text.text = '$name: $theother';

			function getColor():FlxColor
			{
				var name = i.split("/")[0];

				if (name == "heal")
				{
					return FlxColor.LIME;
				}
				if (name == "damage")
				{
					return FlxColor.RED;
				}
				if (name == "manacost")
				{
					return FlxColor.CYAN;
				}
				return FlxColor.WHITE;
			}
			text.y = (key * text.fieldHeight);
			text.color = getColor();
			groupTextFlatBonus.add(text);
		}

		bg.visible = false;
		bgtextName.visible = false;
		bgtextDescr.visible = false;
		bgtextType.visible = false;
		groupTextFlatBonus.visible = false;

		groupSkiilPoints = new FlxTypedSpriteGroup();
		add(groupSkiilPoints);

		for (i in 0...abilka.maxSkillPoints)
		{
			var point = new FlxSprite(0, 0);
			point.makeGraphic(10, 6, FlxColor.fromRGB(66, 38, 0));

			if (abilka.skillpoints >= i + 1)
			{
				point.makeGraphic(10, 6, FlxColor.fromRGB(255, 174, 66));
			}
			point.x = (i * (point.width + 6));
			groupSkiilPoints.add(point);
		}

		if (groupSkiilPoints.width >= icon.width)
		{
			for (key => i in groupSkiilPoints.members)
			{
				function getColor()
				{
					if (abilka.skillpoints >= key + 1)
					{
						return FlxColor.fromRGB(255, 174, 66);
					}
					return FlxColor.fromRGB(66, 38, 0);
				}
				i.makeGraphic(Std.int(i.width / 2), Std.int(i.height), getColor());
				i.x = (key * (i.width + 3));
			}
		}

		groupSkiilPoints.y = icon.height + 8;
		groupSkiilPoints.x = (icon.width / 2) - ((groupSkiilPoints.width) / 2);

		textManaCost = new FlxText(0, 0, 0, '', 12);
		textManaCost.text = abilka.manacost + "";
		textManaCost.setFormat(Path.font, 16, FlxColor.fromRGB(66, 170, 255), null, OUTLINE, FlxColor.fromRGB(0, 0, 55));
		textManaCost.x = (icon.width / 2) - (textManaCost.fieldWidth / 2);
		textManaCost.y = icon.height - 10;
		textManaCost.visible = false;
		add(textManaCost);

		if (abilka.skillpoints != 0)
		{
			if (!abilka.selfEntity.enemy)
			{
				textManaCost.visible = true;
			}
		}
		if (abilka.selfEntity.enemy)
		{
			groupSkiilPoints.visible = false;
		}
		if (abilka.passive)
		{
			textCoolDown.visible = false;
			textButton.visible = false;
			textManaCost.visible = false;
			icon.setGraphicSize(55, 55);
			icon.x = 2.5;
			icon.y = 2.5;
			icon.updateHitbox();
		}

		buttonToUpgrade = new FlxSprite(0, -15);
		buttonToUpgrade.loadGraphic("assets/player/hud/skillpoint.png");
		buttonToUpgrade.updateHitbox();
		buttonToUpgrade.visible = false;
		add(buttonToUpgrade);
	}

	function updatebg()
	{
		var thewhole:Float = 0;
		thewhole = bgtextName.fieldHeight + bgtextDescr.fieldHeight + bgtextType.fieldHeight + (groupTextFlatBonus.members.length * 25);
		bg.visible = true;
		bg.setGraphicSize(bg.width, thewhole);
		bg.updateHitbox();
		bg.y = icon.y - bg.height - 15;

		bgtextName.visible = true;
		bgtextName.y = bg.y;
		var s = Type.getClassName(Type.getClass(abilka)).split(".");
		bgtextName.text = "" + s[s.length - 1];

		bgtextType.visible = true;
		bgtextType.y = bgtextName.y + bgtextType.fieldHeight;
		bgtextType.text = "type: " + abilka.typeAbility;

		bgtextDescr.text = abilka.description;
		bgtextDescr.y = bgtextType.y + bgtextType.fieldHeight;
		bgtextDescr.fieldWidth = bg.width;
		bgtextDescr.visible = true;

		groupTextFlatBonus.y = bgtextDescr.y + bgtextDescr.fieldHeight;
		groupTextFlatBonus.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var isoverlaps:Bool = icon.overlapsPoint(FlxG.mouse.getWorldPosition(PlayState.cameraHud));

		if (abilka.selfEntity.levelPoints != 0 && !abilka.selfEntity.enemy && abilka.selfEntity.isClient)
		{
			if (abilka.skillpoints != abilka.maxSkillPoints)
			{
				if (abilka.ultimate)
				{
					if (abilka.selfEntity.level >= 6 && abilka.skillpoints == 0)
					{
						buttonToUpgrade.visible = true;
					}
					if (abilka.selfEntity.level >= 12 && abilka.skillpoints == 1)
					{
						buttonToUpgrade.visible = true;
					}
					if (abilka.selfEntity.level >= 18 && abilka.skillpoints == 2)
					{
						buttonToUpgrade.visible = true;
					}
				}

				if (!abilka.ultimate)
				{
					buttonToUpgrade.visible = true;
				}
			}
		}
		else
		{
			buttonToUpgrade.visible = false;
		}
		if (buttonToUpgrade.overlapsPoint(FlxG.mouse.getWorldPosition(PlayState.cameraHud))
			&& FlxG.mouse.justPressed
			&& buttonToUpgrade.visible)
		{
			if (abilka.skillpoints != abilka.maxSkillPoints)
			{
				abilka.upgradeAbility();
				abilka.selfEntity.updateHud('abilities');
			}
		}

		if (isoverlaps)
		{
			if (!abilka.selfEntity.enemy)
			{
				if (abilka.range != 0)
					abilka.rangeHitBox.visible = true;
			}
			updatebg();
		}
		else
		{
			abilka.rangeHitBox.visible = false;
			bg.visible = false;
			bgtextName.visible = false;
			bgtextDescr.visible = false;
			bgtextType.visible = false;
			groupTextFlatBonus.visible = false;

			bg.y = FlxG.height * 2;
			bgtextName.y = FlxG.height * 2;
			bgtextDescr.y = FlxG.height * 2;
			bgtextType.y = FlxG.height * 2;
			groupTextFlatBonus.y = FlxG.height * 2;
		}

		if (abilka.coolDownTimer == 0)
		{
			textCoolDown.visible = false;
		}
		else
		{
			textCoolDown.visible = true;
		}
		if (PlayState.selfEntity.enemy)
		{
			textCoolDown.visible = false;
			textButton.visible = false;
		}

		maskCast.value = abilka.castTimeStored;
		maskCoolDown.value = abilka.coolDownTimer;

		textCoolDown.x = icon.x + (icon.width / 2) - (textCoolDown.fieldWidth / 2);

		textCoolDown.text = Math.round(abilka.coolDownTimer) + "";
	}
}

class ItemHud extends FlxSpriteGroup
{
	public var item:Item;

	var abilka:Ability;

	public var icon:FlxSprite;

	var textManaCost:FlxText;
	var textButton:FlxText;
	var textCoolDown:FlxText;
	var button:String;
	var maskCoolDown:FlxBar;
	var bg:FlxSprite;

	var bgtextName:FlxText;
	var bgIcon:FlxSprite;
	var bgtextCoins:FlxText;
	var bgcoinsicon:FlxSprite;
	var textFlatBonus:FlxText;

	var shop:Bool = false;
	var isDragging:Bool = false;

	public function new(ABILITY:Item, KEY:Int, SHOP:Bool)
	{
		super(0, 0);
		item = ABILITY;
		abilka = item.ability;
		shop = SHOP;

		icon = new FlxSprite(0, 0);
		icon.loadGraphic(item.icon);
		icon.setGraphicSize(60, 60);
		icon.updateHitbox();
		add(icon);

		if (KEY == 0)
			button = Data.getKey(item1) + "";
		else if (KEY == 1)
			button = Data.getKey(item2) + "";
		else if (KEY == 2)
			button = Data.getKey(item3) + "";
		else if (KEY == 3)
			button = Data.getKey(item4) + "";
		else if (KEY == 4)
			button = Data.getKey(item5) + "";
		else if (KEY == 5)
			button = Data.getKey(item6) + "";
		else
		{
			button = "";
		}

		textButton = new FlxText(0, 0, 0, '', 12);
		textButton.text = button + "";
		textButton.setFormat(Path.font, 16, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		textButton.x = (icon.width / 2) - (textButton.fieldWidth / 2);
		textButton.y = -10;
		textButton.visible = false;
		add(textButton);

		maskCoolDown = new FlxBar(0, 0, FlxBarFillDirection.BOTTOM_TO_TOP, 60, 60);
		maskCoolDown.createColoredFilledBar(FlxColor.fromRGB(0, 0, 0, 130));
		maskCoolDown.createColoredEmptyBar(FlxColor.fromRGB(0, 0, 0, 0));
		if (abilka.cooldown == 0)
		{
			maskCoolDown.setRange(0, 1);
		}
		else
		{
			maskCoolDown.setRange(0, abilka.cooldown);
		}
		maskCoolDown.value = 0;
		add(maskCoolDown);

		textCoolDown = new FlxText(0, 0, 0, '', 18);
		textCoolDown.setFormat(Path.font, 20, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		textCoolDown.x = (icon.width / 2) - (textCoolDown.fieldWidth / 2);
		textCoolDown.y = (icon.height / 2) - (textCoolDown.fieldHeight / 2);
		textCoolDown.visible = false;
		add(textCoolDown);

		textManaCost = new FlxText(0, 0, 0, '', 12);
		textManaCost.text = item.ability.manacost + "";
		textManaCost.setFormat(Path.font, 16, FlxColor.fromRGB(66, 170, 255), null, OUTLINE, FlxColor.fromRGB(0, 0, 55));
		textManaCost.x = icon.width - textManaCost.fieldWidth;
		textManaCost.y = icon.height - textManaCost.fieldHeight;
		textManaCost.visible = false;
		add(textManaCost);

		if (!shop)
		{
			if (item.storedAbility != null)
			{
				if (!item.ability.passive)
					textButton.visible = true;

				if (item.ability.manacost != 0)
					textManaCost.visible = true;
			}
		}

		bg = new FlxSprite(0, 0, "assets/player/hud/ability_description.png");
		bg.visible = false;
		add(bg);

		bgtextName = new FlxText(0, 0, 0, '', 20);
		bgtextName.setFormat(Path.font, 22, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		bgtextName.visible = false;
		add(bgtextName);

		bgIcon = new FlxSprite(0, 0);
		bgIcon.loadGraphic(item.icon);
		bgIcon.setGraphicSize(60, 60);
		bgIcon.updateHitbox();
		bgIcon.visible = false;
		add(bgIcon);

		bgcoinsicon = new FlxSprite(0, 0);
		bgcoinsicon.loadGraphic("assets/hud/coins.png");
		bgcoinsicon.setGraphicSize(43, 25);
		bgcoinsicon.updateHitbox();
		bgcoinsicon.visible = false;
		add(bgcoinsicon);

		bgtextCoins = new FlxText(0, 0, 0, '', 20);
		bgtextCoins.text = item.cost + "";
		bgtextCoins.setFormat(Path.font, 22, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		bgtextCoins.visible = false;
		add(bgtextCoins);

		textFlatBonus = new FlxText(0, 0, 0, '', 20);
		textFlatBonus.setFormat(Path.font, 22, FlxColor.WHITE, null, OUTLINE, FlxColor.BLACK);
		textFlatBonus.color = FlxColor.WHITE;
		textFlatBonus.visible = false;
		add(textFlatBonus);

		for (key => i in item.flat_bonus)
		{
			var table = i.split("/");
			var value = table[1];
			var value_name = table[0];

			textFlatBonus.text = textFlatBonus.text + '+$value $value_name\n';
		}
	}

	function updatebg()
	{
		var thewhole:Float = 0;
		thewhole = 30 + bgIcon.height + (textFlatBonus.fieldHeight);

		bg.visible = true;
		bg.setGraphicSize(bg.width, thewhole);
		bg.updateHitbox();

		if (!shop)
		{
			bg.y = PlayState.itemsBgHud.y - thewhole - 15;
			bg.x = 1211;
		}
		if (shop)
		{
			bg.x = PlayState.storeHud.bg.x - bg.width;
		}

		bgIcon.visible = true;
		bgIcon.x = bg.x + 15;
		bgIcon.y = bg.y + 15;

		bgtextName.visible = true;
		bgtextName.x = bgIcon.x + bgIcon.width + 5;
		bgtextName.y = bgIcon.y - 2;
		var s = Type.getClassName(Type.getClass(item)).split(".");
		bgtextName.text = "" + s[s.length - 1];

		bgcoinsicon.visible = true;
		bgcoinsicon.x = bgtextName.x;
		bgcoinsicon.y = bgtextName.y + 35;

		bgtextCoins.visible = true;
		bgtextCoins.x = bgcoinsicon.x + bgcoinsicon.width + 5;
		bgtextCoins.y = bgcoinsicon.y;

		textFlatBonus.y = bgIcon.y + bgIcon.height + 10;
		textFlatBonus.x = bgIcon.x;
		textFlatBonus.visible = true;
	}

	function offBg()
	{
		abilka.rangeHitBox.visible = false;
		bg.visible = false;
		bgtextName.visible = false;
		bgIcon.visible = false;
		bgcoinsicon.visible = false;
		bgtextCoins.visible = false;
		textFlatBonus.visible = false;

		// bg.y = FlxG.height * 2;
		//	bgtextName.y = FlxG.height * 2;
		//	bgIcon.y = FlxG.height * 2;
		//	bgcoinsicon.y = FlxG.height * 2;
		//	bgtextCoins.y = FlxG.height * 2;
		//	textFlatBonus.y = FlxG.height * 2;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (abilka.coolDownTimer == 0)
		{
			textCoolDown.visible = false;
		}
		else
		{
			textCoolDown.visible = true;
		}
		if (PlayState.selfEntity != null)
		{
			if (PlayState.selfEntity.enemy)
			{
				textCoolDown.visible = false;
				textButton.visible = false;
			}
		}

		maskCoolDown.value = abilka.coolDownTimer;

		textCoolDown.x = icon.x + (icon.width / 2) - (textCoolDown.fieldWidth / 2);

		textCoolDown.text = Math.round(abilka.coolDownTimer) + "";

		var isoverlaps:Bool = icon.overlapsPoint(FlxG.mouse.getWorldPosition(PlayState.cameraHud));

		if (isoverlaps)
		{
			if (shop == false)
			{
				abilka.rangeHitBox.visible = true;

				if (!item.selfEntity.enemy)
				{
					if (shop == false)
					{
						if (FlxG.mouse.justPressed)
						{
							if (!PlayState.isDraggingItem)
							{
								PlayState.choosenItemSprite.visible = true;
								PlayState.choosenItemSprite.loadGraphicFromSprite(icon);
								PlayState.choosenItemSprite.setGraphicSize(70, 70);
								PlayState.choosenItemSprite.updateHitbox();
								this.isDragging = true;
								PlayState.isDraggingItem = true;
							}
						}
					}
				}

				if (isDragging == false)
					updatebg();
			}

			if (shop)
			{
				updatebg();

				if (FlxG.mouse.justPressedRight)
				{
					if (PlayState.clientSelfEntity.coins >= item.cost)
					{
						PlayState.clientSelfEntity.coins -= item.cost;

						var i = Type.createInstance(Type.getClass(item), []);
						PlayState.clientSelfEntity.addItem(i);
					}
					else
					{
						PlayState.error('Not Enough Coins!');
					}
				}
			}
		}
		else
		{
			offBg();
		}

		if (!shop)
		{
			if (isoverlaps && FlxG.keys.justPressed.DELETE && !item.selfEntity.enemy)
			{
				item.removeItem();
			}
		}
		// if (textButton.visible == true && FlxG.keys.anyPressed([FlxKey.fromString(textButton.text)]) && item.ability.isUsed)
		//	item.updateHud();

		if (isDragging)
		{
			offBg();

			icon.color = FlxColor.GRAY;
			PlayState.choosenItemSprite.x = FlxG.mouse.gameX - 35;
			PlayState.choosenItemSprite.y = FlxG.mouse.gameY - 35;
		}
		if (FlxG.mouse.justReleased && isDragging && !shop)
		{
			var mouseX = FlxG.mouse.gameX;
			var mouseY = FlxG.mouse.gameY;

			// Позиции ячеек
			var slots = ['10/8/0', '80/8/1', '150/8/2', '10/74/3', '80/74/4', '150/74/5'];

			// Сначала проверяем, куда мы бросили предмет
			var targetSlot:Int = -1;
			var droppedOnSlot = false;

			for (slotStr in slots)
			{
				var parts = slotStr.split("/");
				var slotX:Float = Std.parseInt(parts[0]);
				var slotY:Float = Std.parseInt(parts[1]);
				var slotIndex = Std.parseInt(parts[2]);

				slotX = PlayState.itemsBgHud.x + slotX;
				slotY = PlayState.itemsBgHud.y + slotY;

				trace(PlayState.itemsBgHud.x);
				trace(PlayState.itemsBgHud.y);
				trace(slotX, slotY);
				// Проверяем, попали ли мы в эту ячейку
				if (mouseX >= slotX && mouseX <= slotX + 60 && mouseY >= slotY && mouseY <= slotY + 60)
				{
					targetSlot = slotIndex;
					droppedOnSlot = true;
					break;
				}
			}

			// Если бросили в пустую ячейку
			if (droppedOnSlot)
			{
				// Проверяем, занята ли ячейка
				var isSlotFree = true;
				for (itemHud in PlayState.itemsHud)
				{
					var hud:ItemHud = cast itemHud;
					if (hud.item.key == targetSlot)
					{
						isSlotFree = false;
						break;
					}
				}

				if (isSlotFree)
				{
					// Просто перемещаем предмет в свободную ячейку
					chooseKey(targetSlot);
				}
				else
				{
					// Ячейка занята - меняем местами
					var targetItem:ItemHud = null;

					// Находим предмет в целевой ячейке
					for (itemHud in PlayState.itemsHud)
					{
						var hud:ItemHud = cast itemHud;
						if (hud.item.key == targetSlot)
						{
							targetItem = hud;
							break;
						}
					}

					if (targetItem != null)
					{
						// Меняем местами ключи
						var currentKey = this.item.key;
						this.item.key = targetItem.item.key;
						targetItem.item.key = currentKey;
					}

					isDragging = false;
					PlayState.isDraggingItem = false;
					PlayState.setFocusOnPlayerAndUpdateHud(item.selfEntity, true, "items");
				}
			}
			else
			{
				chooseKey(item.key);
			}
		}
	}

	public function chooseKey(Key:Int)
	{
		item.key = Key;
		isDragging = false;
		PlayState.isDraggingItem = false;
		PlayState.setFocusOnPlayerAndUpdateHud(item.selfEntity, true, "items");
	}

	override function destroy()
	{
		super.destroy();
	}
}

class EffectHud extends FlxSpriteGroup
{
	var effect:Effect;
	var count:FlxText;
	var icon:FlxSprite;
	var name:FlxText;
	var description:FlxText;
	var bg:FlxSprite;
	var oldx:Float;
	var oldy:Float;
	var wasother:Bool = false;

	var time_mask:FlxBar;
	var was:Bool = false;

	public function new(EFFECT:Effect)
	{
		super();

		effect = EFFECT;

		icon = new FlxSprite(0, 0, effect.icon);
		icon.setGraphicSize(35, 35);
		icon.updateHitbox();
		add(icon);

		time_mask = new FlxBar(0, 0, LEFT_TO_RIGHT, 35, 35);
		time_mask.createColoredFilledBar(FlxColor.fromRGB(0, 0, 0, 100));
		time_mask.createColoredEmptyBar(FlxColor.fromRGB(0, 0, 0, 0));
		time_mask.setRange(0, 1);
		add(time_mask);

		count = new FlxText(0, 0, 0, '1', 20);
		count.setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
		count.font = Path.font;
		count.x = (icon.width - count.fieldWidth) / 2;
		count.y = (icon.height - count.fieldHeight) / 2;
		add(count);

		bg = new FlxSprite(0, 0, 'assets/player/hud/right.png');
		bg.setGraphicSize(300, bg.height);
		bg.updateHitbox();
		bg.y = -bg.height + -5;
		bg.x = (icon.width - bg.width) / 2;
		bg.visible = false;
		add(bg);

		name = new FlxText(0, 0, 0, effect.name, 16);

		name.font = Path.font;
		name.visible = false;
		add(name);

		description = new FlxText(0, 0, 0, effect.description, 16);
		description.font = Path.font;
		description.visible = false;
		add(description);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (effect.timeStatusEffectDefault > 0)
		{
			time_mask.setRange(0, effect.timeStatusEffectDefault);
		}
		time_mask.value = effect.timeStatusEffectDefault - effect.timeStatusEffectDefaultStored;
		count.text = effect.count + "";
		if (effect.count > 0)
		{
			count.visible = true;
		}
		else
		{
			count.visible = false;
		}
		var isoverlaps:Bool = icon.overlapsPoint(FlxG.mouse.getWorldPosition(PlayState.cameraHud));

		if (isoverlaps)
		{
			name.fieldWidth = bg.width - 5;

			description.fieldWidth = bg.width - 5;

			var thewhole = 10 + name.fieldHeight + description.fieldHeight;
			bg.setGraphicSize(bg.width, thewhole);
			bg.updateHitbox();
			bg.y = icon.y - thewhole - 5;

			name.x = bg.x + 5;
			name.y = bg.y + 5;

			description.x = bg.x + 5;
			description.y = name.y + name.fieldHeight + 5;

			name.visible = true;
			description.visible = true;
			bg.visible = true;
		}
		if (isoverlaps == false)
		{
			name.visible = false;
			description.visible = false;
			bg.visible = false;
		}
	}
}

class StoreHud extends FlxSpriteGroup
{
	var sections:Array<String> = ['base', 'advanced'];
	var storeItems:Array<{section:String, item:Item}> = [
		{section: "base", item: new Boots()},
		{section: "advanced", item: new Radiance()},
		{section: "advanced", item: new Deadalus()},
		{section: "advanced", item: new Blink_Dagger()}
	];

	public var bg:FlxSprite;
	public var isOpen:Bool = false;

	var rectSection:FlxSprite;
	var rectStoreItems:FlxSprite;

	public var groupButtonsSection:FlxTypedSpriteGroup<PuppetsButton>;

	public var groupbase:FlxTypedSpriteGroup<ItemHud>;
	public var groupadvanced:FlxTypedSpriteGroup<ItemHud>;

	var curGroup:FlxTypedSpriteGroup<ItemHud>;

	public function new()
	{
		super(0, 0);

		bg = new FlxSprite(0, 0).makeGraphic(360, 610, FlxColor.fromRGB(55, 55, 55));
		bg.visible = true;
		add(bg);

		rectSection = new FlxSprite(0, 0).makeGraphic(360, 20, FlxColor.TRANSPARENT);
		add(rectSection);

		rectStoreItems = new FlxSprite(0, 30).makeGraphic(360, 567, FlxColor.TRANSPARENT);
		add(rectStoreItems);

		groupbase = new FlxTypedSpriteGroup<ItemHud>();
		add(groupbase);

		groupadvanced = new FlxTypedSpriteGroup<ItemHud>();
		add(groupadvanced);

		groupButtonsSection = new FlxTypedSpriteGroup<PuppetsButton>();

		add(groupButtonsSection);

		for (key => i in sections)
		{
			var button = new PuppetsButton(key * (125 + 5), 0, i, function()
			{
				for (w in sections)
				{
					if (w == i)
					{
						updateStoreHud(i);
					}
				}
			}, PlayState.cameraHud);
			button.makeGraphic(125, 20, FlxColor.fromRGB(25, 25, 25));
			button.updateHitbox();
			button.text.color = FlxColor.WHITE;
			groupButtonsSection.add(button);
		}

		for (section in sections)
		{
			addStoreHud(section);
		}

		groupadvanced.y = 30;
		groupbase.y = 30;

		updateStoreHud('base');

		this.y = (FlxG.height - bg.height) / 2;
		this.x = FlxG.width + bg.width;
	}

	function addStoreHud(name:String)
	{
		var key = 0;

		for (itim in storeItems)
		{
			if (itim.section == name)
			{
				var it = new ItemHud(itim.item, key, true);

				it.x = (key % 5) * 75;
				it.y = Math.floor(key / 5) * 72.5;

				var field = Reflect.field(this, 'group' + name);

				var group:FlxTypedSpriteGroup<ItemHud> = cast field;

				group.add(it);

				key++;
			}
		}
	}

	function updateStoreHud(name:String)
	{
		for (i in sections)
		{
			var field = Reflect.field(this, 'group' + i);
			var groupp:FlxTypedSpriteGroup<ItemHud> = cast field;

			groupp.active = false;
			for (s in groupp)
			{
				s.icon.visible = false;
			}
		}

		var zanyto:Bool = sections.indexOf(name) != -1;

		var field = Reflect.field(this, 'group' + name);
		var groupp:FlxTypedSpriteGroup<ItemHud> = cast field;

		curGroup = groupp;
		if (groupp != null)
		{
			groupp.active = true;
			for (s in groupp)
			{
				s.icon.visible = true;
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		groupButtonsSection.forEach(function(button:PuppetsButton)
		{
			if (FlxG.overlap(button, bg))
				button.visible = true;
			else
				button.visible = false;
		});

		if (FlxG.keys.pressed.ALT && FlxG.keys.anyJustPressed([Data.getKey(shop)]))
		{
			open();
		}

		if (FlxG.mouse.wheel != 0)
		{
			if (rectSection.overlapsPoint(FlxG.mouse.getWorldPosition(PlayState.cameraHud)))
			{
				groupButtonsSection.x = groupButtonsSection.x + FlxG.mouse.wheel * 130;

				if (groupButtonsSection.x >= 1690)
					groupButtonsSection.x = 1560;
			}

			if (rectStoreItems.overlapsPoint(FlxG.mouse.getWorldPosition(PlayState.cameraHud)))
			{
				curGroup.y = curGroup.y + FlxG.mouse.wheel * 72.5;

				if (curGroup.y >= 337.5)
					curGroup.y = 265;
			}
		}
	}

	public function open()
	{
		if (!isOpen)
		{
			FlxTween.tween(this, {x: FlxG.width - bg.width}, 0.3);
		}
		if (isOpen)
		{
			FlxTween.tween(this, {x: FlxG.width + bg.width}, 0.3);
		}
		isOpen = !isOpen;
	}
}

class MapHud extends FlxSpriteGroup
{
	public var bg:PuppetsButton;
	public var bgmap:FlxSprite;
	public var iconsGroup:FlxSpriteGroup;

	public function new()
	{
		super(0, 0);

		bg = new PuppetsButton(0, 0, '', function name()
		{
			var worldX = (FlxG.mouse.gameX - this.x) / 276 * (2000 - 0) + 0;
			var worldY = (FlxG.mouse.gameY - this.y) / 269 * (2000 - 0) + 0;

			trace(FlxG.mouse.viewX - this.x, worldX);

			FlxG.camera.scroll.x = worldX - FlxG.width / 2;
			FlxG.camera.scroll.y = worldY - FlxG.height / 2;
		}, PlayState.cameraHud);
		bg.loadGraphic('assets/player/hud/map.png');
		add(bg);

		bgmap = new FlxSprite(0, 0).loadGraphic('assets/maps/map.png');
		bgmap.setGraphicSize(276, 269);
		bgmap.updateHitbox();
		add(bgmap);

		iconsGroup = new FlxSpriteGroup();
		add(iconsGroup);

		this.x = 0;
		this.y = FlxG.height - bg.height;
	}
	public function addIcon(entity:Entity)
	{
		trace('MapIcon' + entity.typeEntity);

		var icon = Type.createInstance(Type.resolveClass('game.hud.MapIcon' + entity.typeEntity), [entity, this]);

		iconsGroup.add(icon);
	}
}

class UpItemHud extends FlxSpriteGroup
{
	var bg:FlxSprite;
	var groupPeople:FlxSpriteGroup;
	var groupPuppets:FlxSpriteGroup;

	public function new()
	{
		super(0, 0);

		bg = new FlxSprite(0, 0).loadGraphic('assets/player/hud/up.png');
		add(bg);

		groupPeople = new FlxSpriteGroup();
		add(groupPeople);

		groupPuppets = new FlxSpriteGroup();
		add(groupPuppets);

		this.x = (FlxG.width - this.width) / 2;
	}

	public function updateHud()
	{
		var keypeople:Int = 0;
		var keypuppets:Int = 0;

		for (i in groupPeople)
		{
			i.destroy();
		}
		groupPeople.clear();

		for (z in groupPuppets)
		{
			z.destroy();
		}
		groupPuppets.clear();

		for (i in PlayState.groupEntities)
		{
			if (i.typeEntity == CHARACTER)
			{
				if (i.team == people)
				{
					var icon = new PuppetsButton(4 + keypeople * (60 + 4), 2, '', function()
					{
						PlayState.setFocusOnPlayerAndUpdateHud(i);
						FlxG.camera.follow(i.playerCamera, LOCKON);
					}, PlayState.cameraHud);
					icon.loadGraphic(getSprite(i));
					icon.setGraphicSize(60, 60);
					icon.updateHitbox();
					keypeople++;
					groupPeople.add(icon);
				}
			}
		}

		for (i in PlayState.groupEntities)
		{
			if (i.typeEntity == CHARACTER)
			{
				if (i.team == puppets)
				{
					var icon = new PuppetsButton(437 + keypuppets * (60 + 4), 2, '', function()
					{
						PlayState.setFocusOnPlayerAndUpdateHud(i);
						FlxG.camera.follow(i.playerCamera, LOCKON);
					}, PlayState.cameraHud);
					icon.loadGraphic(getSprite(i));
					icon.setGraphicSize(60, 60);
					icon.updateHitbox();
					keypuppets++;
					groupPuppets.add(icon);
				}
			}
		}
	}

	function getSprite(entity:Entity)
	{
		var nameCharacter = Type.getClassName(Type.getClass(entity)).split(".");
		var tempNameCharacter = nameCharacter[nameCharacter.length - 1];

		if (nameCharacter != null)
		{
			var path = 'assets/player/characters/' + tempNameCharacter.toLowerCase() + '/icon.png';
			if (FileSystem.exists(path))
			{
				return path;
			}
			else
			{
				return 'assets/player/characters/null_icon.png';
			}
		}

		return 'assets/player/characters/null_icon.png';
	}
}
