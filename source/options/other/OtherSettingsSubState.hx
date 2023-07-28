package options.other;

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

class OtherSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Other Settings';
		rpcTitle = 'Other Settings Menu'; //for Discord Rich Presence

		#if desktop
		var option:Option = new Option('Auto Pause',
			"If checked, the game will automatically freeze itself when not in focus.",
			'autoPause',
			'bool',
			true);
		addOption(option);

		option.onChange = onToggleAutoPause;
		#end

		var option:Option = new Option('Loading Speed:',
			'What percent of its normal speed do you want the loading transition to be?',
			'loadSpeed',
			'percent',
			0.7);
		addOption(option);	
		option.scrollSpeed = 0.1;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end

		var option:Option = new Option('AE Watermarks',
			"If checked, AE's custom stuff will be everywhere :troll:",
			'aeWatermarks',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('New Story Menu',
			'If checked, activate a new, unfinished version of our own Story Mode menu.',
			'newStoryMenu',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Always convert non-EK charts',
			'If checked, shows exactly how early or late you hit a note.',
			'convertEK',
			'bool',
			true);
		addOption(option);

		super();
	}

	#if desktop
	function onToggleAutoPause()
	{
		FlxG.autoPause = ClientPrefs.autoPause;
	}
	#end
}
