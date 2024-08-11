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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	public static var goingtosong:Bool = false;
	public static var poop:String = '';
	public static var difficulty:Int = 0;
	
	
	var optionShit:Array<String> = [
		'freeplay',
		'credits',
		'options'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;
	var Robomenu:FlxSprite;
	var BFmenu:FlxSprite;
	var windowDad:Window;
	
	var ultikey:Array<FlxKey> = [FlxKey.U, FlxKey.L, FlxKey.T, FlxKey.I];
	var lastKeysPressed:Array<FlxKey> = [];
	
	var secreteye:FlxSprite;
	
	var transition:FlxSprite;
	
	var ulti:FlxSprite;

	override function create()
	{
		
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();
		
		if(FlxG.save.data.keyget == null) FlxG.save.data.keyget = false;
		if(FlxG.save.data.anomalyspotted == null) FlxG.save.data.anomalyspotted = false;
		
		CoolUtil.difficulties = ["Easy", "Normal", "Hard", "Hard+"];
		
		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		
		if(FlxG.sound.music == null) {
			FlxG.sound.playMusic(Paths.music(KUTValueHandler.getMenuMusic()), 0);
		}

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		
		FlxG.mouse.visible = true;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		Conductor.changeBPM(127);
		persistentUpdate = persistentDraw = true;
		
		/*windowDad = Lib.application.createWindow({
			allowHighDPI: false,
			frameRate: 60,
            title: 'fuck you',
            width: 100,
            height: 100,
            borderless: false,
            alwaysOnTop: true

        });*/

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = false;
		add(bg);
		
		var renderInf1:FlxBackdrop = new FlxBackdrop(Paths.image('difficultymenu/top'), 0, 0, true, false, 0,0);
		renderInf1.updateHitbox();
		renderInf1.velocity.set(40);
		renderInf1.antialiasing = false;
		add(renderInf1);
		
		var renderInf2:FlxBackdrop = new FlxBackdrop(Paths.image('difficultymenu/bottom'), 0, 0, true, false, 0,0);
		renderInf2.updateHitbox();
		renderInf2.y = (FlxG.height - renderInf2.height);
		renderInf2.velocity.set(-40);
		renderInf2.antialiasing = false;
		add(renderInf2);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = false;
		add(magenta);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		secreteye = new FlxSprite(0, 25).loadGraphic(Paths.image('theeye'));
		secreteye.scale.set(1.25,1.25);
		secreteye.updateHitbox();
		secreteye.screenCenter(X);
		secreteye.antialiasing = false;
		if (FlxG.save.data.keyget == true && FlxG.save.data.anomalyspotted == false)
			add(secreteye);
		
		Robomenu = new FlxSprite(-20);
		Robomenu.frames = Paths.getSparrowAtlas('ROBOMENU');
		Robomenu.animation.addByPrefix('idle', 'robomenu', 12, false);
		Robomenu.scale.x = 3.5;
		Robomenu.scale.y = 3.6;
		Robomenu.antialiasing = false;
		Robomenu.updateHitbox();
		add(Robomenu);
		
		BFmenu = new FlxSprite();
		BFmenu.frames = Paths.getSparrowAtlas('BFMENU');
		BFmenu.animation.addByPrefix('idle', 'bfmenu', 12, false);
		BFmenu.scale.x = 3.5;
		BFmenu.scale.y = 3.6;
		BFmenu.antialiasing = false;
		BFmenu.updateHitbox();
		BFmenu.x = (FlxG.width - BFmenu.width + 70);
		add(BFmenu);
		
		var logo:FlxSprite = new FlxSprite(0, 25).loadGraphic(Paths.image('robirushlogo'));
		logo.scale.set(1.25,1.25);
		logo.updateHitbox();
		logo.screenCenter(X);
		logo.antialiasing = false;
		if (FlxG.save.data.keyget == false || FlxG.save.data.anomalyspotted == true)
			add(logo);
			
		ulti = new FlxSprite().loadGraphic(Paths.image('hiulti'));
		ulti.updateHitbox();
		ulti.screenCenter();
		ulti.alpha = 0;
		add(ulti);
		
		var scale:Float = 3.3;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 283;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 145)  + offset).loadGraphic(Paths.image('mainmenu/menu_' + optionShit[i]));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.antialiasing = false;
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Nightmare Vision Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end
		
		transition = new FlxSprite();
		transition.frames = Paths.getSparrowAtlas('difficultymenu/thetrans');
		transition.setGraphicSize(1280,720);
		transition.updateHitbox();
		transition.animation.addByPrefix('transition', 'transition', 24, false);
		transition.animation.addByPrefix('untransition', 'untransition', 24, false);
		transition.antialiasing = false;
		add(transition);
		transition.animation.play('untransition');

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;
	var canClick:Bool = true;
	
	var isDifferent:Bool = false;


	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		
		@:privateAccess
		if (FlxG.sound.music.volume < 0.8 && !goingtosong)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}
		
		var finalKey:FlxKey = FlxG.keys.firstJustPressed();
		if(finalKey != FlxKey.NONE) {
			lastKeysPressed.push(finalKey); //Convert int to FlxKey
			if(lastKeysPressed.length > ultikey.length)
			{
				lastKeysPressed.shift();
			}
				
			if(lastKeysPressed.length == ultikey.length)
			{
				
				for (i in 0...lastKeysPressed.length) {
					if(lastKeysPressed[i] != ultikey[i]) {
						isDifferent = true;
						break;
					}
				}

				if (!isDifferent) {
					FlxG.sound.play(Paths.sound('ulti'));
					ulti.alpha = 1;
					FlxTween.tween(ulti, {alpha: 0}, 3, {ease: FlxEase.linear});
				}
			}
		}
		
		menuItems.forEach(function(spr:FlxSprite)
		{
	
			if (FlxG.mouse.overlaps(spr))
			{
				if(canClick)
				{
					curSelected = spr.ID;
				}
					
				if(FlxG.mouse.pressed && canClick)
				{
					canClick = false;
					if (optionShit[curSelected] == 'freeplay')
					{
						openSubState(new DifficultySubState());
					}
					else
					{
						selectedSomethin = true;
						FlxG.sound.play(Paths.sound('confirmMenu'));

						if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

						menuItems.forEach(function(spr:FlxSprite)
						{
							if (curSelected != spr.ID)
							{
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
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									var daChoice:String = optionShit[curSelected];
									
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									
									transition.visible = true;
									transition.animation.play('transition');
									
									new FlxTimer().start(1, function(tmr:FlxTimer)
									{
										switch (daChoice)
										{
											case 'story_mode':
												MusicBeatState.switchState(new StoryMenuState());
											case 'awards':
												MusicBeatState.switchState(new AchievementsMenuState());
											case 'credits':
												MusicBeatState.switchState(new CreditsState());
											case 'options':
												LoadingState.loadAndSwitchState(new meta.data.options.OptionsState());
										}
									});	
									
								});
							}
						});
					}
				}
			}
			else if (FlxG.mouse.overlaps(secreteye))
			{
				if(FlxG.mouse.pressed && canClick && FlxG.save.data.keyget == true && FlxG.save.data.anomalyspotted == false)
				{
					Paths.currentModDirectory = 'ROBI';
					canClick = false;
					persistentUpdate = false;
					
					PlayState.storyPlaylist = ['robbedi'];
					PlayState.isStoryMode = false;
							
								
					PlayState.SONG = Song.loadFromJson('robbedi-hard', 'robbedi');
					PlayState.storyWeek = 0;
					PlayState.campaignScore = 0;
					
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
	
			spr.updateHitbox();
		});


		if (!selectedSomethin)
		{
			
			#if desktop
			if (FlxG.keys.anyJustPressed(debugKeys))
			{
				//selectedSomethin = true;
				//MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
		if(controls.RESET)
		{
			Highscore.resetSong('robi', 0);
			Highscore.resetSong('robi', 1);
			Highscore.resetSong('robi', 2);
			Highscore.resetSong('robi', 3);
		}
		
	}
	
	var danceLeft:Bool = false;
	override function beatHit()
	{
		super.beatHit();
		danceLeft = !danceLeft;
		if (danceLeft)
			Robomenu.animation.play('idle');
		else
			BFmenu.animation.play('idle');
		
	}
	
	override function closeSubState()
	{
		super.closeSubState();
		
		if (!goingtosong)
		{
			canClick = true;
		}
		else // silly solution but it works
		{
			var black:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			black.screenCenter();
			add(black);
			goingtosong = false;
			persistentUpdate = false;
			PlayState.SONG = Song.loadFromJson(poop, 'robi');
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = difficulty;
					
			LoadingState.loadAndSwitchState(new PlayState());
		}
			
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
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				spr.centerOffsets();
			}
		});
	}
}
