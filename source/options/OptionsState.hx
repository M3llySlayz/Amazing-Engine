package options;

#if DISCORD_ALLOWED
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
	var options:Array<String> = [];
	var initialOptions:Array<String> = ['Gameplay', 'Visuals', 'Notes', 'Music', 'Other'];
	var visualOptions:Array<String> = ['Graphics', 'UI', 'Visual Settings'];
	var gameplayOptions:Array<String> = ['Settings', 'Controls', 'Delay and Combo'];
	var notesOptions:Array<String> = ['Colors', 'Options'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;
	var manual:FlxSprite;
	var theCircle:FlxSprite;
	var changeLogSheet:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Colors':
				openSubState(new options.notes.NotesSubState());
			case 'Notes':
				options = notesOptions;
				reloadOptions();
			case 'Controls':
				openSubState(new options.gameplay.ControlsSubState());
			case 'Graphics':
				openSubState(new options.visuals.GraphicsSettingsSubState());
			case 'Visuals':
				options = visualOptions;
				reloadOptions();
			case 'Visual Settings':
				openSubState(new options.visuals.VisualsSubState());
			case 'UI':
				openSubState(new options.visuals.UISubState());
			case 'Gameplay':
				options = gameplayOptions;
				reloadOptions();
			case 'Settings':
				openSubState(new options.gameplay.GameplaySettingsSubState());
			case 'Delay and Combo':
				LoadingState.loadAndSwitchState(new options.gameplay.NoteOffsetState());
			case 'Dev Stuff':
				openSubState(new options.dev.DevSettingsSubState());
			case 'Music':
				openSubState(new options.music.MusicSettingsSubState());
			case 'Options': //note options
				openSubState(new options.notes.NoteOptionsSubState());
			case 'Other':
				openSubState(new options.other.OtherSettingsSubState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	override function create() {
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Options Menu", "Changing settings", 'icon', false, null, 'gear');
		#end

		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		if (ClientPrefs.devMode) initialOptions.insert(0, 'Dev Stuff');

		options = initialOptions;

		selectorLeft = new Alphabet(0, 0, '>', true);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true);
		add(selectorRight);

		reloadOptions();
		
		ClientPrefs.saveSettings();

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

		if (FlxG.mouse.wheel != 0) {
			if (FlxG.mouse.wheel > 0) {
				changeSelection(-1);
			} else {
				changeSelection(1);
			}
		}

		if (controls.DEV_BIND_P) {
			if (ClientPrefs.devMode) {
				options.remove('Dev Stuff');
				ClientPrefs.devMode = false;
			} else {
				ClientPrefs.devMode = true;
			}
			LoadingState.loadAndSwitchState(new options.OptionsState());
		}

		if (controls.BACK || FlxG.mouse.justPressedRight) {
			if (options == initialOptions){
				FlxG.mouse.visible = false;
				SoundEffects.playSFX('cancel', false);
				if (ClientPrefs.luaMenu) {
					PlayState.SONG = Song.loadFromJson('ae-menu', 'ae-menu');
					LoadingState.loadAndSwitchState(new PlayState());
				} else {
					MusicBeatState.switchState(new MainMenuState());
				}
			} else {
				options = initialOptions;
				reloadOptions();
			}
		}

		if (controls.ACCEPT || FlxG.mouse.justPressed) {
			openSelectedSubstate(options[curSelected]);
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

	function reloadOptions() {
		if (grpOptions != null){
			remove(grpOptions);
		}
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);
		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += 75 * (i - (options.length / 2)) + 32;
			grpOptions.add(optionText);
		}
		curSelected = 0;
		changeSelection();
	}
}
