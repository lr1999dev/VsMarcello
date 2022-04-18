package;

import flixel.FlxSprite;
import flash.display.BitmapData;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	var curCharacter:String = 'bf';
	var initialized:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		
		switchIcon(char, isPlayer);

		scrollFactor.set();
	}

	public function switchIcon(char:String = 'bf', isPlayer:Bool = false)
	{
		var missing:Bool = false;

		if (!OpenFlAssets.exists(Paths.image('icons/icon-' + char), IMAGE))
			missing = true;
		
		if (!missing)
			loadGraphic(Paths.image('icons/icon-' + char), true, 150, 150);
		else
			makeGraphic(150, 150, 0xFFFB40F9);

		if (initialized)
		{
			animation.remove(curCharacter);
		}
		initialized = true;

		curCharacter = char;
		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);

		switch(char){
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel' | 'bambi' | 'bambi-evil' | 'bf-funhouse':
				{

				}
			default:
				{
					antialiasing = true;
				}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
