package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var curMarcelloPort = 'marcelloPortrait';
	var isMarcelloSong:Bool = false;
	var defaultFont:String = "Pixel Arial 11 Bold";

	//i know these look retarded but i'm trying to fix a weird bug
	var bfDialogue:FlxTypeText;
	var marcelloDialogue:FlxTypeText;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'comecful':
				FlxG.sound.playMusic(Paths.music('sorryihavemylunch', 'marcello'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'markbattle':
				FlxG.sound.playMusic(Paths.music('moldy_be_like', 'marcello'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel', 'week6');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad', 'week6');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil', 'week6');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward', 'week6'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'comecful' | 'trollhazard' | 'blocking' | 'markbattle':
				hasDialog = true;
				isMarcelloSong = true;
				defaultFont = "Comic Sans MS";
				box.frames = Paths.getSparrowAtlas('dialogueBox-marcello', 'marcello');
				box.animation.addByPrefix('normalOpen', 'Cool text box', 24, false);
				box.animation.addByIndices('normal', 'Cool text box', [4], "", 24);
				if (PlayState.SONG.song.toLowerCase() == 'blocking')
				{
					curMarcelloPort = 'marcelloAngryPortrait';
				}
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (!isMarcelloSong)
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait', 'week6');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;

			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait', 'week6');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;

			portraitLeft.screenCenter(X);
			handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox', 'week6'));
			add(handSelect);
		}
		else
		{
			portraitLeft = new FlxSprite(200, 125).loadGraphic(Paths.image('portraits/' + curMarcelloPort, 'marcello'));
			portraitLeft.antialiasing = true;
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.15));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;

			portraitRight = new FlxSprite(800, 175).loadGraphic(Paths.image('portraits/boyfriendPortrait', 'marcello'));
			portraitRight.antialiasing = true;
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.175));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = defaultFont;
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = defaultFont;
		swagDialogue.color = 0xFF3F2021;
		if (!isMarcelloSong)
		{
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}
		add(swagDialogue);

		if (isMarcelloSong)
		{
			swagDialogue.antialiasing = true;
			//these look retarded but i'm trying to fix a weird bug
			bfDialogue = new FlxTypeText(240, 90000, Std.int(FlxG.width * 0.6), "", 32);
			bfDialogue.sounds = [FlxG.sound.load(Paths.sound('boyfriend_dialogue', 'marcello'), 0.6)];
			add(bfDialogue);
	
			marcelloDialogue = new FlxTypeText(240, 90000, Std.int(FlxG.width * 0.6), "", 32);
			marcelloDialogue.sounds = [FlxG.sound.load(Paths.sound((PlayState.SONG.song.toLowerCase() == 'blocking' ? 'marcelloAngry_dialogue' : 'marcello_dialogue'), 'marcello'), 0.6)];
			add(marcelloDialogue);
		}

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		if (isMarcelloSong)
		{
			swagDialogue.color = FlxColor.WHITE;
			dropText.alpha = 0;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound((isMarcelloSong ? 'clickTextModern' : 'clickText'), (isMarcelloSong ? 'marcello' : 'week6')), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'comecful' || PlayState.SONG.song.toLowerCase() == 'markbattle')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		if (isMarcelloSong)
		{
			if (curCharacter == 'bf')
			{
				marcelloDialogue.resetText('');
				marcelloDialogue.start(0.04, true);
				bfDialogue.resetText(dialogueList[0]);
				bfDialogue.start(0.04, true);
			}
			else
			{
				bfDialogue.resetText('');
				bfDialogue.start(0.04, true);
				marcelloDialogue.resetText(dialogueList[0]);
				marcelloDialogue.start(0.04, true);
			}
		}

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					if (!isMarcelloSong)
					{
						portraitLeft.animation.play('enter');
					}
					else
					{
						swagDialogue.y = 490;
						setFont('Comic Sans MS');
					}
				}
			case 'bf':
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					if (!isMarcelloSong)
					{
						portraitRight.animation.play('enter');
					}
					else
					{
						swagDialogue.y = 500;
						setFont('VCR OSD Mono');
					}
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
		#if windows
		dialogueList[0] = dialogueList[0].replace('%WINDOWSUSERNAME%', CoolSystemStuff.getUsername());
		#else
		if (dialogueList[0] == ':dad:#%WINDOWSUSERNAME%IsOverParty')
		{
			dialogueList[0] = ':dad:#YouAreOverParty';
		}
		#end
	}

	function setFont(fontName:String)
	{
		swagDialogue.font = fontName;
		dropText.font = fontName;
	}

	public function playBGFade()
	{
		bgFade.alpha = 0;
		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);
	}
}
