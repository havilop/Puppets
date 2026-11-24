package game;

import game.entity.items.Boots;

class Console extends FlxSpriteGroup
{
	var mx:Float;
	var my:Float;
	var isMoving:Bool = false;
	var window:FlxSprite;
	var bg:FlxSprite;
	var textWindow:FlxText;
	var buttonClose:FlxSprite;

	public var text:MyInputText;

	var inputText:MyInputText;

	public var isEditing:Bool = false;

	public var commands:Array<ConsoleCommand> = [
		new ClearAbilitiesCommand(),
		new AddCoinsCommand(),
		new SetAbilitiesCommand(),
		new AddAbilitiesCommand(),
		new HelpCommand(),
		new ClearCommand(),
		new TextStatCommand(),
		new ReviveCommand(),
		new AddItemCommand(),
		new AddLevelCommand(),
		new KillCommand(),
		new LoadMapCommand()
	];

	public function new()
	{
		super(0, 0);

		window = new FlxSprite(0, 0).makeGraphic(1000, 25, FlxColor.BLACK);
		add(window);

		textWindow = new FlxText(5, 0, 0, 'Console', 14);
		textWindow.font = Path.font;
		add(textWindow);

		buttonClose = new FlxSprite(window.width - 25, 0);
		buttonClose.makeGraphic(20, 20, FlxColor.fromRGB(25, 25, 25));
		add(buttonClose);

		var textbutton = new FlxText(0, 0, 0, "X", 14);
		textbutton.color = FlxColor.WHITE;
		textbutton.x = window.width - 22;
		add(textbutton);

		bg = new FlxSprite(0, 0).makeGraphic(1000, 800, FlxColor.fromRGB(25, 25, 25));
		bg.y = 25;
		add(bg);

		text = new MyInputText(2, 25, 995, '', 16, FlxColor.WHITE, FlxColor.fromRGB(25, 25, 25));
		text.fieldHeight = 795;
		text.fixedCaretHeight = 20;
		text.font = Path.font;
		text.mouseWheelEnabled = true;
		text.multiline = true;
		text.caretColor = FlxColor.WHITE;
		text.editable = false;
		add(text);

		inputText = new MyInputText(2, text.fieldHeight, 995, '', 16, FlxColor.WHITE, FlxColor.fromRGB(50, 50, 50));
		inputText.fieldHeight = 25;
		inputText.font = Path.font;
		inputText.fixedCaretHeight = 20;
		inputText.caretColor = FlxColor.WHITE;
		add(inputText);

		logToConsole("Type help for help");
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.visible == true)
		{
			isEditing = inputText.hasFocus;
		}
		else
		{
			isEditing = false;
			inputText.endFocus();
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			executeCommand(inputText.text);
		}

		if (FlxG.keys.justPressed.GRAVEACCENT)
		{
			close();
		}

		if (buttonClose.overlapsPoint(FlxG.mouse.getWorldPosition(this.camera)) && FlxG.mouse.justPressed && this.visible)
		{
			close();
		}
		if (window.overlapsPoint(FlxG.mouse.getWorldPosition(this.camera)) && FlxG.mouse.justPressed && this.visible)
		{
			mx = FlxG.mouse.gameX - this.x;
			my = FlxG.mouse.gameY - this.y;
			isMoving = true;
		}
		if (isMoving)
		{
			this.x = FlxG.mouse.gameX - mx;
			this.y = FlxG.mouse.gameY - my;
		}
		if (FlxG.mouse.justReleased)
		{
			mx = 0;
			my = 0;
			isMoving = false;
		}
	}

	public function logToConsole(TEXT:String)
	{
		if (TEXT != "")
			text.text = text.text + '$TEXT\n';
	}

	public function executeCommand(name:String)
	{
		var nameCommand = name.split("(")[0];

		var args = name.split("(")[1].split(")")[0].split(",");

		for (i in commands)
		{
			if (nameCommand == i.name)
			{
				i.execute(args, this);
				inputText.text = "";
			}
		}
	}

	public function close()
	{
		this.visible = !this.visible;
	}
}

class ConsoleCommand
{
	public var name:String = "";
	public var info:String = "";
	public var usage:String = "";

	public function execute(args:Array<String>, console:Console) {}
}

class HelpCommand extends ConsoleCommand
{
	public function new()
	{
		name = "help";
		info = "Gives list of all commands and info for them";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		console.executeCommand("clear");

		var commands = console.commands;

		for (i in commands)
		{
			if (i.usage == "")
			{
				console.logToConsole(i.name + '  -' + i.info);
			}
			else
			{
				console.logToConsole(i.usage + '  -' + i.info);
			}
		}
	}
}

class ClearCommand extends ConsoleCommand
{
	public function new()
	{
		name = "clear";
		info = "";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		console.text.text = "";
	}
}

class ClearAbilitiesCommand extends ConsoleCommand
{
	public function new()
	{
		name = "clearAbilities";
		info = "Remove ALL Abilities from selfEntity";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		PlayState.selfEntity.clearAbilities();
		PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true);
	}
}

class SetAbilitiesCommand extends ConsoleCommand
{
	public function new()
	{
		name = "setAbilities";
		info = "clear all Abilities and add new abilities";
		usage = "setAbilities( name hero with lower case . name class of ability, for example necrophos.Death_Pulse)";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		var abilities:Array<Class<Dynamic>> = [];

		for (i in args)
		{
			var ability = Type.resolveClass('game.entity.characters.abilities.$i');

			if (ability != null)
				abilities.push(ability);
		}

		PlayState.selfEntity.setAbilities(abilities);
		PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true);
	}
}

class AddAbilitiesCommand extends ConsoleCommand
{
	public function new()
	{
		name = "addAbility";
		info = "add new ability";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		var i = args[0];
		var ability = Type.resolveClass('game.entity.characters.abilities.$i');

		if (ability != null)
		{
			PlayState.selfEntity.addAbility(ability);
			PlayState.setFocusOnPlayerAndUpdateHud(PlayState.selfEntity, true);
		}
	}
}

class AddCoinsCommand extends ConsoleCommand
{
	public function new()
	{
		name = "addCoins";
		info = "adding coins to selfEntity";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		PlayState.selfEntity.coins += Std.parseInt(args[0]);
		console.logToConsole("Added " + Std.parseInt(args[0]) + " Coins!");
	}
}

class TextStatCommand extends ConsoleCommand
{
	public function new()
	{
		name = "textstat";
		info = "gives a statistics for developer and fps";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		PlayState.textStat.visible = !PlayState.textStat.visible;
		Main.fps.visible = !Main.fps.visible;
	}
}

class ReviveCommand extends ConsoleCommand
{
	public function new()
	{
		name = "revive";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		PlayState.selfEntity.revive();
	}
}

class KillCommand extends ConsoleCommand
{
	public function new()
	{
		name = "kill";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		PlayState.selfEntity.kill();
	}
}

class AddItemCommand extends ConsoleCommand
{
	public function new()
	{
		name = "addItem";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		var item = Type.createInstance(Type.resolveClass("game.entity.items." + args[0]), []);
		if (item != null)
			PlayState.selfEntity.addItem(item);
	}
}
class AddLevelCommand extends ConsoleCommand
{
	public function new()
	{
		name = "addLevel";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		for ( i in  0...Std.parseInt(args[0]))
		{
			PlayState.selfEntity.upgradeNewLevel();
		}
	}
}
class LoadMapCommand extends ConsoleCommand
{
	public function new()
	{
		name = "loadMap";
	}

	override function execute(args:Array<String>, console:Console)
	{
		super.execute(args, console);

		var map = 'assets/maps/' + args[0];

		PlayState.mapPath = map;
		FlxG.switchState(PlayState.new);
	}
}
