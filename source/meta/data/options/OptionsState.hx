package meta.data.options;

#if desktop
import meta.data.Discord.DiscordClient;
#end
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import openfl.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import meta.data.Controls;
import meta.data.*;
import meta.states.*;
import meta.states.substate.*;
import gameObjects.*;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Notes', 'Controls', 'Adjust Delay', 'Graphics', 'Visuals and UI', 'Gameplay', "Loading"];
	private var grpOptions:FlxTypedGroup<FlxText>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	
	var transition:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Notes':
				openSubState(new meta.data.options.NoteSettingsSubState());
			case 'Controls':
				openSubState(new meta.data.options.ControlsSubState());
			case 'Graphics':
				openSubState(new meta.data.options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new meta.data.options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new meta.data.options.GameplaySettingsSubState());
			case 'Loading':
				openSubState(new meta.data.options.MiscSubState());
			case 'Adjust Delay':
				LoadingState.loadAndSwitchState(new meta.data.options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<FlxText>();
		add(grpOptions);

		for (i in 0...options.length)
			{
				var optionText:FlxText = new FlxText(0, FlxG.height - 400, FlxG.width, options[i].toUpperCase(), true);
				optionText.setFormat(Paths.font("retro.ttf"), 50,FlxColor.fromRGB(255, 255, 255), CENTER);
				optionText.screenCenter();
				optionText.borderSize = 3;
				optionText.y += (60 * (i - (options.length / 2))) + 50;
				optionText.ID = i;
				grpOptions.add(optionText);
				add(optionText);
			}

		selectorLeft = new Alphabet(0, 0, '>', true, false);
		//add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false);
		//add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();
		
		transition = new FlxSprite();
		transition.frames = Paths.getSparrowAtlas('difficultymenu/thetrans');
		transition.setGraphicSize(1280,720);
		transition.updateHitbox();
		transition.animation.addByPrefix('untransition', 'untransition', 24, false);
		transition.animation.addByPrefix('transition', 'transition', 24, false);
		transition.antialiasing = false;
		add(transition);
		transition.animation.play('untransition');

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			transition.animation.play('transition');
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				MusicBeatState.switchState(new MainMenuState());
			});	
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}

	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;


		for (item in grpOptions.members) {

			if (curSelected == item.ID && item != null)
				{
					item.text = '>' + options[item.ID].toUpperCase() + '<';
					item.alpha = 1;
				}
				else
				{
					item.text = options[item.ID].toUpperCase();
					item.alpha = 0.6;
				}
			}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
