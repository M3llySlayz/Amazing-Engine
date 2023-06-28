// This is unfinished btw

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
    public function new(x:Float = 6, y:Float = 6, color:Int = 0xFFFFFFFF)
    {
        super();
        this.x = x;
        this.y = y;
        addEventListener(Event.ENTER_FRAME, (e:Event) -> enterFrame(Sys.time()));
    }
    
    var lerpFramerate:Float;
    function enterFrame(deltaTime:Float) {
        lerpFramerate = FlxMath.lerp(lerpFramerate, FPSCounter.frameRate, 0.15);
    }
}