package;

#if DISCORD_ALLOWED
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.graphics.FlxGraphic;
import WeekData;

import sys.FileSystem;

using StringTools;

class AmazingStoryMenuState extends MusicBeatState
{
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var scoreText:FlxText;

	private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

	var txtWeekTitle:FlxText;
	var bgSprite:FlxSprite;

	private static var curWeek:Int = 0;

	var tracksBG:FlxSprite;
	var tracksSprite:FlxSprite;
	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<AmazingMenuItem>;
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectorBG:FlxSprite;
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var loadedWeeks:Array<WeekData> = [];
	var mouseToggle:Bool = false;

	override function create()
	{
		if (!ClientPrefs.bigCache) {
			Paths.clearStoredMemory();
			Paths.clearUnusedMemory();
		}

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		persistentUpdate = persistentDraw = true;

		//var sideBar:FlxSprite = new FlxSprite().makeGraphic(350, FlxG.height, 0xFF520712);
		//add(sideBar);

		bgSprite = new FlxSprite(FlxG.width - 360, 64);
		bgSprite.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgSprite);

		tracksSprite = new FlxSprite(18, FlxG.height - 400).loadGraphic(Paths.image('Menu_Tracks'));
		tracksSprite.x = 218 - (tracksSprite.width / 1.35);
		tracksSprite.antialiasing = ClientPrefs.globalAntialiasing;

		tracksBG = new FlxSprite(12, tracksSprite.y - 4).makeGraphic(324, Std.int(tracksSprite.height * 1.25), FlxColor.BLACK);
		tracksBG.antialiasing = ClientPrefs.globalAntialiasing;

		add(tracksBG);
		add(tracksSprite);

		txtTracklist = new FlxText(tracksBG.x + 4, tracksBG.y + (tracksSprite.height + 5), 300, "", 32);
		txtTracklist.setFormat(Paths.font("vcr.ttf"), 32, CENTER);
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		grpWeekText = new FlxTypedGroup<AmazingMenuItem>();
		add(grpWeekText);

		scoreText = new FlxText(0, FlxG.height - 34, 0, "SCORE: 49324858", 32);
		scoreText.setFormat("VCR OSD Mono", 32);
		scoreText.screenCenter(X);
		add(scoreText);

		var sideBarWeekTitle:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 64, 0xFF520712);
		add(sideBarWeekTitle);

		txtWeekTitle = new FlxText(12, 12, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.BLACK, LEFT);
		add(txtWeekTitle);

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Menu", "Picking a week", null, false, null, 'storymode');
		#end

		var num:Int = 0;
		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		for (i in 0...WeekData.weeksList.length)
		{
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
				var weekName:String = WeekData.weeksList[i];
				if (!FileSystem.exists('assets/images/storymenu/icons/$weekName.png')) weekName = 'weekCustom';
				var weekThing:AmazingMenuItem = new AmazingMenuItem(600, 20, "icons/" + weekName);
				weekThing.y += (weekThing.height + 60) * num;
				weekThing.targetY = num;
				grpWeekText.add(weekThing);

				// Needs an offset thingie
				if (isLocked)
				{
					var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
					lock.frames = ui_tex;
					lock.animation.addByPrefix('lock', 'lock');
					lock.animation.play('lock');
					lock.ID = i;
					lock.antialiasing = ClientPrefs.globalAntialiasing;
					grpLocks.add(lock);
				}
				num++;
			}
		}

		WeekData.setDirectoryFromWeek(loadedWeeks[0]);
		difficultySelectors = new FlxGroup();

		leftArrow = new FlxSprite(150, 59);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		leftArrow.angle = 90;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		sprDifficulty = new FlxSprite(50, leftArrow.y + 25);
		sprDifficulty.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow = new FlxSprite(leftArrow.x, leftArrow.y + 175);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow.angle = 90;

		var bgHeight = 67 + Std.int(leftArrow.height) + Std.int(rightArrow.height) + 10;
		difficultySelectorBG = new FlxSprite(12, leftArrow.y + 5).makeGraphic(324, bgHeight, FlxColor.BLACK);
		difficultySelectorBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(difficultySelectorBG);

		difficultySelectors.add(leftArrow);
		difficultySelectors.add(sprDifficulty);
		difficultySelectors.add(rightArrow);

		add(difficultySelectors);

		changeWeek();
		changeDifficulty();

		super.create();
	}

	override function closeSubState() {
		persistentUpdate = true;
		changeWeek();
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(intendedScore - lerpScore) < 10) lerpScore = intendedScore;
		scoreText.text = "WEEK SCORE: " + lerpScore;
		scoreText.screenCenter(X);

		if (!movedBack && !selectedWeek)
		{
			var leftP = controls.UI_LEFT_P;
			var rightP = controls.UI_RIGHT_P;
			var accepted = controls.ACCEPT;

			if (leftP) changeWeek(-1);
			if (rightP) changeWeek(1);

			if (FlxG.mouse.justPressedMiddle && !stopspamming) {
				if (mouseToggle) {
					mouseToggle = false;
				} else {
					mouseToggle = true;
				}
			}

			if(FlxG.mouse.wheel != 0 && !stopspamming) {
				if (mouseToggle) {
					changeDifficulty(FlxG.mouse.wheel);
				} else {
					changeWeek(-FlxG.mouse.wheel);
				}
			}

			if (controls.UI_UP && !stopspamming)
				leftArrow.animation.play('press')
			else
				leftArrow.animation.play('idle');

			if (controls.UI_DOWN && !stopspamming)
				rightArrow.animation.play('press');
			else
				rightArrow.animation.play('idle');

			if (controls.UI_UP_P && !stopspamming)
				changeDifficulty(1);
			else if (controls.UI_DOWN_P && !stopspamming)
				changeDifficulty(-1);
			else if (leftP || rightP && !stopspamming)
				changeDifficulty();

			if(FlxG.keys.justPressed.CONTROL)
			{
				persistentUpdate = false;
				openSubState(new GameplayChangersSubstate());
			}
			else if(controls.RESET)
			{
				persistentUpdate = false;
				openSubState(new ResetScoreSubState('', curDifficulty, '', curWeek));
			}
			else if ((accepted || FlxG.mouse.justPressed) && !stopspamming)
			{
				selectWeek();
			}
		}

		if ((controls.BACK || FlxG.mouse.justPressedRight) && (!movedBack && !selectedWeek) && !stopspamming)
		{
			SoundEffects.playSFX('cancel', false);
			movedBack = true;
			if (ClientPrefs.luaMenu) {
				PlayState.SONG = Song.loadFromJson('ae-menu', 'ae-menu');
				LoadingState.loadAndSwitchState(new PlayState());
			} else {
				MusicBeatState.switchState(new MainMenuState());
			}
		}

		super.update(elapsed);

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
			lock.visible = (lock.y > FlxG.height / 2);
		});
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		var difficultyString = CoolUtil.getDifficultyFilePath(curDifficulty);
		if(difficultyString == null) difficultyString = '';
		if (!weekIsLocked(loadedWeeks[curWeek].fileName))
		{
			try {
				// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
				var songArray:Array<String> = [];
				var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
				for (i in 0...leWeek.length) {
					songArray.push(leWeek[i][0]);
				}

				PlayState.storyPlaylist = songArray;
				PlayState.isStoryMode = true;
				PlayState.storyDifficulty = curDifficulty;
				PlayState.SONG = Song.loadFromJson('${PlayState.storyPlaylist[0].toLowerCase()}$difficultyString', PlayState.storyPlaylist[0].toLowerCase());
				PlayState.campaignScore = 0;
				PlayState.campaignMisses = 0;

				if (!stopspamming)
				{
					SoundEffects.playSFX('confirm', false);
					grpWeekText.members[curWeek].startFlashing();
					stopspamming = true;
				}
				selectedWeek = true;

				FlxG.sound.music.fadeIn(2.5, 0.7, 0);
				var fg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF777777);
				fg.blend = ADD;
				add(fg);
				FlxTween.tween(fg, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					bg.alpha = 0;
					add(bg);
					FlxTween.tween(bg, {alpha: 1}, 1.5, {onComplete: function(_) {
						LoadingState.loadAndSwitchState(new PlayState(), true);
						FreeplayState.destroyFreeplayVocals();
					}});
				});
			} catch (e:Any) {
				trace ('Cannot find chart file: "${PlayState.storyPlaylist[0].toLowerCase()}$difficultyString"');
			}
		} else {
			SoundEffects.playSFX('cancel', false);
		}
	}

	var tweenDifficulty:FlxTween;
	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = CoolUtil.difficulties[curDifficulty];
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = leftArrow.x - 130;
			sprDifficulty.x += (308 - sprDifficulty.width) / 2;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y + 85;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: sprDifficulty.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;
		if (change != 0) SoundEffects.playSFX('scroll', false);

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);

		var leName:String = leWeek.storyName;
		txtWeekTitle.text = leName.toUpperCase();

		var bullShit:Int = 0;

		var unlocked:Bool = !weekIsLocked(leWeek.fileName);
		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && unlocked)
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		bgSprite.visible = true;
		var assetName:String = leWeek.weekBackground;
		if(assetName == null || assetName.length < 1) {
			bgSprite.visible = false;
		} else {
			bgSprite.loadGraphic(Paths.image('menubackgrounds/menu_' + assetName));
		}
		PlayState.storyWeek = curWeek;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5
		difficultySelectors.visible = unlocked;

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
		updateText();
	}

	public static function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	function updateText()
	{
		var leWeek:WeekData = loadedWeeks[curWeek];
		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) {
			stringThing.push(leWeek.songs[i][0]);
		}

		txtTracklist.text = '';
		for (i in 0...stringThing.length)
		{
			txtTracklist.text += stringThing[i] + '\n';
		}
		txtTracklist.text = txtTracklist.text.toUpperCase();
		tracksBG.makeGraphic(324, Std.int(tracksSprite.height * 1.25) + Std.int(txtTracklist.textField.textHeight) /*flxtext lines haxe*/, FlxColor.BLACK);
		txtTracklist.x = tracksBG.x + 5;

		#if !switch
		intendedScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}
}