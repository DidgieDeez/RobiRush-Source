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
	

    bg = new FlxSprite(810, 370).loadGraphic(Paths.image('fakebg'));
    bg.scale.set(5,5);
	bg.antialiasing = true;
    add(bg);
	
}

function onCreatePost() 
{

	GameOverSubstate.characterName = "boyfrend";
	
	
}


function update(elapsed) {

	timeBar.visible = false;
	timeTxt.visible = false;
	game.timeBarBG.visible = false;
    game.camZooming = false;
	
}

var lastplayedanim:String;

function opponentNoteHit(note){
	var animToPlay:String;
	var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
		
			if (!note.isSustainNote)
			{
				animToPlay = singAnimations[Std.int(Math.abs(note.noteData))];
			}
			else
			{
				animToPlay = lastplayedanim;
			}
			
			game.dad.playAnim(animToPlay, true);
			game.dad.specialAnim = true;
			lastplayedanim = animToPlay;
	
	
}

function onFocusLost()
{
		Application.current.window.focus();
}