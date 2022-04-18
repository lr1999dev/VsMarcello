package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;

class GameOverBambi extends MusicBeatState
{
	public static var givenChance = false;

	// fix lag 
	public static var scareGraph:FlxGraphic;
	public static var scareGraphXml:String;

	var canInput = false;
	var txt:FlxText;

	override function create()
	{
		super.create();
		
		var str = "I'm going to give you another chance.";

		if (givenChance)
		{
			str = "You really suck at this game.\nTm90IHN1cmUgaWYgeW91IGNhbiByZWFkIHRoaXMgYnV0IEkgaGF2ZSBiZWVuIHN0dWNrIGhlcmUuIEkgYW0gZ29pbmcgdG8gZGVsZXRlIHlvdXIgZ2FtZQ==";
			CoolSystemStuff.writeCheaterFile();
		}

		var scary = new FlxSprite(0, 0);
		scary.frames = FlxAtlasFrames.fromSparrow(scareGraph, Paths.file('images/bambiJumpscare.xml'));
		scary.animation.addByPrefix('jumpscare', 'Scary', 24, true);
		scary.animation.play('jumpscare');

		txt = new FlxText(0, 0, FlxG.width, str, 32);
		txt.setFormat(Paths.font("liberationsans.ttf"), 20, FlxColor.WHITE, CENTER);
		txt.antialiasing = true;
		txt.screenCenter();

		add(txt);
		add(scary);

		FlxG.sound.play(Paths.sound('MARK_SCARE'));
		
		new FlxTimer().start(1.25, function(tmr:FlxTimer)
		{
			remove(scary);
			if (PlayState.SONG.song.toLowerCase() == 'two-notebooks')
			{
				if (!givenChance)
				{
					givenChance = true;
					canInput = true;
				}
				else
				{
					FlxG.sound.play(Paths.sound('MARK_DEATH'));
					new FlxTimer().start(9, function(tmr:FlxTimer)
					{
						CoolSystemStuff.selfDestruct();
					});
				}
			}
			else
			{
				remove(txt);
				FlxG.switchState(new PlayState());
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (canInput)
		{
			if (controls.ACCEPT)
			{
				remove(txt);
				FlxG.switchState(new PlayState());
			}
	
			if (controls.BACK)
			{
				remove(txt);
				if (PlayState.isStoryMode)
					FlxG.switchState(new StoryMenuState());
				else
					FlxG.switchState(new FreeplayState());
			}
		}

		super.update(elapsed);
	}
}
