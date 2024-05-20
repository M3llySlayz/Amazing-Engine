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
		
		addOptions([

			new Option(
				'Downscroll', //Name
				'If checked, notes go Down instead of Up, simple enough.', //Description
				'downScroll', //Save data variable name
				'bool', //Variable type
				false // Default Value
			),
			
			new Option(
				'Middlescroll',
				'If checked, your notes get centered.',
				'middleScroll',
				'bool',
				false
			),
			
			new Option(
				'Note Glow',
				"If checked, when it's almost time to press a note, it'll glow.\nWorks like FPS Plus, but more efficient.",
				'noteGlow',
				'bool',
				false
			)
		]);
		
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
