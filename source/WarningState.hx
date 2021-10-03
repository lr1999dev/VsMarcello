package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

class WarningState extends MusicBeatState
{
	override function create()
	{
		super.create();
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"WARNING!"
			+ "\n\nThis mod contains some words that may be offensive to some people. (e.g. racial slurs, homophobic slurs, etc)"
			+ "\nYou can turn off the \"Random Swear Words\" option in the Options menu."
			+ "\nPress Enter to continue...",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT)
		{
			FlxG.switchState(new TitleState());
		}
		super.update(elapsed);
	}
}
