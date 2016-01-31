package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	var level:FlxTilemap;
	var mapData:String;
	var mapTilePath:String;

	var walls:FlxTilemap;

	var player:Player;
	var doors:FlxTypedGroup<FlxSprite>;
	
	var tiledLevel:TiledMap;
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		
		tiledLevel = new TiledMap("assets/data/tilemap/finalroom.tmx");
		
		for (layer in tiledLevel.layers)
		{
			trace(layer.name);
			
			var layerData:String = layer.csvData;
			var tilesheetPath:String = "assets/data/tilemap/tileset.png";
			
			var level:FlxTilemap = new FlxTilemap();
			
			level.widthInTiles = tiledLevel.width;
			level.heightInTiles = tiledLevel.height;
			level.loadMap(layerData, tilesheetPath, tiledLevel.tileWidth, tiledLevel.tileHeight, FlxTilemap.OFF, 1, 1, 1);
			add(level);
			if (layer.name == "Walls") {
				walls = level;
			}
		}
		
		player = new Player(0,0);
		BuildLevel();
		
		super.create();
		
	}
	
	
	function SetPlayer() 
	{
		player.x = doors.members[1].x + 10;
		player.y = doors.members[1].y;
		player.facing = FlxObject.RIGHT;
		player.acceleration.y = player.gravity;
		player.alive = true;
		add(player);
	}
	
	function BuildLevel() 
	{
		items = new FlxGroup();
		doors = new FlxTypedGroup();
		damage = new FlxGroup();
		trace(tiledLevel.properties);
		
		coinsGot = 0;
		
		for (group in tiledLevel.objectGroups)
		{
			for (o in group.objects)
			{
				switch (o.name.toLowerCase())
				{
					case "door":
						var item:FlxSprite = new FlxSprite(o.x, o.y);
						item.loadGraphic(AssetPaths.door__png, true, 64, 64);
						item.animation.add('open', [1, 2, 3], 8);
						item.animation.add('close', [3, 2, 1], 8);
						if (stageRules[indexStage].outDoor == Std.parseInt(o.custom.id)) validDoor = item;
						doors.add(item);
				}
			}
		}
		trace(FlxG.camera.width, FlxG.game.width, FlxG.width);
		
		progress = new FlxSprite(640, -64);
		progress.scrollFactor.set(0, 0);
		progress.loadGraphic(AssetPaths.barras__png, true, 384, 64);
		progress.animation.randomFrame();
		//progress.x = FlxG.width + (progress.frameWidth * .5);
		trace(progress.x, progress.width, progress.frameWidth);
		
		add(progress);
		add(doors);
		SetPlayer();
		
		FlxG.camera.setBounds(256, 0, tiledLevel.fullWidth-256, tiledLevel.fullHeight, true);
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
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