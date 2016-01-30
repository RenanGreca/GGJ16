package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
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

	var walls:FlxTilemap;

	var player:Player;
	
	//private var _map:FlxOgmoLoader;
	//private var _mWalls:FlxTilemap;
 
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		//level = new FlxTilemap();
		//mapData = Assets.getText("assets/data/tilemap/tilemap_walls.csv");
		//mapTilePath = "assets/data/tilemap/tileset.png";
		//
		//level.loadMap(mapData, mapTilePath, 64, 64);
		//add(level);
		//
		
		FlxG.mouse.visible = false;
		
		var tiledLevel:TiledMap = new TiledMap("assets/data/tilemap/ggj.tmx");
		
		for (layer in tiledLevel.layers)
		{
			trace(layer.name);
			
			var layerData:String = layer.csvData;
			var tilesheetPath:String = "assets/data/tilemap/tileset.png";
			
			var level:FlxTilemap = new FlxTilemap();
			
			level.widthInTiles = tiledLevel.width;
			level.heightInTiles = tiledLevel.height;
			level.loadMap(layerData, tilesheetPath, tiledLevel.tileWidth, tiledLevel.tileHeight, FlxTilemap.OFF, 1, 1, 1);
			//level.x = -256;
			add(level);
			if (layer.name == "Walls") {
				walls = level;
			}
		}
		
		trace(tiledLevel.properties);
		for (group in tiledLevel.objectGroups)
		{
			for (o in group.objects)
			{
			}
		}

		//_map = new FlxOgmoLoader(AssetPaths.UnsavedLevel__oel);
		//_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 64, 64, "Walls");
		//_mWalls.setTileProperties(1, FlxObject.NONE);
		//_mWalls.setTileProperties(2, FlxObject.ANY);
		//add(_mWalls);
		
		player = new Player(510, 500);
		add(player);
		FlxG.camera.setBounds(256, 0, tiledLevel.fullWidth-256, tiledLevel.fullHeight, true);
		//FlxG.camera.setBounds(256, 0, 768, 640);
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		super.create();
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
		trace(player.x, player.y);
		if (player.x < 210) FlxG.camera.setBounds(0, 0, 1024, 640, true);
		if (FlxG.keys.pressed.C) {
			player.x = 610;
			player.y = 500;
		}

		super.update();
		FlxG.collide(player, walls);
		//FlxG.collide(player, _mWalls);
	}	
}