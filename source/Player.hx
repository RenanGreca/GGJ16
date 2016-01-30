package;

import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;

class Player extends FlxSprite {

	public var speed:Float = 200;
	public var gravity:Int = 1000;

	private var _gamepad:FlxGamepad;

	public function new(X:Float=0, Y:Float=0) {
		super(X, Y);
		loadGraphic(AssetPaths.rato__png, true, 64, 64);
		//makeGraphic(64, 64, FlxColor.YELLOW);

		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [2,3], 6, false);
		animation.add("u", [4], 6, false);

		//setSize(8, 14);
		//offset.set(4, 2);

		drag.x = drag.y = 1600;

		acceleration.y = gravity;
	}

	private function movement(): Void {

		velocity.x = 0;
		if (FlxG.keys.pressed.LEFT) {
			velocity.x = -maxVelocity.x/16;
			facing = FlxObject.LEFT;
			animation.play("lr");
		}

		if (FlxG.keys.pressed.RIGHT) {
			velocity.x = maxVelocity.x/16;
			facing = FlxObject.RIGHT;
			animation.play("lr");
		}

		if (FlxG.keys.anyPressed(["UP", "SPACE"])) {
			jump();
		}

		if (velocity.x == 0 && velocity.y == 0) {
			animation.pause();
			animation.frameIndex = 0;
		}

        _gamepad = FlxG.gamepads.lastActive;
        if (_gamepad != null) {

			_gamepad.firstPressedButtonID();
			_gamepad.firstJustPressedButtonID();
			_gamepad.firstJustReleasedButtonID();

        	if (_gamepad.pressed(XboxButtonID.A)) {
				jump();
        	}

        	if (_gamepad.pressed(XboxButtonID.DPAD_LEFT)) {
				velocity.x = -maxVelocity.x/16;
				facing = FlxObject.LEFT;
        	}

        	if (_gamepad.pressed(XboxButtonID.DPAD_RIGHT)) {
				velocity.x = maxVelocity.x/16;
				facing = FlxObject.RIGHT;
        	}
        }

		/*if (velocity.y != 0) {
			animation.play("u");
		}*/


		/*var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);


        _gamepad = FlxG.gamepads.lastActive;
        if (_gamepad != null) {
        	if (_gamepad.pressed(XboxButtonID.A)) {
        		_up = true;
        	}

        	if (_gamepad.pressed(XboxButtonID.DPAD_LEFT)) {
        		_left = true;
        	}

        	if (_gamepad.pressed(XboxButtonID.DPAD_RIGHT)) {
        		_right = true;
        	}
        }

		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

        if (_up) {
        	jump();
        }

		var movementAngle:Float = 0;
		if (_left) {
			movementAngle = 180;
			facing = FlxObject.LEFT;
			FlxAngle.rotatePoint(speed, 0, 0, 0, movementAngle, velocity);
		} else if (_right) {
			movementAngle = 0;
			facing = FlxObject.RIGHT;
			FlxAngle.rotatePoint(speed, 0, 0, 0, movementAngle, velocity);
		}


		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
			switch (facing) {
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");
				case FlxObject.UP:
					animation.play("u");
				case FlxObject.DOWN:
					animation.play("d");
			}
		}

		/*if (_up || _down || _left || _right) {
			var movementAngle:Float = 0;
			if (_up) {
				movementAngle = -90;
				if (_left)
					movementAngle -= 45;
				else if (_right)
					movementAngle += 45;
				facing = FlxObject.UP;
			} else if (_down) {
				movementAngle = 90;
				if (_left)
					movementAngle += 45;
				else if (_right)
					movementAngle -= 45;
				facing = FlxObject.DOWN;
			} else if (_left) {
				movementAngle = 180;
				facing = FlxObject.LEFT;
			} else if (_right) {
				movementAngle = 0;
				facing = FlxObject.RIGHT;
			}

			FlxAngle.rotatePoint(speed, 0, 0, 0, movementAngle, velocity);

			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) {
				switch (facing) {
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}*/
	}

	override public function update():Void
	{

		movement();
		super.update();
	}	

	private function jump():Void {
		if (velocity.y == 0 && isTouching(FlxObject.FLOOR)) {
             velocity.y = -maxVelocity.y/16;
             animation.play("u");
        }
	}

}