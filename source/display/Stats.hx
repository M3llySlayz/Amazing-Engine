// Taken from https://github.com/yupswing/plik/blob/master/com/akifox/plik/debug/Performance.hx

package display;

import haxe.Timer;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.Shape;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.Font;
import openfl.text.TextFormat;
import openfl.Assets;
import openfl.Lib;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;

/**
 * Performance.hx
 * Haxe/OpenFL class to display memory usage.
 *
 * More informations here
 * https://github.com/yupswing/plik/tree/master/com/akifox/plik/debug
 *
 * @author Simone Cingano (yupswing) PLIK Studio
 * @licence MIT
 *
 * Based on this post written by Kirill Poletaev
 * http://haxecoder.com/post.php?id=24
 */

class Stats extends Sprite
{
    private var fpsText:TextField;

    private var fpsHistory:Array<Int>;
    private var fpsHistoryLen:Int = 180;
    private var skipped = 0;
    private var skip = 10;
	private var times:Array<Float>;

	private var padding:Int = 10;
	private var paddingY:Int = 10;

	public var graphBarTickness = 3;
	public var graphBarPadding = 1;
	private var barHeight = 30;

	private var memPeak:Float = 0;

    private var bound:Bitmap;
    private var graph:Shape;
    private var boundData:BitmapData;
    private var logo:Bitmap;

    private var fullHeight:Int = 50;

	public function new(x, y, font:String) 
	{
		super();

		this.x = x;
		this.y = y;

		// Setup arrays
		fpsHistory = [];
		for (i in 0...fpsHistoryLen) fpsHistory.push(0);
		times = [];

		/// ###################################

		/// ### PERFORMANCE TEXT
    	fpsText = new TextField();
        fpsText.x = FlxG.width - (fpsText.width + 2);
		fpsText.selectable = false;
		fpsText.defaultTextFormat = new TextFormat(font, 16, 0x66FFFFFF);
		fpsText.text = "FPS: 0";
		fpsText.embedFonts = true;

		fullHeight = Std.int(fpsText.textHeight + paddingY*3);
		barHeight = Std.int(fpsText.textHeight)-paddingY;

		/// ###################################

        var nextX:Float = padding;

		/// ### GRAPH
        graph = new Shape();
        graph.x = FlxG.width - 190;
        graph.y = paddingY;
        nextX = graph.x + (graphBarTickness+graphBarPadding)*(fpsHistoryLen-2) + graphBarTickness + padding;
    	fpsText.y = paddingY + 18;

		/// ###################################

		bound = new Bitmap();
        bound.x = graph.x - 7;
		onResize(null);
		addChild(bound);
		addChild(graph);
		addChild(fpsText);
		
		/// ###################################

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnter);
		Lib.current.stage.addEventListener(Event.RESIZE, onResize);
	}

    var lerpFramerate:Float;
	private function onEnter(_):Void
	{
        if (visible) {
            lerpFramerate = FlxMath.lerp(lerpFramerate, FPSCounter.frameRate, 0.325);
            drawGraph(Std.int(lerpFramerate+FlxG.elapsed));
            fpsText.text = "FPS: " + Std.int(lerpFramerate+FlxG.elapsed) + ' (' + FPSCounter.frameTime + ' ms)';
            fpsText.textColor = FlxColor.interpolate(0xFFFFFFFF, 0xFFFF0000, FlxEase.quadOut(50));
            fpsText.autoSize = RIGHT;
        }
	}

    var graphSpeed:Float = 0.03;
	private function drawGraph(fps:Int):Void 
	{
		var color:Int;
		fpsHistory.push(fps);
        fpsHistory.shift();
        graph.graphics.clear();
        for (i in 0...fpsHistoryLen) {
        	graph.graphics.moveTo(graphSpeed*i+i,barHeight-2*fpsHistory[i]/ClientPrefs.framerate*3);
        	color = 0xFF00FFFF;
        	graph.graphics.lineStyle(4, color);
        	graph.graphics.lineTo(graphSpeed*i+i,barHeight-2*fpsHistory[i]/ClientPrefs.framerate*3);
        }
	}

	private function onResize(_):Void
	{
		boundData = new BitmapData(Lib.current.stage.stageWidth,fullHeight);
		boundData.fillRect(new Rectangle(0,0,Lib.current.stage.stageWidth,fullHeight),0x88000000);
		bound.bitmapData = boundData;
	}	
}