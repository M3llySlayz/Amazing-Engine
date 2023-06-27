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

class DevSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Dev Settings';
		rpcTitle = 'Dev Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Main Menu Position:', //Name
			'Where do you want the buttons to be?', //Description
			'mainMenuPos', //Save data variable name
			'string', //Variable type
			'Center', //Default value
			['Left', 'Center']); //options
		addOption(option);

		var option:Option = new Option ('Sound Effects:',
			'What do you want your sound effects to be like?',
			'sfxPreset',
			'string',
			'Default',
			['Default', 'Spooky']);
		addOption(option);

		var option:Option = new Option('Advanced SFX', //Name
			'If checked, the SFX used will be a bit different depending on what you do.', //Description
			'advancedSfx', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Lua Menu', //Name
			'If checked, the main menu will become customizable by LUA! (check mods/data/ae-menu for more)', //Description
			'luaMenu', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		super();
	}
}