package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.tweens.FlxTween;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('shpop'));
		var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		black.alpha = 0.8;
		bg.screenCenter();
		add(bg);
		add(black);

		var logo:FlxSprite = new FlxSprite(1000, 30).loadGraphic(Paths.image('modLogo'));
		logo.antialiasing = true;
		logo.scale.set(0.3, 0.3);
		logo.updateHitbox();
		add(logo);

		/*
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Kade Engine is Outdated!\n"
			+ MainMenuState.kadeEngineVer
			+ " is your current version\nwhile the most recent version is " + needVer
			+ "!\nPress Space to go to the github or ESCAPE to ignore this!!",
			32);
		*/
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"FNF: Marking Chaos is outdated!\n"
			+ "1.0"
			+ " is your current version\nwhile the most recent version is NO NEW VERSION LOL"
			+ "!\nPress Space to go to the mod page or ESCAPE to ignore this!!",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);

		FlxTween.angle(logo, 0, 360, 10, {type: LOOPING});
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.openURL("https://github.com/KadeDev/Kade-Engine/releases/latest");
		}
		if (controls.BACK)
		{
			leftState = true;
			FlxG.switchState(new SaveFileState());
		}
		super.update(elapsed);
	}
}
