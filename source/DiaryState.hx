package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DiaryState extends MusicBeatState
{
	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-300, -190);
		bg.loadGraphic(Paths.image('diary/diaryCover'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scale.y -= 0.28;
		bg.scale.x -= 0.28;
		add(bg);

		var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackShit.scale.set(0.3, 0.026);
		blackShit.alpha = 0.5;
		blackShit.y += 255;
		blackShit.alpha = 0.2;
		add(blackShit);

		var actionText:FlxText = new FlxText(250, 598, "The pages of this diary are lost... For now...", 32);
		actionText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		actionText.borderSize = 2.8;
		actionText.alpha = 0.2;
		add(actionText);

		FlxTween.tween(blackShit, {alpha: 0.5}, 2);
		FlxTween.tween(actionText, {alpha: 1}, 2);

        #if android
		addVirtualPad(NONE, B);
		#end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (!selectedSomethin)
		{
			if (controls.BACK)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new ExtrasState());
			}
		}

		super.update(elapsed);
	}
}
