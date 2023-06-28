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
    var framesSprite:Sprite;
    var memSprite:Sprite;

    public function new(x:Float = 6, y:Float = 6, color:Int = 0xFFFFFFFF, ?font:String = "_sans")
    {
        super();
        this.x = x;
        this.y = y;
        addEventListener(Event.ENTER_FRAME, (e:Event) -> enterFrame(Sys.time()));
    }
    
    var lerpFramerate:Float;
    function enterFrame(deltaTime:Float) {
        lerpFramerate = FlxMath.lerp(lerpFramerate, FPSCounter.frameRate, 0.25);
        framesSprite = new Sprite();
        framesSprite.graphics.beginFill(0xFF00FF00); // Set fill color to red
        framesSprite.graphics.drawRect((FlxG.width - 400) + (FlxG.game.ticks / 24), (FlxG.height - 300) - lerpFramerate, 4, 4); // Draw a rectangle
        framesSprite.graphics.endFill();

        if (framesSprite.x < FlxG.width - 100) {
            addChild(framesSprite);
        } else {
            removeChild(framesSprite);
        }
    }
}