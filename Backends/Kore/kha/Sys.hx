package kha;

import kha.cpp.graphics.Graphics;

@:headerCode('
#include <Kore/pch.h>
#include <Kore/System.h>
')

class Sys {
	public static var needs3d: Bool = false;
	
	public static var graphics(default, null): kha.graphics.Graphics;

	public static var mouse(default, null): kha.Mouse;
	
	public static var screenRotation: ScreenRotation = ScreenRotation.RotationNone;
	
	public static function init(): Void {
		mouse = new kha.cpp.Mouse();
		graphics = new Graphics();
	}
	
	@:functionCode('
		return Kore::System::time();
	')
	public static function getTime(): Float {
		return 0;
	}
	
	public static var pixelWidth(get, null): Int;
	public static var pixelHeight(get, null): Int;
	
	@:functionCode('return Kore::System::screenWidth();')
	public static function get_pixelWidth(): Int {
		return 0;
	}
	
	@:functionCode('return Kore::System::screenHeight();')
	public static function get_pixelHeight(): Int {
		return 0;
	}
}
