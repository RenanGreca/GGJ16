package;
import flixel.FlxObject;

/**
 * ...
 * @author Oelson
 */
class StageInfo extends FlxObject
{

	public var diamonds:Array<Int>;
	public var outDoor:Int;
	public var deathReset:Bool;
	
	public function new(diamonds:Array<Int>, outDoor:Int, deathReset:Bool) 
	{
		super();
		this.diamonds = diamonds;
		this.outDoor = outDoor;
		this.deathReset = deathReset;
	}
	
}