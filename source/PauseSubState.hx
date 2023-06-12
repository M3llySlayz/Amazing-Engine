package;

import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.effects.FlxFlicker;
#if (flixel < "5.3.0")
import flixel.system.FlxSound;
#else
import flixel.sound.FlxSound;
#end
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [];
	var menuItemsOG:Array<String> = ['Continue', 'Retry', 'Options', 'Modifiers', 'Change Difficulty', 'Quit'];
	var menuItemsQuitting:Array<String> = ['Yes', 'No'];
	var difficultyChoices = [];
	var curSelected:Int = 0;
	var composer:String = '';

	var pauseMusic:FlxSound;
	var authorText:FlxText = new FlxText(20, 640+32, 0, "", 32);
	var practiceText:FlxText;
	var skipTimeText:FlxText;
	var skipTimeTracker:Alphabet;
	var curTime:Float = Math.max(0, Conductor.songPosition);
	var bg:FlxSprite;
	var levelInfo:FlxText;
	var levelDifficulty:FlxText;
	var blueballedTxt:FlxText;
	var quittingTxt:FlxText;
	var chartingText:FlxText;
	//var botplayText:FlxText;

	public static var songName:String = '';

	public function new(x:Float, y:Float)
	{
		super();
		if(CoolUtil.difficulties.length < 2) menuItemsOG.remove('Change Difficulty'); //No need to change difficulty if there is only one!

		if(PlayState.chartingMode)
		{
			menuItemsOG.insert(2, 'Leave Charting Mode');
			
			var num:Int = 0;
			if(!PlayState.instance.startingSong)
			{
				num = 1;
				menuItemsOG.insert(3, 'Skip Time');
			}
			menuItemsOG.insert(3 + num, 'End Song');
			menuItemsOG.insert(4 + num, 'Toggle Practice Mode');
			menuItemsOG.insert(5 + num, 'Toggle Botplay');
		}
		menuItems = menuItemsOG;

		for (i in 0...CoolUtil.difficulties.length) {
			var diff:String = '' + CoolUtil.difficulties[i];
			difficultyChoices.push(diff);
		}
		difficultyChoices.push('BACK');


		pauseMusic = new FlxSound();
		if(songName != null) {
			pauseMusic.loadEmbedded(Paths.music(songName), true, true);
		} else if (songName != 'None') {
			pauseMusic.loadEmbedded(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)), true, true);
		}
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		levelInfo = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		levelDifficulty = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		blueballedTxt = new FlxText(20, 15 + 64, 0, "", 32);
		blueballedTxt.text = "Blueballed: " + PlayState.deathCounter;
		blueballedTxt.scrollFactor.set();
		blueballedTxt.setFormat(Paths.font('vcr.ttf'), 32);
		blueballedTxt.updateHitbox();
		add(blueballedTxt);

		practiceText = new FlxText(20, 15 + 101, 0, "PRACTICE MODE", 32);
		practiceText.scrollFactor.set();
		practiceText.setFormat(Paths.font('vcr.ttf'), 32);
		practiceText.x = FlxG.width - (practiceText.width + 20);
		practiceText.updateHitbox();
		practiceText.visible = PlayState.instance.practiceMode;
		add(practiceText);

		chartingText = new FlxText(20, 15 + 101, 0, "CHARTING MODE", 32);
		chartingText.scrollFactor.set();
		chartingText.setFormat(Paths.font('vcr.ttf'), 32);
		chartingText.x = FlxG.width - (chartingText.width + 20);
		chartingText.y = FlxG.height - (chartingText.height + 20);
		chartingText.updateHitbox();
		chartingText.visible = PlayState.chartingMode;
		add(chartingText);

		quittingTxt = new FlxText(0, 100, 0, "You sure?", 32);
		quittingTxt.scrollFactor.set();
		quittingTxt.setFormat(Paths.font('vcr.ttf'), 32);
		quittingTxt.updateHitbox();
		quittingTxt.visible = false;
		quittingTxt.screenCenter();
		add(quittingTxt);

		if (ClientPrefs.pauseExit == 'Countdown')
			cacheCountdown();

		switch(ClientPrefs.pauseMusic){
			case 'Bossfight' | 'Construct' | 'Confront' | 'Waiting (Impatient)':
				composer = 'Melly and BoyBot69';
				//composerColor = [0xFFFF0000, 0xFF026902];
			case 'Adventure' | 'Bounce':
				composer = 'Melly';
				//composerColor = [0xFFFF0000, 0xFFBD0000];
			case 'Waiting':
				composer = 'BoyBot69';
				//composerColor = [0xFF3DD700, 0xFF026902];
		}

		
		authorText.text += 'By ' + composer;
		authorText.scrollFactor.set();
		authorText.setFormat(Paths.font("vcr.ttf"), 32);
		authorText.drawFrame();
		authorText.updateHitbox();
		add(authorText);

		blueballedTxt.alpha = 0;
		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		blueballedTxt.x = FlxG.width - (blueballedTxt.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		FlxTween.tween(blueballedTxt, {alpha: 1, y: blueballedTxt.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.7});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		regenMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	var holdTime:Float = 0;
	var cantUnpause:Float = 0.1;
	override function update(elapsed:Float)
	{
		cantUnpause -= elapsed;
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);
		updateSkipTextStuff();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (FlxG.mouse.wheel != 0){
			if (FlxG.mouse.wheel > 0){
				changeSelection(-1);
			} else {
				changeSelection(1);
			}
		}

		var daSelected:String = menuItems[curSelected];
		switch (daSelected)
		{
			case 'Skip Time':
				if (controls.UI_LEFT_P)
				{
					//FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					SoundEffects.playSFX('scroll', false);
					curTime -= 1000;
					holdTime = 0;
				}
				if (controls.UI_RIGHT_P)
				{
					//FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
					SoundEffects.playSFX('scroll', false);
					curTime += 1000;
					holdTime = 0;
				}

				if(controls.UI_LEFT || controls.UI_RIGHT)
				{
					holdTime += elapsed;
					if(holdTime > 0.5)
					{
						curTime += 45000 * elapsed * (controls.UI_LEFT ? -1 : 1);
					}

					if(curTime >= FlxG.sound.music.length) curTime -= FlxG.sound.music.length;
					else if(curTime < 0) curTime += FlxG.sound.music.length;
					updateSkipTimeText();
				}
		}

		if (accepted || FlxG.mouse.justPressed && cantUnpause <= 0)
		{
			switch(daSelected){
			case "Continue":
				/*FlxFlicker.flicker(grpMenuShit, 1.5, 0.05, false);
				FlxTween.tween(grpMenuShit, {alpha: 0}, 1, {ease: FlxEase.linear});
				FlxTween.tween(bg, {alpha: 0}, 0.4, {ease: FlxEase.linear});
				FlxTween.tween(levelInfo, {alpha: 0}, 0.4, {ease: FlxEase.linear});
				FlxTween.tween(levelDifficulty, {alpha: 0}, 0.4, {ease: FlxEase.linear});
				FlxTween.tween(blueballedTxt, {alpha: 0}, 0.4, {ease: FlxEase.linear});
			
				new FlxTimer().start(1.5, function(tmr:FlxTimer) {*/
					SoundEffects.playSFX('confirm', false);
					if (ClientPrefs.pauseExit == 'Flicker Out'){
						closeState();
					} else if (ClientPrefs.pauseExit == 'Countdown'){
						countdown();
					} else {
						close();
					}
				case 'Change Difficulty':
					menuItems = difficultyChoices;
					authorText.text = 'Hold ALT to skip character selection.';
					deleteSkipTimeText();
					regenMenu();
				case 'Toggle Practice Mode':
					PlayState.instance.practiceMode = !PlayState.instance.practiceMode;
					PlayState.changedDifficulty = true;
					practiceText.visible = PlayState.instance.practiceMode;
				case 'Toggle Botplay':
					PlayState.instance.cpuControlled = !PlayState.instance.cpuControlled;
					PlayState.changedDifficulty = true;
					PlayState.instance.botplayTxt.visible = PlayState.instance.cpuControlled;
					PlayState.instance.botplayTxt.alpha = 1;
					PlayState.instance.botplaySine = 0;
				case 'Modifiers':
					openSubState(new GameplayChangersSubstate());
				case "Quit":
					SoundEffects.playSFX('confirm', true);
					menuItems = menuItemsQuitting;
					quittingTxt.visible = true;
					regenMenu();
				case "Yes":
					quitSong();
				case "No":
					SoundEffects.playSFX('cancel', true);
					menuItems = menuItemsOG;
					quittingTxt.visible = false;
					regenMenu();
				case "BACK":
					menuItems = menuItemsOG;
					regenMenu();
					authorText.text += 'By ' + composer;
				default:
					closeState();
			}
		}
	}

	function deleteSkipTimeText()
	{
		if(skipTimeText != null)
		{
			skipTimeText.kill();
			remove(skipTimeText);
			skipTimeText.destroy();
		}
		skipTimeText = null;
		skipTimeTracker = null;
	}

	public static function restartSong(noTrans:Bool = false)
	{
		PlayState.instance.paused = true; // For lua
		FlxG.sound.music.volume = 0;
		PlayState.instance.vocals.volume = 0;

		if(noTrans)
		{
			FlxTransitionableState.skipNextTransOut = true;
			FlxG.resetState();
		}
		else
		{
			MusicBeatState.resetState();
		}
	}

	function quitSong()
	{
		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;

		WeekData.loadTheFirstEnabledMod();
		if(PlayState.isStoryMode) {
			MusicBeatState.switchState(new StoryMenuState());
		} else {
			MusicBeatState.switchState(new FreeplayState());
		}
		PlayState.cancelMusicFadeTween();
		FlxG.sound.playMusic(Paths.music(ClientPrefs.pauseMusic));
		PlayState.changedDifficulty = false;
		PlayState.chartingMode = false;
	}

	function closeState(?custom:Int = null)
	{
		var daTime:Float = 1;
	
		Conductor.changeBPM(PlayState.SONG.bpm);
	
		SoundEffects.playSFX('confirm', false);

		var da:Int = curSelected;
		if (custom != null)
		{
			da = custom;
		}
		var daName = menuItems[curSelected];
		for (i in 0...grpMenuShit.members.length)
		{
			if (i == da)
			{
				FlxFlicker.flicker(grpMenuShit.members[i], 1, 0.06, false, false);
			} else {
				FlxTween.tween(grpMenuShit.members[i], {alpha: 0}, 0.2, {ease: FlxEase.quadIn});
			}
			FlxTween.tween(bg, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
			FlxTween.tween(levelInfo, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
			FlxTween.tween(levelDifficulty, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
			FlxTween.tween(blueballedTxt, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
			FlxTween.tween(authorText, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
			if (practiceText.visible)
				FlxTween.tween(practiceText, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
			if (chartingText.visible)
				FlxTween.tween(chartingText, {alpha: 0}, 0.7, {ease: FlxEase.quadIn});
	
		new FlxTimer().start(daTime, function(tmr:FlxTimer)
		{
			if (menuItems == difficultyChoices)
			{
				if(menuItems.length - 1 != da && difficultyChoices.contains(daName)) {
					var name:String = PlayState.SONG.song;
					var poop = Highscore.formatSong(name, da);
					try {
						PlayState.SONG = Song.loadFromJson(poop, name);
						PlayState.storyDifficulty = da;
						if (FlxG.keys.pressed.ALT){
							MusicBeatState.resetState();
						} else {
							LoadingState.loadAndSwitchState(new CharMenu());
						}
						FlxG.sound.music.volume = 0;
						PlayState.changedDifficulty = true;
						PlayState.chartingMode = false;
					} catch (e:Any) {
						trace('Cannot find chart file: "$poop"');
					}
					return;
				}
			} else {
				switch (daName)
				{
	
					case "Retry":
						restartSong();
					case "Options":
						PlayState.seenCutscene = false;
						//WeekData.loadTheFirstEnabledMod();
						PlayState.changedDifficulty = false;
						PlayState.cancelMusicFadeTween();
						//MainMenuState.wasPaused = true;
						MusicBeatState.switchState(new options.pause.OptionsState());
					case "Leave Charting Mode":
						restartSong();
						PlayState.chartingMode = false;
					case 'Skip Time':
						if(curTime < Conductor.songPosition)
						{
							PlayState.startOnTime = curTime;
							restartSong(true);
						}
						else
						{
							if (curTime != Conductor.songPosition)
							{
								PlayState.instance.clearNotesBefore(curTime);
								PlayState.instance.setSongTime(curTime);
							}
						}
					case "End Song":
						PlayState.instance.finishSong(true);
						close();
					}}
				});
			}
		}
		
	
	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

//		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		SoundEffects.playSFX('scroll', false);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));

				if(item == skipTimeTracker)
				{
					curTime = Math.max(0, Conductor.songPosition);
					updateSkipTimeText();
				}
			}
		}
	}

	function regenMenu():Void {
		for (i in 0...grpMenuShit.members.length) {
			var obj = grpMenuShit.members[0];
			obj.kill();
			grpMenuShit.remove(obj, true);
			obj.destroy();
		}

		for (i in 0...menuItems.length) {
			var item = new Alphabet(90, 320, menuItems[i], true);
			item.isMenuItem = true;
			item.targetY = i;
			grpMenuShit.add(item);

			if(menuItems[i] == 'Skip Time')
			{
				skipTimeText = new FlxText(0, 0, 0, '', 64);
				skipTimeText.setFormat(Paths.font("vcr.ttf"), 64, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				skipTimeText.scrollFactor.set();
				skipTimeText.borderSize = 2;
				skipTimeTracker = item;
				add(skipTimeText);

				updateSkipTextStuff();
				updateSkipTimeText();
			}
		}
		curSelected = 0;
		changeSelection();
	}
	
	function updateSkipTextStuff()
	{
		if(skipTimeText == null || skipTimeTracker == null) return;

		skipTimeText.x = skipTimeTracker.x + skipTimeTracker.width + 60;
		skipTimeText.y = skipTimeTracker.y;
		skipTimeText.visible = (skipTimeTracker.alpha >= 1);
	}

	function updateSkipTimeText()
	{
		skipTimeText.text = FlxStringUtil.formatTime(Math.max(0, Math.floor(curTime / 1000)), false) + ' / ' + FlxStringUtil.formatTime(Math.max(0, Math.floor(FlxG.sound.music.length / 1000)), false);
	}

	function cacheCountdown()
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', 'set', 'go']);
		introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);
	
		var introAlts:Array<String> = introAssets.get('default');
		if (PlayState.isPixelStage) introAlts = introAssets.get('pixel');
			
		for (asset in introAlts)
			Paths.image(asset);
			
		Paths.sound('intro3' + PlayState.introSoundsSuffix);
		Paths.sound('intro2' + PlayState.introSoundsSuffix);
		Paths.sound('intro1' + PlayState.introSoundsSuffix);
		Paths.sound('introGo' + PlayState.introSoundsSuffix);
	}

	function countdown()
	{
		var swagCounter:Int = 0;

		var startTimer = new FlxTimer().start(Conductor.crochet / 1000 / PlayState.grabbablePlayBackRate, function(tmr:FlxTimer)
		{
			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready', 'set', 'go']);
			introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

			var introAlts:Array<String> = introAssets.get('default');
			var antialias:Bool = ClientPrefs.globalAntialiasing;
			if(PlayState.isPixelStage) {
				introAlts = introAssets.get('pixel');
				antialias = false;
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + PlayState.introSoundsSuffix), 0.6);
				case 1:
					var ready = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

				if (PlayState.isPixelStage)
					ready.setGraphicSize(Std.int(ready.width * PlayState.daPixelZoom));
					add(ready);
					ready.screenCenter();
					ready.antialiasing = ClientPrefs.globalAntialiasing;
					FlxTween.tween(ready, {/*y: ready.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							remove(ready);
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2' + PlayState.introSoundsSuffix), 0.6);
				case 2:
					var set = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (PlayState.isPixelStage)
						set.setGraphicSize(Std.int(set.width * PlayState.daPixelZoom));

					set.screenCenter();
					add(set);
					set.antialiasing = ClientPrefs.globalAntialiasing;
					FlxTween.tween(set, {/*y: set.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							remove(set);
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1' + PlayState.introSoundsSuffix), 0.6);
				case 3:
					var go = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (PlayState.isPixelStage)
						go.setGraphicSize(Std.int(go.width * PlayState.daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					go.antialiasing = ClientPrefs.globalAntialiasing;
					FlxTween.tween(go, {/*y: go.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							remove(go);
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo' + PlayState.introSoundsSuffix), 0.6);
				case 4:

			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}
}
