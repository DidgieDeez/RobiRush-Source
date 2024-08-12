package meta.states.substate;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;

import flixel.addons.display.FlxBackdrop;

import meta.data.*;
import meta.states.*;
import gameObjects.*;

class DifficultySubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<FlxSprite>;

	var Difficulties:Array<String> = ['easy', 'normal', 'hard', 'hard+'];
	
	var curSelected:Int = 0;
	
	var canmove:Bool = false;
	
	var selection:FlxSprite;
	var lock:FlxSprite;
	
	var transition:FlxSprite;
	
	var islocked:Bool = true;
	
	var intendedScore:Int = 0;
	var scoreText:FlxText;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();
		Paths.currentModDirectory = 'ROBI';
		
		CoolUtil.difficulties = ["Easy", "Normal", "Hard", "Hard+"];
		
		if (Highscore.getScore('robi', 2) > 0)
			islocked = false;
		
		var cam:FlxCamera = FlxG.cameras.list[FlxG.cameras.list.length - 1];




		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('difficultymenu/bg'));
		bg.setGraphicSize(cam.width,cam.height);
		bg.alpha = 0;
		bg.screenCenter(XY);
		bg.scrollFactor.set();
		add(bg);
		
		var renderInf1:FlxBackdrop = new FlxBackdrop(Paths.image('difficultymenu/top'), 0, 0, true, false, 0,0);
		renderInf1.updateHitbox();
		renderInf1.velocity.set(40);
		renderInf1.antialiasing = false;
		renderInf1.y -= 200;
		add(renderInf1);
		
		var renderInf2:FlxBackdrop = new FlxBackdrop(Paths.image('difficultymenu/bottom'), 0, 0, true, false, 0,0);
		renderInf2.updateHitbox();
		renderInf2.y = (FlxG.height - renderInf2.height);
		renderInf2.velocity.set(-40);
		renderInf2.antialiasing = false;
		renderInf2.y += 200;
		add(renderInf2);
		
		

		FlxTween.tween(bg, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(renderInf1, {y: renderInf1.y + 200}, 0.6, {ease: FlxEase.sineOut, startDelay: 0.4});
		FlxTween.tween(renderInf2, {y: renderInf2.y - 200}, 0.6, {ease: FlxEase.sineOut, startDelay: 0.4});
		
		var thefreak:FlxSprite = new FlxSprite(-500, 200);
		thefreak.frames = Paths.getSparrowAtlas('difficultymenu/difficultyfreak');
		thefreak.scale.set(5, 5);
		thefreak.updateHitbox();
		thefreak.animation.addByPrefix('idle', 'idle', 24, true);
		thefreak.animation.play('idle');
		thefreak.antialiasing = false;
		add(thefreak);
		
		var nameboard:FlxSprite = new FlxSprite().loadGraphic(Paths.image('difficultymenu/nameboard'));
		nameboard.scale.set(5, 5);
		nameboard.updateHitbox();
		nameboard.y = 23;
		nameboard.x = -500;
		nameboard.antialiasing = false;
		add(nameboard);
		
		var scoreback:FlxSprite = new FlxSprite().loadGraphic(Paths.image('difficultymenu/scoreback'));
		scoreback.scale.set(5, 5);
		scoreback.updateHitbox();
		scoreback.y = (FlxG.height - scoreback.height -15);
		scoreback.x = -500;
		scoreback.antialiasing = false;
		add(scoreback);
		
		scoreText = new FlxText(-566, (FlxG.height - 146), 500, "", 50);
		scoreText.setFormat(Paths.font("retro.ttf"), 70, FlxColor.BLACK);
		scoreText.antialiasing = false;
		scoreText.alignment = "center";
		add(scoreText);
		
		var boardback:FlxSprite = new FlxSprite().loadGraphic(Paths.image('difficultymenu/boardback'));
		boardback.scale.set(5, 5);
		boardback.updateHitbox();
		boardback.screenCenter(Y);
		boardback.x = 1295;
		boardback.antialiasing = false;
		add(boardback);

		grpMenuShit = new FlxTypedGroup<FlxSprite>();
		add(grpMenuShit);
		
		selection = new FlxSprite(471, 0).loadGraphic(Paths.image('difficultymenu/point'));
		selection.scale.x = 5;
		selection.scale.y = 5;
		selection.updateHitbox();
		selection.antialiasing = false;
		add(selection);
		
		lock = new FlxSprite(471, 0).loadGraphic(Paths.image('difficultymenu/locked'));
		lock.scale.x = 5;
		lock.scale.y = 5;
		lock.updateHitbox();
		lock.antialiasing = false;
		if (islocked)
			lock.visible = true;
		else
			lock.visible = false;
		add(lock);

		regenMenu();
		cameras = [cam];
		
		FlxTween.tween(thefreak, {x: 150}, 1, {ease: FlxEase.quartOut, startDelay: 0.71});
		FlxTween.tween(nameboard, {x: 80}, 1, {ease: FlxEase.quartOut, startDelay: 0.7});
		FlxTween.tween(scoreback, {x: 80}, 1, {ease: FlxEase.quartOut, startDelay: 0.72});
		FlxTween.tween(scoreText, {x: 14}, 1, {ease: FlxEase.quartOut, startDelay: 0.72});
		FlxTween.tween(boardback, {x: 695}, 1, {ease: FlxEase.quartOut, startDelay: 0.73});
		for (i in grpMenuShit.members) {
			FlxTween.tween(i, {x: i.x - 600}, 1, {ease: FlxEase.quartOut, startDelay: 0.73});
		}
		FlxTween.tween(selection, {x: selection.x - 600}, 1, {ease: FlxEase.quartOut, startDelay: 0.73, 
		onComplete: function(tween:FlxTween)
		{
			canmove = true;
		}});
		FlxTween.tween(lock, {x: lock.x - 600}, 1, {ease: FlxEase.quartOut, startDelay: 0.73});
		
		transition = new FlxSprite();
		transition.frames = Paths.getSparrowAtlas('difficultymenu/thetrans');
		transition.setGraphicSize(cam.width,cam.height);
		transition.updateHitbox();
		transition.animation.addByPrefix('transition', 'transition', 24, false);
		transition.antialiasing = false;
		transition.visible = false;
		add(transition);
		
		super.create();
	}

	override function update(elapsed:Float)
	{

		super.update(elapsed);
		if (canmove)
		{
			if (controls.UI_UP_P)
			{
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				changeSelection(1);
			}

			var daSelected:String = Difficulties[curSelected];
			
			if (controls.BACK) {
				MainMenuState.goingtosong = false;
				FlxG.sound.play(Paths.sound('cancelMenu'), 1);
				close();
			}

			if (controls.ACCEPT)
			{
				MainMenuState.goingtosong = true;
				transition.visible = true;
				transition.animation.play('transition');
				FlxG.sound.play(Paths.sound('confirmMenu'));
				FlxG.sound.music.volume = 0;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					persistentUpdate = false;
					var songLowercase:String = Paths.formatToSongPath('robi');
					MainMenuState.poop = Highscore.formatSong(songLowercase, curSelected);
					MainMenuState.difficulty = curSelected;
					
					close();
				});	
			}
		}
	}



	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('difficultyselect'), 0.4);

		if (islocked)
		{
			if (curSelected < 0)
				curSelected = Difficulties.length - 2;
			if (curSelected >= Difficulties.length - 1)
				curSelected = 0;
		}
		else
		{
			if (curSelected < 0)
				curSelected = Difficulties.length - 1;
			if (curSelected >= Difficulties.length)
				curSelected = 0;
		}
		
		
		selection.y = grpMenuShit.members[curSelected].y - 20;
		selection.x = grpMenuShit.members[curSelected].x - (selection.width + 20);
		
		for (i in 0...grpMenuShit.members.length) {
			if (Difficulties[i] == 'hard+')
			{
				lock.y = grpMenuShit.members[i].y;
				lock.x = grpMenuShit.members[i].x - (lock.width + 13);
			}
		}
		
		
		scoreText.text = '' + Highscore.getScore('robi', curSelected);
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...Difficulties.length)
		{
			var item:FlxSprite = new FlxSprite(600, (i * 100) + 163).loadGraphic(Paths.image('difficultymenu/' + Difficulties[i]));
			
			item.scale.x = 5;
			item.scale.y = 5;
			item.updateHitbox();
			item.screenCenter(X);
			item.x += 880;
			item.scrollFactor.set();
			item.antialiasing = false;
			
			item.ID = i;
			grpMenuShit.add(item);
			item.updateHitbox();
		}
		curSelected = 0;
		changeSelection();
	}
}
