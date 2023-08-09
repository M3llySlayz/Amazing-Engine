package;

#if DISCORD_ALLOWED
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.util.FlxTimer;
#if (flixel < "5.3.0")
import flixel.system.FlxSound;
#else
import flixel.sound.FlxSound;
#end
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import TitleState.TitleData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var titleJSON:TitleData;

	var selector:FlxText;
	private static var curSelected:Int = 0;
	public static var curDifficulty:Int = 1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	public var songText:Alphabet;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var willChooseChar:Bool = true;

	public static var songLowercase:String;
	public static var songJson:String;

	public static var curCategory:String = '';

	var lastSelectedSong:Int = -1;

	//var blackBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	var lightingBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF777777);

	var selectedSomethin = false;
	override function create()
	{
		if (!ClientPrefs.bigCache) {
			Paths.clearStoredMemory();
			Paths.clearUnusedMemory();
		}

		titleJSON = haxe.Json.parse(Paths.getTextFromFile('images/gfDanceTitle.json'));
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;

		WeekData.reloadWeekFiles(false);
		FreeplayCategory.reloadCategoryFiles();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay Menu", "Picking a song", null, false, null, 'icon');
		#end

		var length:Int = WeekData.weeksList.length;
		if (curCategory != '') length = 1;
		
		for (i in 0...length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs) {
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3) colors = [146, 113, 253];
				#if MULTI_MODDABLE
				if (curCategory == '') addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]), 'Easy, Normal, Hard');
				else {
					var category = FreeplayCategory.categoriesLoaded.get(curCategory);
					for (modSong in 0...category.songs.length) {
						addSong(category.songs[modSong][0], i, category.songs[modSong][1], FlxColor.fromRGB(category.songColors[modSong][0], category.songColors[modSong][1], category.songColors[modSong][2]), category.songs[modSong][2]);
					}
				}
				#else
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
				#end
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		/* shit is weird rn
		var categoryText:Alphabet = new Alphabet(FlxG.width + 200, FlxG.height + 200, FreeplayCategoryState.categoryNames[FreeplayCategoryState.curSelected], true);
		categoryText.isMenuItem = true;
		categoryText.scaleX = 0.7;
		categoryText.scaleY = 0.7;
		categoryText.alpha = 0.5;
		categoryText.x -= categoryText.width;
		add(categoryText);
		*/

		for (i in 0...songs.length)
		{
			songText = new Alphabet(90, 320, songs[i].songName, true);
			songText.isMenuItem = true;
			songText.targetY = i - curSelected;
			grpSongs.add(songText);

			var maxWidth = 980;
			if (songText.width > maxWidth)
			{
				songText.scaleX = maxWidth / songText.width;
			}
			songText.snapToPosition();
			
			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, '${songs.length} songs total');
		//add(swag);

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = 64453kdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy. / Hold ALT to skip choosing your character.";
		var size:Int = 12;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

		//add(blackBG);
		//FlxTween.tween(blackBG, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});

		lightingBG.blend = ADD;
		lightingBG.alpha = 0;
		add(lightingBG);

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int, difficulties:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color, difficulties));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		PlayState.grabbablePlayBackRate = ClientPrefs.getGameplaySetting('songspeed', 1);
		FlxG.sound.music.pitch = PlayState.grabbablePlayBackRate;
		for (i in 0...iconArray.length) {
			if (i == lastSelectedSong)
				continue;

			iconArray[i].scale.set(1, 1);
		}

		if (lastSelectedSong != -1 && iconArray[lastSelectedSong] != null)
			iconArray[lastSelectedSong].scale.set(FlxMath.lerp(iconArray[lastSelectedSong].scale.x, 1, elapsed * 9),
				FlxMath.lerp(iconArray[lastSelectedSong].scale.y, 1, elapsed * 9));

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		var mouseToggle:Bool = false;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP && !selectedSomethin)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP && !selectedSomethin)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if (FlxG.mouse.justPressedMiddle && !selectedSomethin)
			{
				if (mouseToggle) mouseToggle = false;
				else mouseToggle = true;
			}

			if((controls.UI_DOWN || controls.UI_UP) && !selectedSomethin)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				changeDiff();
				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
				}
			}

			if(FlxG.mouse.wheel != 0 && !mouseToggle && !selectedSomethin)
			{
				changeDiff();
				SoundEffects.playSFX('scroll', false);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
			} else if (FlxG.mouse.wheel != 0 && mouseToggle) {
				changeDiff(-FlxG.mouse.wheel);
				SoundEffects.playSFX('scroll', false);
			}
		}

		if (controls.UI_LEFT_P && !selectedSomethin)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P && !selectedSomethin)
			changeDiff(1);
		else if ((upP || downP) && !selectedSomethin) changeDiff();

		if ((controls.BACK || FlxG.mouse.justPressedRight) && !selectedSomethin)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			SoundEffects.playSFX('cancel', false);
			MusicBeatState.switchState(new FreeplayCategoryState());

			if (ClientPrefs.mainSong == 'Iconic'|| ClientPrefs.mainSong == 'Iconic (Extended)') {
				Conductor.changeBPM(118);
			} else {
				Conductor.changeBPM(titleJSON.bpm);
			}
		}

		if(ctrl && !selectedSomethin)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space && !selectedSomethin)
		{
			if(instPlaying != curSelected)
			{
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				try {
					PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
					FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
					Paths.currentModDirectory = songs[curSelected].folder;
					instPlaying = curSelected;
					destroyFreeplayVocals();
					Conductor.changeBPM(PlayState.SONG.bpm);
				} catch (e:Any) {
					trace ('Cannot find chart file: "$poop"');
				}
			}
		}

		else if ((accepted || FlxG.mouse.justPressed) && !selectedSomethin)
		{
			var shiftPressed:Bool = false;
			var altPressed:Bool = false;

			if (FlxG.keys.pressed.SHIFT) { 
				shiftPressed = true;
			} else if (FlxG.keys.pressed.ALT) {
				altPressed = true;
			}
			persistentUpdate = false;
			songLowercase = Paths.formatToSongPath(songs[curSelected].songName);
			songJson = Highscore.formatSong(songLowercase, curDifficulty);

			try {
				PlayState.SONG = Song.loadFromJson(songJson, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;
				selectedSomethin = true;
				for (i in 0...grpSongs.members.length)
				{
					if (i == curSelected)
					{
						FlxFlicker.flicker(grpSongs.members[i], 1, 0.06, false, false);
						FlxFlicker.flicker(iconArray[i], 1, 0.06, false, false);
					}
					else
					{
						FlxTween.tween(grpSongs.members[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
						FlxTween.tween(iconArray[i], {alpha: 0.0}, 0.4, {ease: FlxEase.quadIn});
					}
				}

				SoundEffects.playSFX('confirm', false);
				destroyFreeplayVocals();
				persistentUpdate = false;
				new FlxTimer().start(1, function(tmr:FlxTimer) {
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
					if(colorTween != null) {
						colorTween.cancel();
					}
					if (shiftPressed) {
						LoadingState.loadAndSwitchState(new ChartingState());
					} else if (altPressed) {
						LoadingState.loadAndSwitchState(new PlayState());
					} else {
						if (!PlayState.SONG.charSelectSkip)
							LoadingState.loadAndSwitchState(new CharMenu());
						else
							LoadingState.loadAndSwitchState(new PlayState());
					}
					FlxG.sound.music.volume = 0;
					destroyFreeplayVocals();
				});
			} catch(e:Any) {
				trace ('Cannot find chart file: "$songJson"');
				var errorText:FlxText = new FlxText(-70, FlxG.height - 50, 0, "Oops! We can't seem to find your chart file. You sure it's named '"+ songJson +"'?");
				errorText.alpha = 0;
				add(errorText);
				SoundEffects.playSFX('cancel', false);
				FlxTween.tween(errorText, {x: 50, alpha: 1}, 0.4, {ease: FlxEase.quadOut});
				new FlxTimer().start(3, function (tmr:FlxTimer) {
					FlxTween.tween(errorText, {x: -50, alpha: 0}, 2, {ease: FlxEase.quadOut});
				});
			}
		}

		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			SoundEffects.playSFX('scroll', false);
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0) {
			curDifficulty = CoolUtil.difficulties.length-1;
		}

		if (curDifficulty >= CoolUtil.difficulties.length) {
			curDifficulty = 0;
		}

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = '${CoolUtil.difficultyString()}';
		lastDifficultyName = CoolUtil.difficulties[curDifficulty];
		positionHighscore();

		switch(diffText.text.toUpperCase()) {
			case "EASY":
				diffText.color = 0xFF00FF3C;
			case "NORMAL":
				diffText.color = 0xFFFFFF00;
			case "HARD":
				diffText.color = 0xFFFF0000;
			case "EXPERT":
				diffText.color = 0xFF9849d0;
			case "INSANE":
				diffText.color = 0xFFCCCCCC;
			default:
				diffText.color = 0xFFFFFFFF;
		}

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) SoundEffects.playSFX('scroll', false);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].color;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = '';
		if (curCategory != '' && curCategory != 'base game') { //if this isn't vanilla
			var category = FreeplayCategory.categoriesLoaded.get(curCategory);
			for (modSong in 0...category.songs.length) {
				if (modSong == curSelected) diffStr = category.songs[modSong][2];
			}
		} else {
			diffStr = WeekData.getCurrentWeek().difficulties;
		}

		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	override function beatHit() {
		super.beatHit();
		if (lastSelectedSong != -1 && iconArray[lastSelectedSong] != null)
			iconArray[lastSelectedSong].scale.add(0.2, 0.2);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var difficulties:String;

	public function new(song:String, week:Int, songCharacter:String, color:Int, difficulties:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.difficulties = difficulties;
		this.folder = Paths.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
