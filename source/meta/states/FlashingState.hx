package meta.states; 

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;
	
	var Ididit:Bool = false;
	var warnText:FlxText;
	
	var fg:FlxSprite;
	override function create()
	{
		super.create();

		
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights!\n
			Press ENTER to disable them now or go to Options Menu.\n
			Press ESCAPE to ignore this message.\n
			You've been warned!",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
				fg = new FlxSprite().loadGraphic(Paths.image('taskbarwarning'));
		add(fg);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				if (Ididit)
				{
					leftState = true;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					if(!back) {
						ClientPrefs.flashing = false;
						ClientPrefs.saveSettings();
						FlxG.sound.play(Paths.sound('confirmMenu'));
						FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
							new FlxTimer().start(0.5, function (tmr:FlxTimer) {
								#if HIT_SINGLE
								MusicBeatState.switchState(new HitSingleMenu());
								#else
								MusicBeatState.switchState(new MainMenuState());
								#end
							});
						});
					} else {
						FlxG.sound.play(Paths.sound('cancelMenu'));
						FlxTween.tween(warnText, {alpha: 0}, 1, {
							onComplete: function (twn:FlxTween) {
								#if HIT_SINGLE
								MusicBeatState.switchState(new HitSingleMenu());
								#else
								MusicBeatState.switchState(new MainMenuState());
								#end
							}
						});
					}
				}
				else
				{
					fg.visible = false;
					Ididit = true;
				}
				
			}
		}
		super.update(elapsed);
	}
}
