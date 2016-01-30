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
import haxe.io.Path;
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
		
		//level = new FlxTilemap();
		//mapData = Assets.getText("assets/data/tilemap/tilemap_Box.csv");
		//mapTilePath = "assets/data/tilemap/tileset.png";
		//
		//level.loadMap(mapData, mapTilePath, 64, 64);
		//add(level);
		//
		
		var tiledLevel:TiledMap = new TiledMap("assets/data/tilemap/ggj.tmx");
		//var tiledLayer:TiledLayer = new TiledLayer("<Box>", tiledMap);
		//add(tiledLayer);
		
		for (layer in tiledLevel.layers)
		{
			var layerData:String = layer.csvData;
			var tilesheetPath:String = "assets/data/tilemap/tileset.png";
			
			var level:FlxTilemap = new FlxTilemap();
			
			level.widthInTiles = tiledLevel.width;
			level.heightInTiles = tiledLevel.height;
			
			var tileGID:Int = getStartGid(tiledLevel, 'tileset.png');
			
			level.loadMap(layerData, tilesheetPath, tiledLevel.width, tiledLevel.height, FlxTilemap.OFF, 1);
			add(level);
		}
	}
	
	function getStartGid (tiledLevel:TiledMap, tilesheetName:String):Int
    {
        // This function gets the starting GID of a tilesheet
 
        // Note: "0" is empty tile, so default to a non-empty "1" value.
        var tileGID:Int = 1;
 
        for (tileset in tiledLevel.tilesets)
        {
            // We need to search the tileset's firstGID -- to do that,
            // we compare the tilesheet paths. If it matches, we
            // extract the firstGID value.
            var tilesheetPath:Path = new Path(tileset.imageSource);
            var thisTilesheetName = tilesheetPath.file + "." + tilesheetPath.ext;
            if (thisTilesheetName == tilesheetName)
            {
                tileGID = tileset.firstGID;
            }
        }
 
        return tileGID;
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