package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class OutdatedState extends MusicBeatState
{
	public static var leftState:Bool = false;
	var newVersion:String = '';

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey! The Amazing Engine version you're using\nis currently out of date.
			To check and download the latest version,\npress your ACCEPT key.
			If you wish to ignore, press your BACK key.\n\n
			Current version: " + MainMenuState.amazingEngineVersion + " - Newest version: " + newVersion,
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	public function new(newVer:String)
	{
		newVersion = newVer;
		super();
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
				CoolUtil.browserLoad("https://github.com/M3llySlayz/Amazing-Engine");
			}
			else if(controls.BACK) {
				leftState = true;
			}

			if(leftState)
			{
				//FlxG.sound.play(Paths.sound('cancelMenu'));
				SoundEffects.playSFX('cancel', false);
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new MainMenuState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
