import flixel.FlxG;

class KadeEngineData
{
    public static function initSave()
    {
		if (FlxG.save.data.fps == null)
			FlxG.save.data.fps = true;

		if (FlxG.save.data.fpsCap == null)
			FlxG.save.data.fpsCap = 120;

        if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;

		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
		
		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.accuracyDisplay == null)
			FlxG.save.data.accuracyDisplay = true;

		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

        if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

        if (FlxG.save.data.songPosition == null)
            FlxG.save.data.songPosition = false;
    }
}