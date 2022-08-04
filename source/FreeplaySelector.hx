package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FreeplaySelector extends MusicBeatState
{
	var curSelected:Int = 1;
	var sideShit:Array<String> = [
		'spinoffs',
		'story',
		'sidestory'
	];

	var actionText:FlxText;
	
	var sideItemA:FlxSprite;
	var sideItemB:FlxSprite;
	var sideItemC:FlxSprite;
	var sidLockA:FlxSprite;
	var sidLockB:FlxSprite;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		FlxG.sound.music.stop();

		var bg:FlxSprite = new FlxSprite(-30, -20);
		bg.loadGraphic(Paths.image('menuCorrupt'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scale.y -= 0.04;
		bg.scale.x -= 0.04;
		add(bg);

		var bg:FlxSprite = new FlxSprite(-30, -20);
		bg.loadGraphic(Paths.image('targets/menubars'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scale.y -= 0.04;
		bg.scale.x -= 0.04;
		add(bg);

		var sidBlack:FlxSprite = new FlxSprite(-200, 150);
		sidBlack.frames = Paths.getSparrowAtlas('targets/dif');
		sidBlack.animation.addByPrefix('idle', 'def', 24, false);
		sidBlack.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidBlack);

		var sidBlack:FlxSprite = new FlxSprite(355, 150);
		sidBlack.frames = Paths.getSparrowAtlas('targets/dif');
		sidBlack.animation.addByPrefix('idle', 'def', 24, false);
		sidBlack.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidBlack);

		var sidBlack:FlxSprite = new FlxSprite(900, 150);
		sidBlack.frames = Paths.getSparrowAtlas('targets/dif');
		sidBlack.animation.addByPrefix('idle', 'def', 24, false);
		sidBlack.antialiasing = ClientPrefs.globalAntialiasing;
		add(sidBlack);

		sideItemA = new FlxSprite(-200, 150);
		sideItemA.loadGraphic(Paths.image('targets/' + sideShit[0]));
		sideItemA.setGraphicSize(Std.int(sideItemA.width * 0.75));
		sideItemA.antialiasing = ClientPrefs.globalAntialiasing;
		sideItemA.alpha = 0.5;
		add(sideItemA);

		sideItemB = new FlxSprite(355, 150);
		sideItemB.loadGraphic(Paths.image('targets/' + sideShit[1]));
		sideItemB.setGraphicSize(Std.int(sideItemB.width * 0.9));
		sideItemB.antialiasing = ClientPrefs.globalAntialiasing;
		add(sideItemB);

		sideItemC = new FlxSprite(900, 150);
		sideItemC.loadGraphic(Paths.image('targets/' + sideShit[2]));
		sideItemC.setGraphicSize(Std.int(sideItemC.width * 0.75));
		sideItemC.antialiasing = ClientPrefs.globalAntialiasing;
		sideItemC.alpha = 0.5;
		add(sideItemC);

		sidLockA = new FlxSprite(-860, -226);
		sidLockA.loadGraphic(Paths.image('targets/locked'));
		sidLockA.antialiasing = ClientPrefs.globalAntialiasing;
		sidLockA.setGraphicSize(Std.int(sidLockA.width * 0.25));
		sidLockA.alpha = 0.8;
		add(sidLockA);

		sidLockB = new FlxSprite(240, -226);
		sidLockB.loadGraphic(Paths.image('targets/locked'));
		sidLockB.antialiasing = ClientPrefs.globalAntialiasing;
		sidLockB.setGraphicSize(Std.int(sidLockB.width * 0.25));
		sidLockB.alpha = 0.8;
		add(sidLockB);

		var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.scale.set(0.3, 0.026);
		blackShit.alpha = 0.5;
		blackShit.y += 255;
		add(blackShit);

		actionText = new FlxText(350, 598, "", 32);
		actionText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		actionText.borderSize = 2.8;
		add(actionText);

		leftArrow = new FlxSprite(150, 330);
		leftArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow.animation.addByPrefix('idle', 'arrow left');
		leftArrow.animation.addByPrefix('press', 'arrow push left');
		add(leftArrow);

		rightArrow = new FlxSprite(1140, 330);
		rightArrow.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', 'arrow push right', 24, false);
		rightArrow.animation.play('idle');
		add(rightArrow);

		var stateDesc:FlxSprite = new FlxSprite(380, 55);
		stateDesc.loadGraphic(Paths.image('targets/m3'));
		stateDesc.antialiasing = ClientPrefs.globalAntialiasing;
		add(stateDesc);

		changeItem();

        #if android
		addVirtualPad(LEFT_RIGHT, A_B);
		#end

		FlxG.sound.playMusic(Paths.music('takeover_freeplay'));

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				FlxG.sound.playMusic(Paths.music('takeover_menu_lem'), 0);
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}

			if (controls.ACCEPT)
			{
				var daChoice:String = sideShit[curSelected];

				if (daChoice == 'story')
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					sideItemB.color = 0xFF33ffff;
					FlxFlicker.flicker(sideItemB, 1.1, 0.15, false);

					new FlxTimer().start(0.5, function(tmr:FlxTimer)
					{
						MusicBeatState.switchState(new FreeplayState());
					});
				}
				else
				{
					actionText.text = 'There are things that you must not see yet';
					actionText.x = 280;
					FlxG.sound.play(Paths.sound('lock'));
				}
			}
		}

		if (controls.UI_RIGHT)
			rightArrow.animation.play('press')
		else
			rightArrow.animation.play('idle');

		if (controls.UI_LEFT)
			leftArrow.animation.play('press');
		else
			leftArrow.animation.play('idle');

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= sideShit.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = sideShit.length - 1;

		switch (curSelected)
		{
			case 0:
				FlxTween.tween(sideItemA, {x: 355}, 0.29);
				FlxTween.tween(sideItemB, {x: 900}, 0.29);
				FlxTween.tween(sideItemC, {x: -200}, 0.29);
				FlxTween.tween(sidLockA, {x: -860 + 565}, 0.29); 
				FlxTween.tween(sidLockB, {x: -860}, 0.29);

				sideItemA.setGraphicSize(Std.int(sideItemA.width * 0.9));
				sideItemB.setGraphicSize(Std.int(sideItemB.width * 0.75));
				sideItemC.setGraphicSize(Std.int(sideItemA.width * 0.75));

				actionText.text = 'Echoes from another time.';
				actionText.x = 415;

			case 1:
				FlxTween.tween(sideItemA, {x: -200}, 0.29);
				FlxTween.tween(sideItemB, {x: 355}, 0.29);
				FlxTween.tween(sideItemC, {x: 900}, 0.29);
				FlxTween.tween(sidLockA, {x: -860}, 0.29);
				FlxTween.tween(sidLockB, {x: 240}, 0.29);

				sideItemA.setGraphicSize(Std.int(sideItemA.width * 0.75));
				sideItemB.setGraphicSize(Std.int(sideItemB.width * 0.9));
				sideItemC.setGraphicSize(Std.int(sideItemA.width * 0.75));

				actionText.text = 'The main story of this tragedy.';
				actionText.x = 350;

			case 2:	
				FlxTween.tween(sideItemA, {x: 900}, 0.29);
				FlxTween.tween(sideItemB, {x: -200}, 0.29);
				FlxTween.tween(sideItemC, {x: 355}, 0.29);
				FlxTween.tween(sidLockA, {x: -860}, 0.29); 
				FlxTween.tween(sidLockB, {x: -860 + 565}, 0.29);

				sideItemA.setGraphicSize(Std.int(sideItemA.width * 0.75));
				sideItemB.setGraphicSize(Std.int(sideItemB.width * 0.75));
				sideItemC.setGraphicSize(Std.int(sideItemA.width * 0.9));

				actionText.text = 'There are survivors?';
				actionText.x = 460;
		}
	}
}
