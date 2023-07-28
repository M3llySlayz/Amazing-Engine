package options.visuals;

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

class UISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'UI Settings';
		rpcTitle = 'UI Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);
		
		var option:Option = new Option('Time Bar Style:',
			"What should the Time Bar look like?",
			'timeBarStyle',
			'string',
			'Gradient',
			['Normal', 'Gradient', 'Leather']);
		addOption(option);

		
		var option:Option = new Option('Pause Exit Method:',
			'When resuming from the pause menu, what do you want to happen?\nFlicker Out is like selecting a song in Freeplay.',
			'pauseExit',
			'string',
			'Countdown',
			['Normal', 'Flicker Out', 'Countdown']);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency:',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Precision Position:',
			'Where do you want your precisions?\n0 is on top of each note, and each number up makes it lower and lower.',
			'hitTimingPositionType',
			'int',
			0);
		addOption(option);	
		option.scrollSpeed = 0;
		option.minValue = 0;
		option.maxValue = 3;
		option.changeValue = 1;
		
		#if !mobile

		var option:Option = new Option('FPS Counter',
			'If checked, shows the FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Memory Counter',
			'If checked, shows the Memory Counter.',
			'showMEM',
			'bool',
			true);
		addOption(option);

		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Show Keybinds on Start Song',
			"If checked, your keybinds will be shown on the strum that they correspond to when you start a song.",
			'showKeybindsOnStart',
			'bool',
			true);
		addOption(option);

		super();
	}
}
