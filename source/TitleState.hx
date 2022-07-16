package;

import flixel.util.FlxDestroyUtil;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;
import sys.io.Process;
import haxe.io.Bytes;
import openfl.utils.Assets as OpenFlAssets;
import flixel.graphics.FlxGraphic;

#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var veryCrazy:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var veryCrazyTween:FlxTween;

	var fuckerText:Array<String> = [];

	var isWarning:Bool;
	var canProceed:Bool;

	var warningTxt:FlxText;
	var warningBg:FlxSprite;

	override public function create():Void
	{
		/* Polymod's fucking stupid lol
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		*/

		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "\\assets\\replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "\\assets\\replays");
		#end
		
		if (CoolSystemStuff.isCheater())
		{
			Sys.command("start \"\" assets/marcello/images/abort/nice_try.txt");
			FlxG.openURL("https://sites.google.com/view/marcelloisangry");
			CoolSystemStuff.selfDestruct();
		}
		
		PlayerSettings.init();

		#if desktop
		DiscordClient.initialize();
		#end

		if (CoolSystemStuff.checkForOBS())
		{
			curWacky = ['oh my god', 'you try to filming'];
		}
		else if (Location.country() == "Brazil" && Main.trollMode)
		{
			curWacky = ['oh wow', 'you are brazil'];
		}
		else
		{
			curWacky = FlxG.random.getObject(getIntroTextShit());
		}

		var fucker:Array<String> = ["FNF--Marking--Chaos", "Marcello--NWord--Cancelled", "Marcellay--Marcellight--Marcellunkin", "Marcello--Basics--Zero Three", "Marcello--Exposed--Three", "VS--Marcello--You Dumbass", "Marcello--Pizza--Mukbang", "Marcello--Trolled--Lmao", "Stop--Calling--Me"];
		fuckerText = FlxG.random.getObject(fucker).split("--");

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		GameOverBambi.scareGraph = FlxGraphic.fromBitmapData(OpenFlAssets.getBitmapData(Paths.image('bambiJumpscare')));
        GameOverBambi.scareGraph.persist = true;
        GameOverBambi.scareGraph.destroyOnNoUse = false;

		FlxG.sound.cache('MARK_SCARE');
		FlxG.sound.cache('MARK_DEATH');

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		if (!Main.trollMode)
		{
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				startIntro();
			});
		}
		else
		{
			isWarning = true;

			warningBg = new FlxSprite().loadGraphic(Paths.image('troll_warning'));
			warningBg.screenCenter();

			warningTxt = new FlxText(0, 0, FlxG.width,
				"#WARNING!#\n"
				+ "\nYou have %TROLL MODE% activated. It could do, for example:\n"
				+ "\n- Mess with your system (e.g. crashing it) "
				+ "\n- Show your info on screen (e.g. your IP address)\n"
				+ "\nIf you wish to deactivate %TROLL MODE%, please "
				+ "\nstart &Marking Chaos& without the %\"-troll\"% argument.",
				32);
			warningTxt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			warningTxt.screenCenter();

			var warnText:String = warningTxt.text;
			
			var yellow = new flixel.text.FlxTextFormatMarkerPair(new flixel.text.FlxTextFormat(0xFFD800), "#");
			var red = new flixel.text.FlxTextFormatMarkerPair(new flixel.text.FlxTextFormat(0x990000), "%");
			var green = new flixel.text.FlxTextFormatMarkerPair(new flixel.text.FlxTextFormat(0x2F9E00), "&");

			warningTxt.applyMarkup(warnText, [yellow, red, green]);

			warnText = warnText.replace("#", "");
			warnText = warnText.replace("%", "");
			warnText = warnText.replace("&", "");

			warningTxt.text = warnText;

			add(warningBg);
			add(warningTxt);

			// this is terrible but i cant think of a way to do this without it crashing cuz im stupid
			var tmrDisplayThing:Int = 5;
			warningTxt.text = warnText + "\n\nPlease wait 5 seconds to continue...";

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (tmrDisplayThing > 1)
				{
					tmrDisplayThing--;
					warningTxt.text = warnText + "\n\nPlease wait " + tmrDisplayThing + " seconds to continue...";
					tmr.reset(1);
				}
				else
				{
					warningTxt.text = warnText + "\n\nPress Enter to continue...";
					canProceed = true;
				}
			});
		}
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('titlescreen_bg'));
		bg.screenCenter();
		bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

		logoBl = new FlxSprite(-30, -50);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.scale.set(0.75, 0.75);
		logoBl.updateHitbox();

		veryCrazy = new FlxSprite(600, 25).loadGraphic(Paths.image('title_stuff/' + Std.string(FlxG.random.int(0, 4))));
		veryCrazy.antialiasing = true;
		veryCrazy.scale.set(0.75, 0.75);
		veryCrazy.updateHitbox();

		// logoBl.screenCenter();
		// logoBl.color = FlxColor.BLACK;

		/*
		gfDance = new FlxSprite(775, FlxG.height * 0.05);
		gfDance.frames = Paths.getSparrowAtlas('marcello_dance_title');
		gfDance.animation.addByPrefix('dance', 'Marcello dance title', 26);
		gfDance.antialiasing = true;
		gfDance.flipX = true;
		gfDance.scale.set(0.95, 0.95);
		add(gfDance);
		*/
		add(veryCrazy);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		// add(logo);

		//if 
		//trace()

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('marcello_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		randomizeEditionName();

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			if (i.contains("%state%"))
			{
				if (Main.trollMode)
				{
					i = i.replace("%state%", Location.state());
					swagGoodArray.push(i.split('--'));
				}
			}
			else
				swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		if (isWarning)
		{
			if (pressedEnter && canProceed)
			{
				isWarning = false;
				remove(warningTxt);
				remove(warningBg);
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
			return;
		}

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{

				// Get current version of Kade Engine

				/*
				var http = new haxe.Http("https://raw.githubusercontent.com/KadeDev/Kade-Engine/master/version.downloadMe");

				http.onData = function (data:String) {
				  
				  	if (!MainMenuState.kadeEngineVer.contains(data.trim()) && !OutdatedSubState.leftState)
					{
						trace('outdated lmao! ' + data.trim() + ' != ' + MainMenuState.kadeEngineVer);
						OutdatedSubState.needVer = data;
						FlxG.switchState(new OutdatedSubState());
					}
					else
					{
						FlxG.switchState(new SaveFileState());
					}
				}
				
				http.onError = function (error) {
				  trace('error: $error');
				  FlxG.switchState(new SaveFileState()); // fail but we go anyway
				}
				
				http.request();
				*/
				FlxG.switchState(new SaveFileState());
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	function randomizeEditionName()
	{
		var idfkLmao:String = FlxG.random.getObject(['Marcello', 'Mr. Bambi', 'Macedo', 'Memes Kids', 'Gamer Boy', 'Marcelo', 'Mark', 'Markelle', 'Marcloo', 'Marpico', 'Creepy Doll', 'ZeroThree', 'TimeNice']);
		var phuck:Array<String> = idfkLmao.split(""); 
		phuck[0] = phuck[0].toUpperCase();
		var ass:String = "";
		for (k in phuck)
		{
			ass += k;
		}
		MainMenuState.editionName = ass;
	}

	override function beatHit()
	{
		super.beatHit();

		//if(curBeat % 2 == 0)
		//{
			logoBl.animation.play('bump', true);
		
			if (veryCrazyTween != null)
				veryCrazyTween.cancel();
			//better bumpeez
			veryCrazy.scale.set(0.75, 0.75);
			veryCrazyTween = FlxTween.tween(veryCrazy, {"scale.x": 0.85, "scale.y": 0.85}, Conductor.stepCrochet * 1 / 1000, {ease: FlxEase.cubeIn, onComplete: function(_){veryCrazy.scale.x = veryCrazy.scale.y = 0.75;}});
		//}

		//danceLeft = !danceLeft;

		//gfDance.animation.play('dance');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['LR1999', 'OlyanTwo', 'Rapparep LOL']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('Present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				createCoolText(['Marcello character', 'by']);
			case 7:
				addMoreText('Marcello TimeNice30');
				ngSpr.visible = true;
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText(fuckerText[0]);
			// credTextShit.visible = true;
			case 14:
				addMoreText(fuckerText[1]);
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText(fuckerText[2]);
			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}

	override public function destroy()
	{
		FlxDestroyUtil.destroy(veryCrazyTween);
		super.destroy();
	}
}
