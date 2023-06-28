package display;

import openfl.display.Sprite;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;

class Stats extends Sprite
{
    // Graph stuff
    var framesSprite:Sprite;
    var memSprite:Sprite;
    var graphColor:Int;

    // Info stuff
    var fps:Float = 0;
    var mem:Float = 0;

    public function new(x:Float = 6, y:Float = 6, color:Int = 0xFFFFFFFF)
    {
        super();
        this.x = x;
        this.y = y;
        graphColor = color;
        addEventListener(Event.ENTER_FRAME, (e:Event) -> enterFrame(Sys.time()));
    }

    function enterFrame(deltaTime:Float) {
        updateFPS(deltaTime);
        updateMemory(deltaTime);
    }

    ////////////
    function updateFPS(deltaTime:Float) {
        fps = FPSCounter.frameRate;
        //trace(fps);
    }

    function updateMemory(deltaTime:Float) {
        mem = FPSCounter.memory;
        //trace(mem);
    }
}