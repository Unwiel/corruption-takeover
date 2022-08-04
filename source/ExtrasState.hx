package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class ExtrasState extends MusicBeatState
{
	var lock:FlxSprite;
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = [
		'CREDITS',
		'DIARY',
		'GAMEJOLT',
		'MODS'
	];

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-30, -20);
		bg.loadGraphic(Paths.image('menubackgrounds/' + TitleState.bgGenerated));
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

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6) scr = 0;
			var menuItem:FlxSprite = new FlxSprite(-50, (i * 140)  + offset);
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
			menuItem.animation.play('idle');
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.ID = i;
			menuItem.updateHitbox();
			menuItem.scale.x = 0.82;
			menuItem.scale.y = 0.82;
			menuItem.y -= 20;
			menuItems.add(menuItem);
		}

		menuItems.members[2].alpha = 0.6;

		lock = new FlxSprite(540, 400);
		lock.frames = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		lock.animation.addByPrefix('idle', 'lock', 24, false);
		lock.antialiasing = ClientPrefs.globalAntialiasing;
		lock.animation.play('idle');
		add(lock);

		changeItem();

        #if android
		addVirtualPad(UP_DOWN, A_B);
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				if (curSelected == 2)
					FlxG.sound.play(Paths.sound('lock'));
				else
				{
					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(lock, {alpha: 0}, 0.4);
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxG.sound.play(Paths.sound('confirmMenu'));

							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'CREDITS':
										MusicBeatState.switchState(new CreditsState());
									case 'DIARY':
										MusicBeatState.switchState(new DiaryState());
									case 'MODS':
										MusicBeatState.switchState(new ModsMenuState());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				var add:Float = 0;
				if (menuItems.length > 4) 
					add = menuItems.length * 8;
				spr.animation.play('selected');
				spr.centerOffsets();
			}
		});
	}
}
