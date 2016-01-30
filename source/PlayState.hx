package;

import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import openfl.Assets;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	var level:FlxTilemap;
	var mapData:String;
	var mapTilePath:String;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		level = new FlxTilemap();
		mapData = Assets.getText("assets/data/tilemap/tilemap_Box.csv");
		mapTilePath = "assets/data/tilemap/tileset.png";
		
		level.loadMap(mapData, mapTilePath, 64, 64);
		add(level);
		
		
		var tiledMap:TiledMap = new TiledMap("assets/data/tilemap/ggj.tmx");
		var tiledLayer:TiledLayer = new TiledLayer("<Box>", tiledMap);
		add(tiledLayer);
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