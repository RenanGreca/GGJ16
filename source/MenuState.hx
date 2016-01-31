package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	var bg:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	
	var cutscenes:Array<String>;
	var cutNum:Int = 0;
	
	override public function create():Void
	{
		cutscenes = [AssetPaths.cutscene__png, AssetPaths.cutscene2__png];
		
		super.create();
		
		PlayCutscene();
	}
	
	function PlayCutscene() 
	{
		trace('play');
		var cutscene:FlxSprite = new FlxSprite(0, 0);
		cutscene.loadGraphic(cutscenes[cutNum]);
		cutscene.y += (FlxG.camera.height - cutscene.height) * .5;
		add(cutscene);
		FlxG.camera.fade(FlxColor.BLACK, 1, true, null, true);
		cutNum++;
		
		new FlxTimer(3, TimerOff);
		//FlxG.camera.fade(FlxColor.BLACK, 1, true, function() {
			//Flx
		//});
	}
	
	function TimerOff(timer:FlxTimer) 
	{
		FlxG.camera.fade(FlxColor.BLACK, 1, false, function()
		{
			if (cutNum < cutscenes.length) PlayCutscene();
			else FlxG.switchState(new PlayState());
		});
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