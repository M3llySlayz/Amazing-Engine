package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
class Changelog {

var changelogText:String;
var manual:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, changelog:String){
        manual = new FlxSprite(0, 0);
		manual.frames = Paths.getSparrowAtlas('extra-keys/manual_book');
		manual.animation.addByPrefix('normal', 'manual icon', 30, true);
		manual.animation.addByPrefix('hover', 'manual icon hover', 30, true);
		add(manual);
		manual.x = FlxG.width - manual.width;
		manual.y = FlxG.height - manual.height;
		manual.animation.play('normal', true);
    }
}
