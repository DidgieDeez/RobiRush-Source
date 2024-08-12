package meta.states; 

#if desktop
import meta.data.Discord.DiscordClient;
#end
import flixel.*;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import hscript.Interp;

import flixel.addons.display.FlxBackdrop;

import flixel.util.FlxColor;
import lime.app.Application;
import gameObjects.*;
import meta.data.*;
import meta.data.Achievements.AchievementObject;
import meta.data.Discord.DiscordClient;
import meta.data.options.*;
import meta.states.*;
import meta.states.editors.*;
import meta.states.editors.*;
import meta.states.substate.*;
import meta.states.editors.MasterEditorMenu;

import openfl.Lib;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.MouseButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

using StringTools;

class RobiWreckState extends MusicBeatState
{
	var levelinit:Bool = false;
	
	var robisgrp:FlxTypedGroup<Robi>;
	
	var level:Int = 0;
	
	var robicount:Int = 0;
	
	
	var starttext:Array<String> = [
		'click all the robis!!!!!',
		'spike the robis!!!!!',
		'third'
	];
	
	var endtext:Array<String> = [
		'good job',
		'YESSS YESS HAHA',
		'third end'
	];

	var bg:FlxSprite;

	override function create()
	{
		
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()), 1);
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Robi Wreck", null);
		#end

		
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = false;

		persistentUpdate = persistentDraw = true;
		
		bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
		bg.setGraphicSize(FlxG.width,FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = false;
		add(bg);
		
		robisgrp = new FlxTypedGroup<Robi>();
		add(robisgrp);


		StartLevel();


		super.create();
	}



	override function update(elapsed:Float)
	{
			if (robicount > 0)
			{
				robisgrp.forEach(function(spr:Robi)
				{
					if (FlxG.mouse.overlaps(spr))
					{
						if(FlxG.mouse.pressed)
						{
							spr.kill();
							robisgrp.remove(spr);
							spr.destroy();
							robicount--;
							trace(robicount + ' left');
						}
					}
				});
			}
		if (levelinit)
		{
			
			if (robicount <= 0)
			{
				robisgrp.clear();
				levelinit = false;
				EndLevel();
			}
		}


		super.update(elapsed);

		if(controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		}
		
	}
	

	function StartLevel()
	{
		Application.current.window.alert(starttext[level], "Robi Wreck");
		bg.loadGraphic(Paths.image('menuBG'));
		
		for (i in 0...25)
		{
			trace('robi spawn!!');
			var newrobi:Robi = new Robi(FlxG.random.int(100, 1000), FlxG.random.int(100, 600));
			robisgrp.add(newrobi);
			robicount++;
		}
		levelinit = true;
	}
	
	function EndLevel()
	{
		Application.current.window.alert(endtext[level], "Robi Wreck");
		level++;
		StartLevel();
	}
}

class Robi extends FlxSprite
{
	var xspeed:Int = FlxG.random.int(-200, 200);
	var yspeed:Int = FlxG.random.int(-200, 200);
	
    public function new(?X:Float = 0, ?Y:Float = 0)
        {
            super(X, Y);
			loadGraphic(Paths.image('robi'));
			scale.set(2, 2);
			updateHitbox();
        }


    override function update(elapsed:Float) 
	{		
        if (this.x > FlxG.width)
			x = (1 - this.width);
		if (this.x < (0 - this.width))
			x = (FlxG.width - 1);
		if (this.y > FlxG.height)
			y = (1 - this.height);
		if (this.y < (0 - this.height))
			y = (FlxG.height - 1);
			
		x += (xspeed * elapsed);
		y += (yspeed * elapsed);
    } 
		

}
