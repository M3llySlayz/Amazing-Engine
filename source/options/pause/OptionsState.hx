package options.pause;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = ['Gameplay', 'Controls', 'Graphics', 'Visuals and UI', 'Adjust Delay and Combo', 'Note Colors', 'Music'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	var manual:FlxSprite;
	var changeLogSheet:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.pause.NoteOffsetState());
			case 'Dev Stuff':
				openSubState(new options.DevSettingsSubState());
			case 'Music':
				openSubState(new options.MusicSettingsSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		if (ClientPrefs.devMode) options.insert(0, 'Dev Stuff');
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		manual = new FlxSprite(0, 0);
		manual.frames = Paths.getSparrowAtlas('extra-keys/manual_book');
		manual.animation.addByPrefix('normal', 'manual icon', 30, true);
		manual.animation.addByPrefix('hover', 'manual icon hover', 30, true);
		add(manual);
		manual.x = FlxG.width - manual.width;
		manual.y = FlxG.height - manual.height;
		manual.animation.play('normal', true);
		manual.updateHitbox();

		changeLogSheet = new FlxSprite(0, 0);
		changeLogSheet.loadGraphic(Paths.image('changelogsheet'));
		changeLogSheet.setGraphicSize(2, 2);
		add(changeLogSheet);
		changeLogSheet.x = FlxG.width + manual.width;
		changeLogSheet.y = FlxG.height - changeLogSheet.height;
		changeLogSheet.updateHitbox();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}
		if (FlxG.mouse.wheel != 0){
			if (FlxG.mouse.wheel > 0){
				changeSelection(-1);
			} else {
				changeSelection(1);
			}
		}
		if (controls.DEV_BIND_P) {
			if (ClientPrefs.devMode){
				options.remove('Dev Stuff');
				ClientPrefs.devMode = false;
			} else {
				ClientPrefs.devMode = true;
			}
			LoadingState.loadAndSwitchState(new options.pause.OptionsState());
		}

		if (controls.BACK || FlxG.mouse.justPressedRight) {
				//FlxG.sound.play(Paths.sound('cancelMenu'));
				SoundEffects.playSFX('cancel', false);
				LoadingState.loadAndSwitchState(new PlayState());
			}

		if (controls.ACCEPT || FlxG.mouse.justPressed) {
			openSelectedSubstate(options[curSelected]);
		}

		if (FlxG.mouse.overlaps(manual) || FlxG.mouse.overlaps(changeLogSheet)) {
			if (manual.animation.curAnim.name != 'hover') {
				manual.animation.play('hover', true);
			}
			FlxTween.tween(manual, {x: manual.x - changeLogSheet.width}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(changeLogSheet, {x: FlxG.width - changeLogSheet.width}, 1, {ease: FlxEase.quartInOut});
		} else {
			if (manual.animation.curAnim != null && manual.animation.curAnim.name != 'normal') {
				manual.animation.play('normal', true);
			}
			FlxTween.tween(manual, {x: FlxG.width - manual.width}, 1, {ease: FlxEase.quartInOut});
			FlxTween.tween(changeLogSheet, {x: FlxG.width + manual.width}, 1, {ease: FlxEase.quartInOut});
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		SoundEffects.playSFX('scroll', false);
	}
}