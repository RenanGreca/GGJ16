package;

import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.addons.editors.tiled.TiledLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import haxe.io.Path;
import openfl.Assets;
import flixel.util.FlxTimer;

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
	var items:FlxTypedGroup<FlxSprite>;
	var doors:FlxTypedGroup<FlxSprite>;
	var damage:FlxGroup;

	var diamonds:Array<FlxSprite>;
	
	var tiledLevel:TiledMap;
	
	var progress:FlxSprite;
	var diamondSound:FlxSound;
	var secretSound:FlxSound;
	
	var indexStage:Int = 0;
	var coinsGot:Int = 0;
	var coinsTotal:Int = 0;
	var validDoor:FlxSprite;
	var secretDiamond:FlxSprite;
	
	var stageRules:Array<StageInfo> = new Array();
	
							//[[[1,2,3,4,5],2,true], //Hello World
							//[[1,2,3,4,5],2,true], //Hello World
							//[[1,2,3,4,5],2,true], //Diamond Pop
							//[[1,2,3,4,5],2,false], //First Sacrifice
							//[[1,2,3,4,5],1,true], //Backwards Forwards
							//[[],2,false], //He's special
							//[[1,2,3,5,6],3] //The Secret
							//];
							
	var info1:StageInfo = new StageInfo([1, 2, 3, 4, 5], 2, true);
	var info2:StageInfo = new StageInfo([1, 2, 3, 4, 5], 2, true);
	var info3:StageInfo = new StageInfo([1, 2, 3, 4, 5, 7], 2, true);
	var info4:StageInfo = new StageInfo([1], 2, false);
	var info5:StageInfo = new StageInfo([1, 2, 3, 4, 5], 1, true);
	var info6:StageInfo = new StageInfo([1, 2, 3, 5, 6], 3, true);
	
	function new(indexStage:Int = 0, coinsTotal:Int = 0)
	{
		super();
		this.indexStage = indexStage;
		this.coinsTotal = coinsTotal;
	}

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		stageRules = [info1, info2, info3, info4, info5, info6];
		
		FlxG.mouse.visible = false;

		FlxG.sound.playMusic(AssetPaths.GGJ16__wav, 1, true);
		diamondSound = FlxG.sound.load(AssetPaths.diamond__wav);
		secretSound = FlxG.sound.load(AssetPaths.secret__wav);
		
		tiledLevel = new TiledMap("assets/data/tilemap/ggj.tmx");
		
		for (layer in tiledLevel.layers)
		{
			
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
	
	function BuildLevel(coinsGot:Int = 0)
	{

		items = new FlxTypedGroup();
		doors = new FlxTypedGroup();
		damage = new FlxGroup();
		diamonds = new Array();
		
		for (group in tiledLevel.objectGroups)
		{
			for (o in group.objects)
			{
				switch (o.name.toLowerCase())
				{
					case "item":
						if (stageRules[indexStage].diamonds.indexOf(Std.parseInt(o.custom.id)) > -1)
						{
							var item:FlxSprite = new FlxSprite(o.x, o.y);
							item.loadGraphic(AssetPaths.diamante__png, true, 64, 64);
							item.animation.add('shine', [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32], 8, true);
							item.animation.play('shine');
							if (o.custom.id == "7")
							{
								secretDiamond = item;
								secretDiamond.visible = false;
							}
							items.add(item);
						}
					
					case "door":
						var item:FlxSprite = new FlxSprite(o.x, o.y);
						item.loadGraphic(AssetPaths.door__png, true, 64, 64);
						item.animation.add('open', [2, 1, 0], 2, false);
						item.animation.add('close', [0, 1, 2], 2, false);
						if (o.custom.id != '1') item.animation.play('close');
						if (stageRules[indexStage].outDoor == Std.parseInt(o.custom.id)) validDoor = item;
						doors.add(item);
						
					case "spikes":
						var item:FlxSprite = new FlxSprite(o.x, o.y + 15);
						item.loadGraphic(AssetPaths.espinhos__png, false, 64, 64);
						damage.add(item);
				}
			}
		}
		trace(FlxG.camera.width, FlxG.game.width, FlxG.width);

		for (i in 0...5) {
			var diamond = new FlxSprite(256+(64*i), -64);
			diamond.loadGraphic(AssetPaths.diamante__png, true, 64, 64);
			diamond.animation.frameIndex = 1;
			diamond.alpha = 0.5;
			diamonds.push(diamond);
			add(diamond);
		}
		this.coinsGot = coinsGot;
		for (i in 0...coinsGot)
		{
			diamonds[i].alpha = 1;
		}
		
		progress = new FlxSprite(640, -64);
		//progress.scrollFactor.set(0, 0);
		progress.loadGraphic(AssetPaths.barras__png, true, 384, 64);
		progress.animation.frameIndex = indexStage;
		//progress.x = FlxG.width + (progress.frameWidth * .5);
		
		add(progress);
		add(items);
		add(doors);
		add(damage);
		//add(diamonds);
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
		FlxG.sound.music.stop();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		if (player.x < 210) FlxG.camera.setBounds(0, 0, 1024, 640, true);

		super.update();
		FlxG.collide(player, walls);
		//FlxG.overlap(player, items, TouchItem);
		for (o in items) {
			if (FlxG.overlap(player, o)) {
				TouchItem(player, o);
			}
		}
		FlxG.overlap(player, damage, TouchDamage);
		
		if (player.animation.frameIndex == 5)
			FlxG.overlap(player, doors, TouchDoor);
	}	
	
	function TouchDoor(obj1:FlxSprite, obj2:FlxSprite) 
	{
		if (obj2 == validDoor && (coinsGot >= 5 || (indexStage == 2 && coinsGot >= 4) || (indexStage == 3 && coinsGot >= 1)))
		{
			CleanLevel();
			if (indexStage == 5 && coinsGot >= 5) FlxG.switchState(new TotemState(indexStage, coinsTotal));
			else indexStage++;
			
			if (indexStage == 4 && coinsGot >= 5) FlxG.switchState(new TotemState(indexStage, coinsTotal));
			BuildLevel();
		}
	}
	
	function CleanLevel()
	{
		progress.animation.frameIndex = 0;
		remove(items);
		remove(doors);
		remove(damage);
		for (diamond in diamonds) {
			remove(diamond);	
		}
		remove(player);
	}
	
	function TouchDamage(obj1:FlxSprite, obj2:FlxSprite)
	{
		if (player.alive)
		{
			player.alive = false;
			player.velocity.y = 0;
			player.acceleration.y = 100;
			player.velocity.x = 0;
			player.animation.play("dead");
			
			if(indexStage != 3) coinsGot = 0;
			new FlxTimer(1, ResetLevel);
		}
	}

	function ResetLevel(timer:FlxTimer) {
		if (coinsGot >= 5)
		{
			coinsTotal -= coinsGot;
			coinsGot = 0;
		}
		CleanLevel(); BuildLevel(coinsGot);
	}
	
	function TouchItem(obj1:FlxSprite, obj2:FlxSprite) 
	{
		if (obj2.visible && FlxG.pixelPerfectOverlap(obj1, obj2)) {
			remove(items.remove(obj2, true));
			coinsGot++;
			coinsTotal++;
			
			if (coinsGot >= 5)
			{
				validDoor.animation.play('open');
				if (indexStage == 2 || indexStage == 3) secretSound.play();
			}
			if (indexStage == 3) validDoor.animation.play('open');
			
			if (indexStage == 2 && coinsGot == 5 && !secretDiamond.visible) AnimDiamond();
			trace(coinsGot, coinsTotal);
			
			for (i in 0...coinsGot) diamonds[i].alpha = 1;
			
			diamondSound.play();
		}
	}
	
	function AnimDiamond()
	{
		coinsGot--; coinsTotal--;
		secretDiamond.visible = true;
	}
}