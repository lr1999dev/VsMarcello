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

        if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

        if (FlxG.save.data.songPosition == null)
            FlxG.save.data.songPosition = 0;

		if (FlxG.save.data.watermark == null)
			FlxG.save.data.watermark = true;
    }

	public static function resetToDefault()
	{
		FlxG.save.data.fps = true;
		FlxG.save.data.fpsCap = 120;
		FlxG.save.data.newInput = true;
		FlxG.save.data.downscroll = false;
		FlxG.save.data.dfjk = false;
		FlxG.save.data.accuracyDisplay = true;
		FlxG.save.data.offset = 0;
		FlxG.save.data.songPosition = 0;
		FlxG.save.data.watermark = true;
	}
}