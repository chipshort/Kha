package kha.flash;

import flash.utils.ByteArray;
import haxe.io.Bytes;
import kha.graphics.TextureFormat;
import kha.Starter;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display3D.Context3DTextureFormat;
import flash.display3D.textures.Texture;
import flash.geom.Matrix;

class Image implements kha.graphics.Texture {
	private var tex: Texture;
	private var myWidth: Int;
	private var myHeight: Int;
	private var texWidth: Int;
	private var texHeight: Int;
	private var format: TextureFormat;
	private var depthStencil: Bool;
	
	private var data: BitmapData;
	private var bytes: Bytes;
	private var readable: Bool;
	
	public function new(width: Int, height: Int, format: TextureFormat, renderTarget: Bool, depthStencil: Bool, readable: Bool) {
		myWidth = width;
		myHeight = height;
		texWidth = upperPowerOfTwo(Std.int(myWidth));
		texHeight = upperPowerOfTwo(Std.int(myHeight));
		this.format = format;
		this.depthStencil = depthStencil;
		this.readable = readable;
		tex = Starter.context.createTexture(texWidth, texHeight, Context3DTextureFormat.BGRA, renderTarget);
	}
	
	public static function fromBitmap(image: DisplayObject, readable: Bool): Image {
		var bitmap = cast(image, Bitmap);
		return fromBitmapData(bitmap.bitmapData, readable);
	}
	
	public static function fromBitmapData(image: BitmapData, readable: Bool): Image {
		var texture = new Image(Std.int(image.width), Std.int(image.height), TextureFormat.RGBA32, false, false, readable);
		texture.uploadBitmap(image, readable);
		return texture;
	}
	
	public function uploadBitmap(bitmap: BitmapData, readable: Bool): Void {
		if (readable) data = bitmap;
		tex.uploadFromBitmapData(bitmap, 0);
	}
	
	public var width(get, null): Int;
	public var height(get, null): Int;
	
	public function get_width(): Int {
		return Std.int(myWidth);
	}
	
	public function get_height(): Int {
		return Std.int(myHeight);
	}
	
	public var realWidth(get, null): Int;
	public var realHeight(get, null): Int;
	
	public function get_realWidth(): Int {
		return texWidth;
	}
	
	public function get_realHeight(): Int {
		return texHeight;
	}
	
	public function unload(): Void {
		if (tex != null) {
			tex.dispose();
			tex = null;
		}
	}
	
	public function isOpaque(x: Int, y: Int): Bool {
		if (data != null) return (data.getPixel32(x, y) >> 24 & 0xFF) != 0;
		if (bytes != null) return bytes.get(y * texWidth * 4 + x * 4 + 3) != 0;
		return true;
	}
	
	public function getFlashTexture(): Texture {
		return tex;
	}
	
	public function hasDepthStencil(): Bool {
		return depthStencil;
	}
	
	private static function upperPowerOfTwo(v: Int): Int {
		v--;
		v |= v >>> 1;
		v |= v >>> 2;
		v |= v >>> 4;
		v |= v >>> 8;
		v |= v >>> 16;
		v++;
		return v;
	}
	
	public function lock(level: Int = 0): Bytes {
		switch (format) {
			case RGBA32:
				bytes = Bytes.alloc(texWidth * texHeight * 4);
			case L8:
				bytes = Bytes.alloc(texWidth * texHeight);
		}
		return bytes;
	}
	
	public function unlock(): Void {
		switch (format) {
			case RGBA32:
				tex.uploadFromByteArray(bytes.getData(), 0);
			case L8:
				var rgbaBytes = Bytes.alloc(texWidth * texHeight * 4);
				for (y in 0...texHeight) for (x in 0...texWidth) {
					var value = bytes.get(y * texWidth + x);
					if (value != 0) {
						var a = 3;
						++a;
					}
					rgbaBytes.set(y * texWidth * 4 + x * 4 + 0, value);
					rgbaBytes.set(y * texWidth * 4 + x * 4 + 1, value);
					rgbaBytes.set(y * texWidth * 4 + x * 4 + 2, value);
					rgbaBytes.set(y * texWidth * 4 + x * 4 + 3, 255);
				}
				tex.uploadFromByteArray(rgbaBytes.getData(), 0);
		}
		
		if (!readable) bytes = null;
	}
}
