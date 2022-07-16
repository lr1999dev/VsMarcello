package;

import Controls.KeyboardScheme;
import Controls.Control;
import openfl.Lib;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

class OptionsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];
	var descStrings:Array<String> = [];
	var curDesc = " ";

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;
	override function create()
	{
		var songPosThingy = ["off", "on", "time only", "bar only"];
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		controlsStrings = CoolUtil.coolStringFile(
			(FlxG.save.data.dfjk ? 'DFJK' : 'WASD') + 
			"\n" + (FlxG.save.data.newInput ? "New input" : "Old Input") + 
			"\n" + (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll') + 
			"\nAccuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on") + 
			"\nSong Position " + songPosThingy[FlxG.save.data.songPosition] +
			"\nFPS Cap" +
			"\nFPS Counter " + (!FlxG.save.data.fps ? "off" : "on") +
			"\nReset Button " + (!FlxG.save.data.resetButton ? "off" : "on") +
			"\nWatermark " + (!FlxG.save.data.watermark ? "off" : "on") +
			"\nReset to default");

		descStrings = CoolUtil.coolStringFile(
			"No description." + 
			"\nNo description." + 
			"\nChange the layout of the strumline." + 
			"\nDisplay accuracy information." + 
			"\nShow the songs current position (as a bar)" +
			"\nCap your FPS (Left for -10, Right for +10. SHIFT to go faster)" +
			"\nToggle the FPS Counter" +
			"\nToggle pressing R to gameover." +
			"\nToggle the watermark shown in the bottom left corner of gameplay." +
			"\nReset options to default");
		
		trace(controlsStrings);

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
				var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
				controlLabel.isMenuItem = true;
				controlLabel.targetY = i;
				grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}


		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset +  " - Description - No description.", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

			if (controls.BACK)
				FlxG.switchState(new MainMenuState());
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
			
			if (curSelected != 5)
			{
				if (controls.RIGHT_R)
				{
					FlxG.save.data.offset++;
					updateText("Offset (Left, Right): " + FlxG.save.data.offset +  " - Description - " + curDesc);
				}

				if (controls.LEFT_R)
				{
					FlxG.save.data.offset--;
					updateText("Offset (Left, Right): " + FlxG.save.data.offset +  " - Description - " + curDesc);
				}
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (FlxG.keys.pressed.RIGHT)
					{
						if (!(FlxG.save.data.fpsCap > 290))
						{
							FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
							updateText("Current FPS Cap: " + FlxG.save.data.fpsCap +  " - Description - " + curDesc);
						}
					}
					if (FlxG.keys.pressed.LEFT)
					{
						if (!(FlxG.save.data.fpsCap < 60))
						{
							FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
							updateText("Current FPS Cap: " + FlxG.save.data.fpsCap +  " - Description - " + curDesc);
						}
					}
				}
				else
				{
					if (FlxG.keys.justPressed.RIGHT)
					{
						if (!(FlxG.save.data.fpsCap > 290))
						{
							FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
							updateText("Current FPS Cap: " + FlxG.save.data.fpsCap +  " - Description - " + curDesc);
						}
					}
					if (FlxG.keys.justPressed.LEFT)
					{
						if (!(FlxG.save.data.fpsCap < 60))
						{
							FlxG.save.data.fpsCap = FlxG.save.data.fpsCap - 10;
							(cast (Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
							updateText("Current FPS Cap: " + FlxG.save.data.fpsCap +  " - Description - " + curDesc);
						}
					}
				}
			}
	
			if (controls.ACCEPT)
			{
				if (curSelected != 9)
					grpControls.remove(grpControls.members[curSelected]);
				switch(curSelected)
				{
					case 0:
						FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.dfjk ? 'DFJK' : 'WASD'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected;
						grpControls.add(ctrl);
						if (FlxG.save.data.dfjk)
							controls.setKeyboardScheme(KeyboardScheme.Solo, true);
						else
							controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);
						
					case 1:
						FlxG.save.data.newInput = !FlxG.save.data.newInput;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.newInput ? "New input" : "Old Input"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 1;
						grpControls.add(ctrl);
					case 2:
						FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, (FlxG.save.data.downscroll ? 'Downscroll' : 'Upscroll'), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 2;
						grpControls.add(ctrl);
					case 3:
						FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Accuracy " + (!FlxG.save.data.accuracyDisplay ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 3;
						grpControls.add(ctrl);
					case 4:
						if (FlxG.save.data.songPosition == 3)
							FlxG.save.data.songPosition = -1;

						FlxG.save.data.songPosition++;
						var songPosThingy = ["off", "on", "time only", "bar only"];
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Song Position " + songPosThingy[FlxG.save.data.songPosition], true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 4;
						grpControls.add(ctrl);
					case 5:
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "FPS Cap", true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 5;
						grpControls.add(ctrl);
					case 6:
						FlxG.save.data.fps = !FlxG.save.data.fps;
						(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "FPS Counter " + (!FlxG.save.data.fps ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 6;
						grpControls.add(ctrl);
					case 7:
						FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Reset Button " + (!FlxG.save.data.resetButton ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 7;
						grpControls.add(ctrl);
					case 8:
						FlxG.save.data.watermark = !FlxG.save.data.watermark;
						var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, "Watermark " + (!FlxG.save.data.watermark ? "off" : "on"), true, false);
						ctrl.isMenuItem = true;
						ctrl.targetY = curSelected - 8;
						grpControls.add(ctrl);
					case 9:
						KadeEngineData.resetToDefault();
						FlxG.resetState();
				}
			}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent('Fresh');
		#end
		
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		curDesc = descStrings[curSelected];
		updateText("Offset (Left, Right): " + FlxG.save.data.offset +  " - Description - " + curDesc);

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}

	function updateText(text:String = "WOY, WHAT THE FUCK EM TELL YOU")
	{
		versionShit.text = text;
	}
}
