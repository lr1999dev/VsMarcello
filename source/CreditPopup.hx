package;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class CreditPopup extends FlxSpriteGroup
{

    public var bitchyBalls:FlxSprite;

	public function new(x:Float, y:Float, songy:String)
	{
        super(x, y);
        bitchyBalls = new FlxSprite().makeGraphic(400, 50, FlxColor.GREEN);
        bitchyBalls.alpha = 0.6;
        add(bitchyBalls);
        var funnyText:FlxText = new FlxText(1, 0, 650, 'Placeholder', 16);
        funnyText.setFormat(Paths.font(PlayState.defaultFont), 45, FlxColor.BLACK, LEFT);
        switch(songy.toLowerCase())
        {
            case 'tutorial':
                funnyText.text = 'Song by KawaiSprite';
                funnyText.setFormat(Paths.font(PlayState.defaultFont), 39, FlxColor.BLACK, LEFT);
                bitchyBalls.setGraphicSize(500, 50);
                bitchyBalls.updateHitbox();
            case 'comecful':
                funnyText.text = 'Song by MoldyGH';
            case 'two-notebooks':
                funnyText.setFormat(Paths.font(PlayState.defaultFont), 40, FlxColor.BLACK, LEFT);
                funnyText.text = 'Song by Grantare';
            case 'blocking' | 'something-important' | 'joldy' | 'are-you-cording' | 'old-blocking' | 'death-threats':
                funnyText.text = 'Song by Cynda';
            case 'trollhazard' | 'fun-house':
                funnyText.setFormat(Paths.font(PlayState.defaultFont), 40, FlxColor.BLACK, LEFT);
                funnyText.text = 'Song by Olyantwo';
            case 'old-comecful' | 'channel-plushies':
                funnyText.text = 'Song by T5mpler';
            case 'old-trollhazard':
                funnyText.text = 'Song by LR1999';
            case 'markbattle':
                funnyText.text = 'Song by LuisRandomness';
                funnyText.setFormat(Paths.font(PlayState.defaultFont), 38, FlxColor.BLACK, LEFT);
                bitchyBalls.setGraphicSize(500, 50);
                bitchyBalls.updateHitbox();
        }
        add(funnyText);
	}
}
