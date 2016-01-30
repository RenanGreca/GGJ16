package lime;


import lime.utils.Assets;


class AssetData {

	private static var initialized:Bool = false;
	
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var path = new #if haxe3 Map <String, #else Hash <#end String> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();	
	
	public static function initialize():Void {
		
		if (!initialized) {
			
			path.set ("assets/data/tilemap/ggj.tmx", "assets/data/tilemap/ggj.tmx");
			type.set ("assets/data/tilemap/ggj.tmx", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/tilemap/tilemap_Box.csv", "assets/data/tilemap/tilemap_Box.csv");
			type.set ("assets/data/tilemap/tilemap_Box.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/tilemap/tilemap_Details.csv", "assets/data/tilemap/tilemap_Details.csv");
			type.set ("assets/data/tilemap/tilemap_Details.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/tilemap/tilemap_Objects.csv", "assets/data/tilemap/tilemap_Objects.csv");
			type.set ("assets/data/tilemap/tilemap_Objects.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/tilemap/tilemap_Platforms.csv", "assets/data/tilemap/tilemap_Platforms.csv");
			type.set ("assets/data/tilemap/tilemap_Platforms.csv", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/data/tilemap/tileset.png", "assets/data/tilemap/tileset.png");
			type.set ("assets/data/tilemap/tileset.png", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/images/images-go-here.txt", "assets/images/images-go-here.txt");
			type.set ("assets/images/images-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/images/tileset.jpg", "assets/images/tileset.jpg");
			type.set ("assets/images/tileset.jpg", Reflect.field (AssetType, "image".toUpperCase ()));
			path.set ("assets/music/music-goes-here.txt", "assets/music/music-goes-here.txt");
			type.set ("assets/music/music-goes-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/sounds/sounds-go-here.txt", "assets/sounds/sounds-go-here.txt");
			type.set ("assets/sounds/sounds-go-here.txt", Reflect.field (AssetType, "text".toUpperCase ()));
			path.set ("assets/sounds/beep.ogg", "assets/sounds/beep.ogg");
			type.set ("assets/sounds/beep.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/sounds/flixel.ogg", "assets/sounds/flixel.ogg");
			type.set ("assets/sounds/flixel.ogg", Reflect.field (AssetType, "sound".toUpperCase ()));
			path.set ("assets/fonts/nokiafc22.ttf", "assets/fonts/nokiafc22.ttf");
			type.set ("assets/fonts/nokiafc22.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			path.set ("assets/fonts/arial.ttf", "assets/fonts/arial.ttf");
			type.set ("assets/fonts/arial.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
			
			
			initialized = true;
			
		} //!initialized
		
	} //initialize
	
	
} //AssetData
