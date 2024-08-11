package meta.states;

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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import meta.data.*;
import gameObjects.*;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	var guys:FlxTypedGroup<FlxSprite>;

	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;
	
	var transition:FlxSprite;

	var offsetThing:Float = -75;
	
	var peeps:Array<String> = [
		'didgie',
		'xarion',
		'roborecona',
		'adrev'
	];

	var links:Array<String> = [
		'https://twitter.com/DidgieDeez2',
		'https://twitter.com/Xar1on',
		'https://twitter.com/roborecona',
		'https://twitter.com/INeedAdRevenue'
	];

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('credits/creditbg'));
		bg.setGraphicSize(1280,720);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = false;
		add(bg);
		
		var credtext:FlxSprite = new FlxSprite().loadGraphic(Paths.image('credits/text'));
		credtext.scale.x = 1.65;
		credtext.scale.y = 1.65;
		credtext.updateHitbox();
		credtext.antialiasing = false;
		credtext.y += 25;
		credtext.screenCenter(X);
		add(credtext);
		
		guys = new FlxTypedGroup<FlxSprite>();
		add(guys);

		for (i in 0...peeps.length)
		{
			var guy:FlxSprite = new FlxSprite().loadGraphic(Paths.image('credits/' + peeps[i]));
			guy.scale.x = 1.65;
			guy.scale.y = 1.65;
			guy.updateHitbox();
			guy.updateFramePixels();
			guy.antialiasing = false;
			guy.y += 25;
			guy.ID = i;
			guy.x = 285;
			guy.x += (172 * i);
			guys.add(guy);
		}
		
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

	var quitting:Bool = false;
	override function update(elapsed:Float)
	{
		if(!quitting)
		{
			if (controls.BACK)
			{
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				transition.animation.play('transition');
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuState());
				});	
				quitting = true;
			}
			guys.forEach(function(spr:FlxSprite)
			{
		
				if (FlxG.mouse.overlaps(spr))
				{
						
					if(FlxG.mouse.justPressed)
					{
						CoolUtil.browserLoad(links[spr.ID]);
					}
				}
		
				spr.updateHitbox();
			});
		}
		super.update(elapsed);
	}


}