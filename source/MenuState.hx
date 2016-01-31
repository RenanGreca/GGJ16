package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var bg:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		bg = new FlxSprite();
		bg.loadGraphic(AssetPaths.title_screen__png, true, 768, 640);
		add(bg);

		super.create();

		haxe.Timer.delay(fadeOutFirstImage, 1000);
	}

	function fadeOutFirstImage() {
		FlxSpriteUtil.fadeOut(bg, 1);
		haxe.Timer.delay(FadeInSecondImage, 1000);
	}

	function FadeInSecondImage() {
		bg.loadGraphic(AssetPaths.game_start__png, true, 768, 640);
		FlxSpriteUtil.fadeIn(bg, 1);
		haxe.Timer.delay(GoToPlayState, 1000);
	}

	function GoToPlayState() {
		FlxSpriteUtil.fadeOut(bg, 1);
		FlxG.switchState(new PlayState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}