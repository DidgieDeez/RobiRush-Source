addHaxeLibrary('FlxG', 'flixel');
addHaxeLibrary('FlxCamera', 'flixel');
addHaxeLibrary('ShaderFilter', 'openfl.filters');
addHaxeLibrary('Window', 'lime.ui');
addHaxeLibrary('Application', 'openfl.display');
addHaxeLibrary('Application', 'lime.app');
addHaxeLibrary('Sprite', 'openfl.display');
addHaxeLibrary('Matrix', 'openfl.geom');
addHaxeLibrary('Rectangle', 'openfl.geom');
addHaxeLibrary('RenderContext', 'lime.graphics');
addHaxeLibrary('MouseButton', 'lime.ui');
addHaxeLibrary('KeyCode', 'lime.ui');
addHaxeLibrary('KeyModifier', 'lime.ui');
addHaxeLibrary('Assets', 'openfl.utils');
addHaxeLibrary('FlxEase', 'flixel.tweens');
addHaxeLibrary('FlxTween', 'flixel.tweens');
addHaxeLibrary('FlxSpriteGroup', 'flixel.group');
addHaxeLibrary('ColorSwap', 'gameObjects.shader');
addHaxeLibrary('FlxFlicker', 'flixel.effects');
addHaxeLibrary('FlxSpriteUtil', 'flixel.util');
addHaxeLibrary('FlxStringUtil', 'flixel.util');
// most of these are unused now oops

var OGsauceX:Int = 0;
var OGsauceY:Int = 0;

var bg:FlxSprite;
var maskGroup:FlxSpriteGroup;
var mask1:FlxSprite;
var mask2:FlxSprite;
var magicfect:FlxSprite;

var secretkey:FlxSprite;
var keyspawned:Bool = false;

var beattosendkey:Int = 999;

var testrobi:Character;
var coolrobi:Character;
var magirobi:Character;
var marirobi:Character;
var chefrobi:Character;
var boxyrobi:Character;
var fredrobi:Character;
var gunrobi:Character;
var diffy:String;

var purple = newShader('purple');
purple.data.hue.value = [1.6];
purple.data.pix.value = [0.00001];

var destinations:Array<Float> = [0,0,0,0,0,0,0,0];

var cursinger:String = 'robi';

var magicing:Bool = false;
var flipping:Bool = false;
var nextmagic:Float = 0;
var nextflip:Float = 0;

function onLoad(){
	OGsauceX = Lib.application.window.x;
	OGsauceY = Lib.application.window.y;

	diffy = CoolUtil.difficulties[PlayState.storyDifficulty];

	game.skipCountdown = true;
	
	Lib.application.window.fullscreen = true;
	var fsX = Lib.application.window.width;
	var fsY = Lib.application.window.height;
	Lib.application.window.fullscreen = false;

	var bL = new FlxSprite().loadGraphic(Paths.image('hud cover'));
    bL.antialiasing = false;
	if(!ClientPrefs.downScroll)
		bL.flipY = true;
	if (diffy != "Hard+")
		add(bL);
    bL.cameras = [game.camHUD];
	
	if (diffy == "Hard+" && ClientPrefs.fakeDesktop)
	{
		if(!ClientPrefs.downScroll)
			game.spawnTime = 370;
		else
			game.spawnTime = 400;
	}
	
	// hopefully should stop some of teh lagspikes
	game.precacheList.set('magicoff', 'sound');
	game.precacheList.set('magiccast', 'sound');
	game.precacheList.set('healthfall', 'sound');
	game.precacheList.set('plane', 'image');
	game.precacheList.set('GHOST', 'image');
	game.precacheList.set('GHOST', 'image');
	game.precacheList.set('planewindow1', 'image');
	game.precacheList.set('planewindow2', 'image');
	game.precacheList.set('planewindow3', 'image');
	game.precacheList.set('flippedplanewindow1', 'image');
	game.precacheList.set('flippedplanewindow2', 'image');
	game.precacheList.set('flippedplanewindow3', 'image');
	game.precacheList.set('distract', 'image');
	
	magicfect = new FlxSprite().loadGraphic(Paths.image('magicstart'));
    magicfect.antialiasing = false;
	if(!ClientPrefs.downScroll)
		magicfect.flipY = true;
    magicfect.cameras = [game.camHUD];
	
	if (!ClientPrefs.fakeDesktop)
	{
		game.camGame.bgColor = 0xFF000001;
		FlxTransWindow.getWindowsTransparent();
	}
	else
	{	
		game.camGame.bgColor = 0xFF000000;
		FlxTransWindow.getWindowsbackward();
		var fakedesktop = new FlxSprite().loadGraphic(Paths.image('fakedesktop'));
		fakedesktop.scrollFactor.set(0,0);
		fakedesktop.scale.set(2.5,2.5);
		fakedesktop.updateHitbox();
		fakedesktop.screenCenter();
		if(!ClientPrefs.downScroll && diffy != "Hard+")
			fakedesktop.y -= 250;
		add(fakedesktop);
		
	}

    bg = new FlxSprite(210, 60).loadGraphic(Paths.image('BG'));
    bg.scale.set(1.5,1.5);
	bg.antialiasing = true;
    add(bg);
	
		FlxG.mouse.useSystemCursor = true;
	
	
	Main.fpsVar.visible = false;
	
	Lib.application.window.borderless = false;
	Lib.application.window.resize(fsX, fsY);
	Lib.application.window.move(0, 0);
	Application.current.window.focus();
	FlxG.autoPause = false;
	
	testrobi = new Character(120, (409), 'robiBF'); 
	game.dadGroup.add(testrobi);
	testrobi.cameras = [game.camOverlay];
	
	coolrobi = new Character(-50, 424, 'robicool'); 
	game.dadGroup.add(coolrobi);
	coolrobi.cameras = [game.camOverlay];
	
	magirobi = new Character(550, 420, 'robiCHEF'); 
	game.dadGroup.add(magirobi);
	magirobi.cameras = [game.camOverlay];
	
	marirobi = new Character(720, 413, 'robiMARIO'); 
	game.dadGroup.add(marirobi);
	marirobi.cameras = [game.camOverlay];
	
	fredrobi = new Character(-220, 425, 'robiFREDDY'); 
	game.dadGroup.add(fredrobi);
	fredrobi.cameras = [game.camOverlay];
	
	gunrobi = new Character(850, 409, 'robigun'); 
	game.dadGroup.add(gunrobi);
	gunrobi.cameras = [game.camOverlay];
	
	if (diffy == "Hard+" || !ClientPrefs.downScroll)
	{
		testrobi.y += 147;
		coolrobi.y += 147;
		magirobi.y += 147;
		marirobi.y += 147;
		fredrobi.y += 147;
		gunrobi.y += 147;
	}
	
	chefrobi = new Character(300, 33, 'robimagic'); 
	
	boxyrobi = new Character(1300, 31, 'robiboxer');
	
	testrobi.visible = false;
	coolrobi.visible = false;
	magirobi.visible = false;
	marirobi.visible = false;
	fredrobi.visible = false;
	gunrobi.visible = false;
	chefrobi.visible = false;
	boxyrobi.visible = false;

	maskGroup = new FlxSpriteGroup(300, 100);
}

function onSpawnNotePost(dunceNote){
	if (diffy == "Hard+")
	{
		dunceNote.cameras = [game.camGame];
		dunceNote.scrollFactor.set(1, 1);

	}
}

function spawnNoteSplash(splash)
{
	if (diffy == "Hard+")
	{
		splash.cameras = [game.camGame];
		splash.scrollFactor.set(1, 1);
	}
}

function onCreatePost() 
{
	game.camHUD.setFilters([new ShaderFilter(purple)]);
	game.camHUD.setFilters([]);


	GameOverSubstate.characterName = "boyfrend";
	
	healthBarBG.cameras = [game.camGame];
		healthBar.cameras = [game.camGame];
		game.iconP1.cameras = [game.camGame];
		game.iconP2.cameras = [game.camGame];
		game.iconP1.x += 160;
		game.iconP1.y += 220;
		game.iconP2.x += 160;
		game.iconP2.y += 220;
		healthBarBG.x += 160;
		healthBarBG.y += 220;
		healthBar.x += 160;
		scoreTxt.x += 160;
		scoreTxt.y += 220;
		healthBar.y += 220;
		scoreTxt.cameras = [game.camGame];
		scoreTxt.scrollFactor.set(1, 1);
		healthBar.scrollFactor.set(1, 1);
		healthBarBG.scrollFactor.set(1, 1);
		game.iconP1.scrollFactor.set(1, 1);
		game.iconP2.scrollFactor.set(1, 1);
	if (diffy == "Hard+")
	{
		opponentStrums.cameras = [game.camGame];
		playerStrums.cameras = [game.camGame];
		modManager.setValue('transformX', 160);
		modManager.setValue('transformY', 220);
	   // modManager.setValue('beat', 0.5);
	   // modManager.setValue('confusion', 0.5);
		for(i in 0...opponentStrums.members.length){
			opponentStrums.members[i].scrollFactor.set(1, 1);
			playerStrums.members[i].scrollFactor.set(1, 1);
			
		}
		game.timeBar.cameras = [game.camGame];
		game.timeTxt.cameras = [game.camGame];
		game.timeBarBG.cameras = [game.camGame];
		game.timeBar.scrollFactor.set(1, 1);
		game.timeTxt.scrollFactor.set(1, 1);
		game.timeBarBG.scrollFactor.set(1, 1);
		game.timeBar.x += 160;
		game.timeBar.y += 200;
		game.timeTxt.x += 160;
		game.timeTxt.y += 200;
		game.timeBarBG.x += 160;
		game.timeBarBG.y += 200;
	}
	else if(ClientPrefs.downScroll)
	{
		modManager.setValue('transformY', 20);
	}
	else if(!ClientPrefs.downScroll)
	{
		modManager.setValue('transformY', -8);
		game.camGame.y += 100;
		game.scoreTxt.y -= 550;
		game.healthBar.y -= 580;
		game.healthBarBG.y -= 580;
		game.iconP1.y -= 580;
		game.iconP2.y -= 580;
		game.timeBar.y -= 10;
		game.timeTxt.y -= 10;
		game.timeBarBG.y -= 10;
	}
	
	secretkey = new FlxSprite(2400, 500).loadGraphic(Paths.image('key'));
	secretkey.antialiasing = true;
	secretkey.updateHitbox();
	
	beattosendkey = FlxG.random.int(10,500);
	
	
}

function postReceptorGeneration()
{
	add(maskGroup);
	mask1 = new FlxSprite(100,-400).makeGraphic(1, 1, 0xFF000001);
    mask1.scale.set(1500,600);
    mask1.updateHitbox();
    mask1.scrollFactor.set(1,1);
	mask2 = new FlxSprite(100,927).makeGraphic(1, 1, 0xFF000001);
    mask2.scale.set(1500,650);
    mask2.updateHitbox();
    mask2.scrollFactor.set(1,1);
	if (diffy == "Hard+" && !ClientPrefs.fakeDesktop)
	{
    insert(50, mask1);
    insert(52, mask2);
	}
	var bgoverlay = new FlxSprite(210, 60).loadGraphic(Paths.image('BGoverlay'));
    bgoverlay.scale.set(1.5,1.5);
	bgoverlay.antialiasing = true;
    insert(51, bgoverlay);
	
	insert(53, chefrobi);
	insert(53, boxyrobi);
}

function onUpdatePost(elapsed)
{
	if (Conductor.songPosition < 172828)
	{
		game.songPercent = ((Conductor.songPosition - ClientPrefs.noteOffset) / (songLength - 51800));
		timeTxt.text = FlxStringUtil.formatTime(Math.floor(((songLength - 51800) - (Conductor.songPosition - ClientPrefs.noteOffset)) / 1000), false);
	}
}

function update(elapsed) {

	if (FlxG.mouse.overlaps(secretkey) && FlxG.mouse.justPressed)
	{
		FlxG.save.data.keyget = true;
		FlxG.save.flush();
		secretkey.visible = false;
	}
	if (keyspawned)
		secretkey.updateHitbox();
	if (magicing)
	{
		modManager.setValue('drunk', FlxMath.lerp(modManager.getValue('drunk'), nextmagic, 0.04));
	}
	if (flipping)
	{
		modManager.setValue('beat', FlxMath.lerp(modManager.getValue('beat'), nextflip, 0.06));
	}

    game.camZooming = false;
	
	if (testrobi.velocity.x > 0)
	{
		if (testrobi.x > destinations[0])
		{
			testrobi.velocity.x = 0;
			testrobi.playAnim('idle', true);
			if (testrobi.x >= 650)
				testrobi.flipX = true;
			else
				testrobi.flipX = false;
		}
	}
	else if (testrobi.velocity.x < 0)
	{
		if (testrobi.x < destinations[0])
		{
			testrobi.velocity.x = 0;
			testrobi.playAnim('idle', true);
			if (testrobi.x >= 650)
				testrobi.flipX = true;
			else
				testrobi.flipX = false;
		}
	}
	
	if (coolrobi.velocity.x > 0)
	{
		if (coolrobi.x > destinations[1])
		{
			coolrobi.velocity.x = 0;
			coolrobi.playAnim('idle', true);
			if (coolrobi.x >= 650)
				coolrobi.flipX = true;
			else
				coolrobi.flipX = false;
		}
	}
	else if (coolrobi.velocity.x < 0)
	{
		if (coolrobi.x < destinations[1])
		{
			coolrobi.velocity.x = 0;
			coolrobi.playAnim('idle', true);
			if (coolrobi.x >= 650)
				coolrobi.flipX = true;
			else
				coolrobi.flipX = false;
		}
	}
	
	if (magirobi.velocity.x > 0)
	{
		if (magirobi.x > destinations[2])
		{
			magirobi.velocity.x = 0;
			magirobi.playAnim('idle', true);
			if (magirobi.x >= 650)
				magirobi.flipX = true;
			else
				magirobi.flipX = false;
		}
	}
	else if (magirobi.velocity.x < 0)
	{
		if (magirobi.x < destinations[2])
		{
			magirobi.velocity.x = 0;
			magirobi.playAnim('idle', true);
			if (magirobi.x >= 650)
				magirobi.flipX = true;
			else
				magirobi.flipX = false;
		}
	}
	
	if (marirobi.velocity.x > 0)
	{
		if (marirobi.x > destinations[3])
		{
			marirobi.velocity.x = 0;
			marirobi.playAnim('idle', true);
			if (marirobi.x >= 650)
				marirobi.flipX = true;
			else
				marirobi.flipX = false;
		}
	}
	else if (marirobi.velocity.x < 0)
	{
		if (marirobi.x < destinations[3])
		{
			marirobi.velocity.x = 0;
			marirobi.playAnim('idle', true);
			if (marirobi.x >= 650)
				marirobi.flipX = true;
			else
				marirobi.flipX = false;
		}
	}
	
	if (chefrobi.velocity.x > 0)
	{
		if (chefrobi.x > destinations[4])
		{
			chefrobi.velocity.x = 0;
			chefrobi.playAnim('idle', true);
			if (chefrobi.x >= 900)
				chefrobi.flipX = true;
			else
				chefrobi.flipX = false;
		}
	}
	else if (chefrobi.velocity.x < 0)
	{
		if (chefrobi.x < destinations[4])
		{
			chefrobi.velocity.x = 0;
			chefrobi.playAnim('idle', true);
			if (chefrobi.x >= 900)
				chefrobi.flipX = true;
			else
				chefrobi.flipX = false;
		}
	}
	
	if (boxyrobi.velocity.x > 0)
	{
		if (boxyrobi.x > destinations[5])
		{
			boxyrobi.velocity.x = 0;
			boxyrobi.playAnim('idle', true);
			if (boxyrobi.x >= 900)
				boxyrobi.flipX = true;
			else
				boxyrobi.flipX = false;
		}
	}
	else if (boxyrobi.velocity.x < 0)
	{
		if (boxyrobi.x < destinations[5])
		{
			boxyrobi.velocity.x = 0;
			boxyrobi.playAnim('idle', true);
			if (boxyrobi.x >= 900)
				boxyrobi.flipX = true;
			else
				boxyrobi.flipX = false;
		}
	}
	
	if (fredrobi.velocity.x > 0)
	{
		if (fredrobi.x > destinations[6])
		{
			fredrobi.velocity.x = 0;
			fredrobi.playAnim('idle', true);
			if (fredrobi.x >= 650)
				fredrobi.flipX = true;
			else
				fredrobi.flipX = false;
		}
	}
	else if (fredrobi.velocity.x < 0)
	{
		if (fredrobi.x < destinations[6])
		{
			fredrobi.velocity.x = 0;
			fredrobi.playAnim('idle', true);
			if (fredrobi.x >= 650)
				fredrobi.flipX = true;
			else
				fredrobi.flipX = false;
		}
	}
	
	if (gunrobi.velocity.x > 0)
	{
		if (gunrobi.x > destinations[7])
		{
			gunrobi.velocity.x = 0;
			gunrobi.playAnim('idle', true);
			if (gunrobi.x >= 650)
				gunrobi.flipX = true;
			else
				gunrobi.flipX = false;
		}
	}
	else if (gunrobi.velocity.x < 0)
	{
		if (gunrobi.x < destinations[7])
		{
			gunrobi.velocity.x = 0;
			gunrobi.playAnim('idle', true);
			if (gunrobi.x >= 650)
				gunrobi.flipX = true;
			else
				gunrobi.flipX = false;
		}
	}
}

var lastplayedanim:String;

function opponentNoteHit(note){
	var animToPlay:String;
	var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
	switch(cursinger)
	{
		case 'robiBF':
			testrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			testrobi.specialAnim = true;
		case 'robicool':
			coolrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			coolrobi.specialAnim = true;
		case 'robiCHEF':
			magirobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			magirobi.specialAnim = true;
		case 'robiMARIO':
			marirobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			marirobi.specialAnim = true;
		case 'robimagic':
			chefrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			chefrobi.specialAnim = true;
		case 'robiboxer':
			boxyrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			boxyrobi.specialAnim = true;
		case 'robiFREDDY':
			fredrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			fredrobi.specialAnim = true;
		case 'robigun':
			gunrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			gunrobi.specialAnim = true;
		case 'all':
			gunrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			gunrobi.specialAnim = true;
			fredrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			fredrobi.specialAnim = true;
			boxyrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			boxyrobi.specialAnim = true;
			chefrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			chefrobi.specialAnim = true;
			marirobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			marirobi.specialAnim = true;
			magirobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			magirobi.specialAnim = true;
			coolrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			coolrobi.specialAnim = true;
			testrobi.playAnim(singAnimations[Std.int(Math.abs(note.noteData))], true);
			testrobi.specialAnim = true;
		default:
			if (!note.isSustainNote)
			{
				if (FlxG.random.bool(50))
				{
					animToPlay = singAnimations[Std.int(Math.abs(note.noteData))] + '-alt';
				}
				else
				{
					animToPlay = singAnimations[Std.int(Math.abs(note.noteData))];
				}
			}
			else
			{
				animToPlay = lastplayedanim;
			}
			
			game.dad.playAnim(animToPlay, true);
			game.dad.specialAnim = true;
			lastplayedanim = animToPlay;
	}
	
	
}

function onFocusLost()
{
		Application.current.window.focus();
}

function onBeatHit()
{
	testrobi.dance();
	coolrobi.dance();
	magirobi.dance();
	marirobi.dance();
	fredrobi.dance();
	gunrobi.dance();
	chefrobi.dance();
	boxyrobi.dance();
	if (curBeat >= beattosendkey)
	{
		if (diffy == "Easy" && !keyspawned && FlxG.save.data.keyget != true)
		{
			if (FlxG.random.bool(0.5))
			{
				keyspawned = true;
				insert(99,secretkey);
				secretkey.velocity.x -= 30;
			}
		}
	}
}

function onDestroy() 
{
	game.camGame.y = 0;
    FlxTransWindow.getWindowsbackward();
	FlxG.autoPause = true;
    FlxG.mouse.useSystemCursor = false;
    Application.current.window.borderless = false;
	Application.current.window.resize(1280, 720);
	Application.current.window.focus();
	Main.fpsVar.visible = ClientPrefs.showFPS;
	Lib.application.window.move(OGsauceX, OGsauceY);
}

function onEvent(name, v1, v2)
{
	if (name == 'Change Robi')
	{
		cursinger = v1;
	}
	else if (name == 'Walker Andy')
	{
		switch(v1)
		{
			case 'robiBF':
				destinations[0] = (testrobi.x + Std.parseFloat(v2));
				testrobi.playAnim('walk', true);
				testrobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					testrobi.velocity.x = 100;
					testrobi.flipX = false;
				}
				else
				{
					testrobi.velocity.x = -100;
					testrobi.flipX = true;
				}
			case 'robicool':
				destinations[1] = (coolrobi.x + Std.parseFloat(v2));
				coolrobi.playAnim('walk', true);
				coolrobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					coolrobi.velocity.x = 100;
					coolrobi.flipX = false;
				}
				else
				{
					coolrobi.velocity.x = -100;
					coolrobi.flipX = true;
				}
			case 'robiCHEF':
				destinations[2] = (magirobi.x + Std.parseFloat(v2));
				magirobi.playAnim('walk', true);
				magirobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					magirobi.velocity.x = 100;
					magirobi.flipX = false;
				}
				else
				{
					magirobi.velocity.x = -100;
					magirobi.flipX = true;
				}
			case 'robiMARIO':
				destinations[3] = (marirobi.x + Std.parseFloat(v2));
				marirobi.playAnim('walk', true);
				marirobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					marirobi.velocity.x = 100;
					marirobi.flipX = false;
				}
				else
				{
					marirobi.velocity.x = -100;
					marirobi.flipX = true;
				}
			case 'robimagic':
				destinations[4] = (chefrobi.x + Std.parseFloat(v2));
				chefrobi.playAnim('walk', true);
				chefrobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					chefrobi.velocity.x = 300;
					chefrobi.flipX = false;
				}
				else
				{
					chefrobi.velocity.x = -300;
					chefrobi.flipX = true;
				}
			case 'robiboxer':
				destinations[5] = (boxyrobi.x + Std.parseFloat(v2));
				boxyrobi.playAnim('walk', true);
				boxyrobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					boxyrobi.velocity.x = 300;
					boxyrobi.flipX = false;
				}
				else
				{
					boxyrobi.velocity.x = -300;
					boxyrobi.flipX = true;
				}
			case 'robiFREDDY':
				destinations[6] = (fredrobi.x + Std.parseFloat(v2));
				fredrobi.playAnim('walk', true);
				fredrobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					fredrobi.velocity.x = 100;
					fredrobi.flipX = false;
				}
				else
				{
					fredrobi.velocity.x = -100;
					fredrobi.flipX = true;
				}
			case 'robigun':
				destinations[7] = (gunrobi.x + Std.parseFloat(v2));
				gunrobi.playAnim('walk', true);
				gunrobi.specialAnim = true;
				if (Std.parseFloat(v2) > 0)
				{
					gunrobi.velocity.x = 100;
					gunrobi.flipX = false;
				}
				else
				{
					gunrobi.velocity.x = -100;
					gunrobi.flipX = true;
				}
		}
	}
	else if (name == 'Spawn Robi')
	{
		switch(v1)
		{
			case 'robiBF':
				testrobi.visible = true;
			case 'robicool':
				coolrobi.visible = true;
			case 'robiCHEF':
				magirobi.visible = true;
			case 'robiMARIO':
				marirobi.visible = true;
			case 'robimagic':
					chefrobi.visible = true;
			case 'robiboxer':
					boxyrobi.visible = true;
			case 'robiFREDDY':
				fredrobi.visible = true;
			case 'robigun':
				gunrobi.visible = true;
		}
	}
	else if (name == 'magic')
	{
		nextmagic  = v1;
		magicing = true;
		if (v2  == 'off')
		{
			FlxG.sound.play(Paths.sound("magicoff"));
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				modManager.setValue('drunk', v1);
			});
		}
		else
		{
			game.camHUD.setFilters([new ShaderFilter(purple)]);
			FlxG.sound.play(Paths.sound("magiccast"));
			chefrobi.playAnim('magic', true);
			chefrobi.specialAnim = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				game.camHUD.setFilters([]);
				magicing = false;
				chefrobi.playAnim('idle', true);
				modManager.setValue('drunk', v1);
			});
		}
		
	}
	else if (name == 'flip')
	{
		nextflip  = v1;
		flipping = true;
		if (v2  == 'off')
		{
			FlxG.sound.play(Paths.sound("magicoff"));
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				modManager.setValue('beat', v1);
			});
		}
		else
		{

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				flipping = false;
				modManager.setValue('beat', v1);
			});
		}
		
	}
	else if (name == 'KILL THEM')
	{
		testrobi.visible = false;
		coolrobi.visible = false;
		magirobi.visible = false;
		marirobi.visible = false;
		chefrobi.visible = false;
		boxyrobi.visible = false;
		fredrobi.visible = false;
		gunrobi.visible = false;
		for(i in 0...destinations.length){
			var ghost = new FlxSprite(50 * i, 200);
			ghost.frames = Paths.getSparrowAtlas('GHOST');
			ghost.animation.addByPrefix('ghost','ghost',12, true);
			ghost.cameras = [game.camOverlay];
			ghost.antialiasing = false;
			ghost.scale.set(2,2);
			ghost.animation.play('ghost');
			switch(i)
			{
				case 0:
						ghost.y = testrobi.y;
						ghost.x = testrobi.x + 27;
				case 1:
						ghost.y = coolrobi.y - 10;
						ghost.x = coolrobi.x + 8;
				case 2:
						ghost.y = magirobi.y - 10;
						ghost.x = magirobi.x + 24;
				case 3:
						ghost.y = marirobi.y - 5;
						ghost.x = marirobi.x + 24;
				case 4:
						ghost.scale.set(6,6);
						ghost.cameras = [game.camGame];
						ghost.updateHitbox();
						ghost.y = chefrobi.y - 85;
						ghost.x = chefrobi.x - 35;
						ghost.velocity.y -= 40;
				case 5:
						ghost.scale.set(6,6);
						ghost.cameras = [game.camGame];
						ghost.updateHitbox();
						ghost.y = boxyrobi.y - 65;
						ghost.x = boxyrobi.x - 15;
						ghost.velocity.y -= 40;
				case 6:
						ghost.y = fredrobi.y - 5;
						ghost.x = fredrobi.x + 18;
				case 7:
						ghost.y = gunrobi.y + 5;
						ghost.x = gunrobi.x + 30;
			}
			ghost.velocity.y -= 40;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxFlicker.flicker(ghost, 1, 0.1, false, false, function(flick:FlxFlicker)
				{
					ghost.visible = false;
				});
			});
			insert((500 + i),ghost);
		}
		
	}
	else if (name == 'plane')
	{	
		if (diffy != "Hard+")
		{
			if (FlxG.random.bool(50))
			{
				var plane = new FlxSprite(1280, FlxG.random.int(100,500));
				plane.frames = Paths.getSparrowAtlas('plane');
				plane.animation.addByPrefix('plane','plane',24, true);
				plane.cameras = [game.camOther];
				plane.antialiasing = false;
				plane.scale.set(2,2);
				plane.updateHitbox();
				plane.animation.play('plane');
				plane.velocity.x -= 80;
				var windowgrab = new AttachedSprite('planewindow' + FlxG.random.int(1,3));
				windowgrab.updateHitbox();
				windowgrab.x = -1000;
				windowgrab.cameras = [game.camOther];
				windowgrab.antialiasing = true;
				windowgrab.xAdd = 70;
				windowgrab.yAdd = -23;
				windowgrab.sprTracker = plane;
				if (FlxG.random.bool(50))
				{
					var windowgrab2 = new AttachedSprite('planewindow' + FlxG.random.int(1,3));
					windowgrab2.x = -1000;
					windowgrab2.updateHitbox();
					windowgrab2.cameras = [game.camOther];
					windowgrab2.antialiasing = true;
					windowgrab2.xAdd = 240;
					windowgrab2.sprTracker = windowgrab;
					insert(48,windowgrab2);
				}
				insert(49,windowgrab);
				insert(50,plane);
			}
			else
			{
				var plane = new FlxSprite(-200, FlxG.random.int(100,500));
				plane.frames = Paths.getSparrowAtlas('plane');
				plane.animation.addByPrefix('plane','plane',24, true);
				plane.cameras = [game.camOther];
				plane.antialiasing = false;
				plane.scale.set(2,2);
				plane.flipX = true;
				plane.updateHitbox();
				plane.animation.play('plane');
				plane.velocity.x += 80;
				var windowgrab = new AttachedSprite('flippedplanewindow' + FlxG.random.int(1,3));
				windowgrab.updateHitbox();
				windowgrab.x = -1000;
				windowgrab.cameras = [game.camOther];
				windowgrab.antialiasing = true;
				windowgrab.xAdd = -200;
				windowgrab.yAdd = -23;
				windowgrab.sprTracker = plane;
				if (FlxG.random.bool(50))
				{
					var windowgrab2 = new AttachedSprite('flippedplanewindow' + FlxG.random.int(1,3));
					windowgrab2.x = -1000;
					windowgrab2.updateHitbox();
					windowgrab2.cameras = [game.camOther];
					windowgrab2.antialiasing = true;
					windowgrab2.xAdd = -240;
					windowgrab2.sprTracker = windowgrab;
					insert(48,windowgrab2);
				}
				insert(49,windowgrab);
				insert(50,plane);
			}
		}
		else
		{
			if (FlxG.random.bool(50))
			{
				var plane = new FlxSprite(1280, FlxG.random.int(100,400));
				plane.frames = Paths.getSparrowAtlas('distract');
				if (!ClientPrefs.flashing)
					plane.animation.addByPrefix('distract','distract',1, true);
				else
					plane.animation.addByPrefix('distract','distract',10, true);
				plane.cameras = [game.camOther];
				plane.antialiasing = false;
				plane.scale.set(0.4,0.4);
				plane.updateHitbox();
				plane.animation.play('distract');
				plane.velocity.x -= 300;
				insert(50,plane);
			}
			else
			{
				var plane = new FlxSprite(-400, FlxG.random.int(100,400));
				plane.frames = Paths.getSparrowAtlas('distract');
				if (!ClientPrefs.flashing)
					plane.animation.addByPrefix('distract','distract',1, true);
				else
					plane.animation.addByPrefix('distract','distract',10, true);
				plane.scale.set(0.4,0.4);
				plane.updateHitbox();
				plane.cameras = [game.camOther];
				plane.antialiasing = false;
				plane.animation.play('distract');
				plane.velocity.x += 300;
				insert(50,plane);
			}
		}
	}
	else if (name == 'punchbar')
	{
		
			FlxG.sound.play(Paths.sound("healthfall"));
			boxyrobi.playAnim('groundpunch', true);
			boxyrobi.specialAnim = true;
			
			game.iconP1.velocity.y += 500;
			game.iconP2.velocity.y += 500;
			healthBarBG.velocity.y += 500;
			healthBar.velocity.y += 500;
			FlxTween.tween(game.iconP1, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			FlxTween.tween(game.iconP2, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			FlxTween.tween(healthBarBG, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			FlxTween.tween(healthBar, {alpha: 0}, 0.8, {ease: FlxEase.circOut});
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				boxyrobi.playAnim('idle', true);
			});
	}
}

function onGameOverStart() 
{
	game.camGame.y = 0;
    FlxTransWindow.getWindowsbackward();
	FlxG.autoPause = true;
    FlxG.mouse.useSystemCursor = false;
    Application.current.window.borderless = false;
	Application.current.window.resize(1280, 720);
	Application.current.window.focus();
	Lib.application.window.move(OGsauceX, OGsauceY);
	Main.fpsVar.visible = ClientPrefs.showFPS;
}