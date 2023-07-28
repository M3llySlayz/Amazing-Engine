package options.notes;

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

class NoteOptionsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Note Options';
		rpcTitle = 'Note Options Menu'; //for Discord Rich Presence

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Splitscroll:',
			'Only Works For 2 Strums!\nSelects your own personal hell.\nSplits your notes into something fearful.\nEach type is different, and Downscroll affects them as well.', // Enjoy The Hell =] -Irshaad
			'splitScroll',
			'string',
			'None',
			['None', 'Normal', 'Up n\' Down', 'Double Down', 'Alt', 'Double Down Alt']);
		addOption(option);

		var option:Option = new Option('SwapScroll',
			'Note Swap?\nOnly Works For 2 Strums!\nMelly\'s gonna die lmao',
			'swapScroll',
			'string',
			'None',
			['None', 'Quarter', 'Half', 'Three Quarter', 'Full', 'Quarter Alt', 'Half Alt', 'Three Quarter Alt']);
		addOption(option);

		var option:Option = new Option('UnderSwap',
			"SwapScroll but Reverse\nheheh underswap reference", //ok irshaad -melly
			'swapReverse',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Note Glow',
			"If checked, when it's almost time to press a note, it'll glow.\nWorks like FPS Plus, but more efficient.",
			'noteGlow',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Note Splash Opacity:',
			"Set the alpha for the Note Splashes, shown when hitting \"Sick!\" notes.",
			'splashOpacity',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Lane Underlay:',
			'Sets opacity of the background for your notes to help you see!',
			'underlay',
			'percent',
			0);
		addOption(option);	
		option.scrollSpeed = 1;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;

		var option:Option = new Option('Opponent Lane Underlay:',
			'Sets opacity of opponent\'s lane underlay.',
			'oppUnderlay',
			'percent',
			0);
		addOption(option);	
		option.scrollSpeed = 1;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;

		var option:Option = new Option('Fixed Long Notes',
			'If checked, long notes will freeze a character in animation instead of playing it over and over.',
			'fixedLongNotes',
			'bool',
			true);
		addOption(option);

		super();
	}
}
