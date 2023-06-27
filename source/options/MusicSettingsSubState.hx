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

class MusicSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Music Settings';
		rpcTitle = 'Music Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time', 'Bossfight', 'Construct', 'Confront', 'Waiting', 'Waiting (Impatient)', 'Bounce', 'Adventure']);
		addOption(option);

		option.onChange = onChangePauseMusic;

		var option:Option = new Option('Game Over Song:',
			"What song do you prefer for the Game Over?",
			'gameOverSong',
			'string',
			'Default',
			['Default', 'A Taken L', 'Far', 'Regret']);
		addOption(option);

		option.onChange = onChangeGameOverMusic;

		var option:Option = new Option('Main Menu Song:',
			"What song do you prefer for the Main Menu?",
			'mainSong',
			'string',
			'Freaky',
			['Freaky', 'Iconic', 'Iconic (Extended)', 'Ambience']);
		addOption(option);
		
		option.onChange = onChangeMenuMusic;

		var option = new Option('Persistent Music',
			'Do you want music played through the engine to be consistent?\nThis means, for exmaple, playing an Inst from Freeplay will keep it playing in menus.',
			'persistentBeats',
			'bool',
			false);
		addOption(option);
		
		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	function onChangeMenuMusic()
	{
		FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.mainSong)));
		changedMusic = false;
	}

	function onChangeGameOverMusic() {
		FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.gameOverSong)));
		changedMusic = true;
	}

	override function destroy() {
		if(changedMusic) {
			if (!ClientPrefs.persistentBeats) FlxG.sound.playMusic(Paths.music(ClientPrefs.mainSong));
			super.destroy();
		}
	}
}