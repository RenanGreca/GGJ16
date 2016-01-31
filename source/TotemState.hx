package;

import flixel.addons.editors.tiled.TiledMap;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class TotemState extends FlxState
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
	
	var indexStage:Int = 0;
	var coinsTotal:Int = 0;
	
	var tiledLevel:TiledMap;
	
	var doorSecret:FlxSprite;
	var doorBack:FlxSprite;
	var doorEnd:FlxSprite;
	
	var totem:FlxSprite;
	
	var secretSound:FlxSound;
	
	function new(indexStage:Int = 0, coinsTotal:Int = 0)
	{
		super();
		this.indexStage = indexStage;
		this.coinsTotal = coinsTotal;
	}
	
	override public function create():Void
	{
		FlxG.mouse.visible = false;
		trace('TOTEM COINS:', coinsTotal);
		
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
		
		secretSound = FlxG.sound.load(AssetPaths.secret__wav);
		secretSound.play();
	}
	
	
	function SetPlayer() 
	{
		player.x = doors.members[2].x + 10;
		player.y = doors.members[2].y;
		player.facing = FlxObject.RIGHT;
		player.acceleration.y = player.gravity;
		player.alive = true;
		add(player);
	}
	
	function BuildLevel() 
	{
		doors = new FlxTypedGroup();
		trace(tiledLevel.properties);
		
		for (group in tiledLevel.objectGroups)
		{
			for (o in group.objects)
			{
				switch (o.name.toLowerCase())
				{
					case "door":
						var item:FlxSprite = new FlxSprite(o.x, o.y);
						item.loadGraphic(AssetPaths.gray_door__png, true, 64, 64);
						item.animation.add('open', [2, 1, 0], 2, false);
						item.animation.add('close', [0, 1, 2], 2, false);
						if (o.custom.id.toLowerCase() == 'doorsecret') doorSecret = item;
						if (o.custom.id.toLowerCase() == 'doorend') doorEnd = item;
						if (o.custom.id.toLowerCase() == 'doorback') doorBack = item;
						//if (stageRules[indexStage].outDoor == Std.parseInt(o.custom.id)) validDoor = item;
						doors.add(item);
					case "totem":
						var item:FlxSprite = new FlxSprite(o.x, o.y);
						item.loadGraphic(AssetPaths.totens__png, true, 64, 384);
						item.animation.add('goto3', [0, 1, 2, 3], 2, false);
						item.animation.add('goto4', [0, 1, 2, 3, 4], 2, false);
						item.animation.add('goto5', [0, 1, 2, 3, 4, 5], 2, false);
						totem = item;
						add(totem);
				}
			}
		}
		trace(FlxG.camera.width, FlxG.game.width, FlxG.width);
		trace(coinsTotal);
		
		if (coinsTotal < 25)
		{
			totem.animation.play('goto3');
			doorBack.animation.play('open');
			doorEnd.visible = false;
			doorSecret.visible = false;
		}
		else if (coinsTotal >= 25 && coinsTotal < 30)
		{
			totem.animation.play('goto4');
			doorEnd.animation.play('open');
			doorBack.visible = false;
			doorSecret.visible = false;
		}
		else
		{
			totem.animation.play('goto5');
			doorSecret.animation.play('open');
			doorEnd.visible = false;
			doorBack.visible = false;
		}
		
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
		FlxG.collide(player, walls);
		
		if (player.animation.frameIndex == 5)
			FlxG.overlap(player, doors, TouchDoor);
	}	
	
	function TouchDoor(obj1:FlxSprite, obj2:FlxSprite) 
	{
		if (doorEnd.visible && obj2 == doorEnd)
		{
			FlxG.switchState(new Ending(coinsTotal));
		}
		
		if(doorSecret.visible && obj2 == doorSecret){
			FlxG.switchState(new Ending(coinsTotal));
		}
		
		if (doorBack.visible && obj2 == doorBack)
		{
			FlxG.switchState(new PlayState(indexStage, coinsTotal));
		}
	}
}