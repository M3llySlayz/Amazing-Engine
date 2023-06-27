package;

import flixel.FlxG;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

class ClientPrefs {
	public static var downScroll:Bool = false;
	public static var middleScroll:Bool = false;
	public static var opponentStrums:Bool = true;
	public static var showFPS:Bool = true;
	public static var showMEM:Bool = false;
	public static var flashing:Bool = true;
	public static var globalAntialiasing:Bool = true;
	public static var noteSplashes:Bool = true;
	public static var lowQuality:Bool = false;
	public static var shaders:Bool = true;
	public static var framerate:Int = 60;
	public static var cursing:Bool = true;
	public static var violence:Bool = true;
	public static var camZooms:Bool = true;
	public static var camMovement:Bool = true;
	public static var hideHud:Bool = false;
	public static var noteOffset:Int = 0;
	public static var arrowHSV:Array<Array<Int>> = [[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0],
		[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0], 
		[0, 0, 0], [0, 0, 0]
	];
	public static var imagesPersist:Bool = false;
	public static var ghostTapping:Bool = true;
	public static var timeBarType:String = 'Time Left';
	public static var timeBarStyle:String = 'Gradient';
	public static var scoreZoom:Bool = true;
	public static var noReset:Bool = false;
	public static var healthBarAlpha:Float = 1;
	public static var hitsoundVolume:Float = 0;
	public static var pauseMusic:String = 'Tea Time';
	public static var checkForUpdates:Bool = true;
	public static var antimash:Bool = true;
	public static var splitScroll:Bool = false;
	public static var altSplitScroll:Bool = false;
	public static var bigCache:Bool = false;
	public static var devMode:Bool = false;
	public static var mainMenuPos:String = 'Center';
	public static var gameOverSong:String = 'Default';
	public static var sfxPreset:String = 'Default';
	public static var advancedSfx:Bool = false;
	public static var mainSong:String = 'Freaky';
	public static var convertEK:Bool = true;
	public static var showKeybindsOnStart:Bool = true;
	public static var aeWatermarks:Bool = true;
	public static var noteGlow:Bool = false;
	public static var precisions:Bool = false;
	public static var luaMenu:Bool = false;
	public static var splashOpacity:Float = 0.6;
	public static var underlay:Float = 0;
	public static var oppUnderlay:Float = 0;
	public static var screenRes:String = '1280x720';
	public static var pauseExit:String = 'Flicker Out';
	public static var fullscreen:Bool = false;
	public static var resultsScreen:Bool = true;
	public static var justUpdated:Bool = false;
	public static var neededUpdate:Bool = false;
	public static var precisionDecimals:Int = 3;
	public static var cameraMoveOnNotes:Bool = true;
	public static var colorblindMode:String = 'None';
	public static var persistentBeats:Bool = false;
	public static var loadSpeed:Float = 0.7;
	#if desktop
	public static var autoPause:Bool = true;
	#else
	public static var autoPause:Bool = false;
	#end
	public static var comboStacking = true;
	public static var gameplaySettings:Map<String, Dynamic> = [
		'scrollspeed' => 1.0,
		'scrolltype' => 'multiplicative',
		// anyone reading this, amod is multiplicative speed mod, cmod is constant speed mod, and xmod is bpm based speed mod.
		// an amod example would be chartSpeed * multiplier
		// cmod would just be constantSpeed = chartSpeed
		// and xmod basically works by basing the speed on the bpm.
		// iirc (beatsPerSecond * (conductorToNoteDifference / 1000)) * noteSize (110 or something like that depending on it, prolly just use note.height)
		// bps is calculated by bpm / 60
		// oh yeah and you'd have to actually convert the difference to seconds which I already do, because this is based on beats and stuff. but it should work
		// just fine. but I wont implement it because I don't know how you handle sustains and other stuff like that.
		// oh yeah when you calculate the bps divide it by the songSpeed or rate because it wont scroll correctly when speeds exist.
		'songspeed' => 1.0,
		'healthgain' => 1.0,
		'healthloss' => 1.0,
		'instakill' => false,
		'practice' => false,
		'botplay' => false,
		'playAsOpponent' => false
	];

	public static var hitTimingPositionType:Int = 0;
	public static var comboOffset:Array<Int> = [0, 0, 0, 0];
	public static var ratingOffset:Int = 0;
	public static var sickWindow:Int = 45;
	public static var goodWindow:Int = 90;
	public static var badWindow:Int = 135;
	public static var safeFrames:Float = 10;

	#if MODS_ALLOWED
	public static var modsOptsSaves:Map<String, Map<String, Dynamic>> = [];
	#end

	//Every key has two binds, add your key bind in EKData.
	public static var keyBinds:Map<String, Array<FlxKey>> = EKData.Keybinds.defaultKeybinds();

	public static function saveSettings() {
		FlxG.save.data.downScroll = downScroll;
		FlxG.save.data.middleScroll = middleScroll;
		FlxG.save.data.opponentStrums = opponentStrums;
		FlxG.save.data.showFPS = showFPS;
		FlxG.save.data.showMEM = showMEM;
		FlxG.save.data.flashing = flashing;
		FlxG.save.data.globalAntialiasing = globalAntialiasing;
		FlxG.save.data.noteSplashes = noteSplashes;
		FlxG.save.data.lowQuality = lowQuality;
		FlxG.save.data.shaders = shaders;
		FlxG.save.data.framerate = framerate;
		//FlxG.save.data.cursing = cursing;
		//FlxG.save.data.violence = violence;
		FlxG.save.data.camZooms = camZooms;
		FlxG.save.data.camMovement = camMovement;
		FlxG.save.data.noteOffset = noteOffset;
		FlxG.save.data.hideHud = hideHud;
		FlxG.save.data.arrowHSV = arrowHSV;
		FlxG.save.data.imagesPersist = imagesPersist;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.timeBarType = timeBarType;
		FlxG.save.data.timeBarStyle = timeBarStyle;
		FlxG.save.data.scoreZoom = scoreZoom;
		FlxG.save.data.noReset = noReset;
		FlxG.save.data.healthBarAlpha = healthBarAlpha;
		FlxG.save.data.comboOffset = comboOffset;
		FlxG.save.data.hitTimingPositionType = hitTimingPositionType;
		FlxG.save.data.achievementsMap = Achievements.achievementsMap;
		FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;

		FlxG.save.data.ratingOffset = ratingOffset;
		FlxG.save.data.sickWindow = sickWindow;
		FlxG.save.data.goodWindow = goodWindow;
		FlxG.save.data.badWindow = badWindow;
		FlxG.save.data.safeFrames = safeFrames;
		FlxG.save.data.gameplaySettings = gameplaySettings;
		FlxG.save.data.hitsoundVolume = hitsoundVolume;
		FlxG.save.data.pauseMusic = pauseMusic;
		FlxG.save.data.checkForUpdates = checkForUpdates;
		FlxG.save.data.antimash = antimash;
		FlxG.save.data.splitScroll = splitScroll;
		FlxG.save.data.altSplitScroll = altSplitScroll;
		FlxG.save.data.bigCache = bigCache;
		FlxG.save.data.devMode = devMode;
		FlxG.save.data.mainMenuPos = mainMenuPos;
		FlxG.save.data.sfxPreset = sfxPreset;
		FlxG.save.data.advancedSfx = advancedSfx;
		FlxG.save.data.gameOverSong = gameOverSong;
		FlxG.save.data.mainSong = mainSong;
		FlxG.save.data.convertEK = convertEK;
		FlxG.save.data.comboStacking = comboStacking;
		FlxG.save.data.showKeybindsOnStart = showKeybindsOnStart;
		FlxG.save.data.aeWatermarks = aeWatermarks;
		FlxG.save.data.noteGlow = noteGlow;
		FlxG.save.data.precisions = precisions;
		FlxG.save.data.luaMenu = luaMenu;
		FlxG.save.data.splashOpacity = splashOpacity;
		FlxG.save.data.underlay = underlay;
		FlxG.save.data.oppUnderlay = oppUnderlay;
		FlxG.save.data.screenRes = screenRes;
		FlxG.save.data.pauseExit = pauseExit;
		FlxG.save.data.fullscreen = fullscreen;
		FlxG.save.data.resultsScreen = resultsScreen;
		FlxG.save.data.justUpdated = justUpdated;
		FlxG.save.data.neededUpdate = neededUpdate;
		FlxG.save.data.colorBlindMode = colorblindMode;
		FlxG.save.data.precisionDecimals = precisionDecimals;
		FlxG.save.data.cameraMoveOnNotes = cameraMoveOnNotes;
		FlxG.save.data.persistentBeats = persistentBeats;
		FlxG.save.data.loadSpeed = loadSpeed;
		#if desktop
		FlxG.save.data.autoPause = autoPause;
		#end

		FlxG.save.flush();

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'm3llyslayz'); //Placing this in a separate save so that it can be manually deleted without removing your Score and stuff
		save.data.customControls = keyBinds;
		save.flush();
		FlxG.log.add("Settings saved!");
	}

	public static function loadPrefs() {
		if(FlxG.save.data.downScroll != null) {
			downScroll = FlxG.save.data.downScroll;
		}
		if(FlxG.save.data.middleScroll != null) {
			middleScroll = FlxG.save.data.middleScroll;
		}
		if(FlxG.save.data.opponentStrums != null) {
			opponentStrums = FlxG.save.data.opponentStrums;
		}

		if(FlxG.save.data.showFPS != null) {
			showFPS = FlxG.save.data.showFPS;
		}
		if(FlxG.save.data.showMEM != null) {
			showMEM = FlxG.save.data.showMEM;
		}

		if(FlxG.save.data.flashing != null) {
			flashing = FlxG.save.data.flashing;
		}

		if(FlxG.save.data.globalAntialiasing != null) {
			globalAntialiasing = FlxG.save.data.globalAntialiasing;
		}
		if(FlxG.save.data.noteSplashes != null) {
			noteSplashes = FlxG.save.data.noteSplashes;
		}
		if(FlxG.save.data.lowQuality != null) {
			lowQuality = FlxG.save.data.lowQuality;
		}
		if(FlxG.save.data.shaders != null) {
			shaders = FlxG.save.data.shaders;
		}

		if(FlxG.save.data.framerate != null) {
			framerate = FlxG.save.data.framerate;
			if(framerate > FlxG.drawFramerate) {
				FlxG.updateFramerate = framerate;
				FlxG.drawFramerate = framerate;
			} else {
				FlxG.drawFramerate = framerate;
				FlxG.updateFramerate = framerate;
			}
		}

		if(FlxG.save.data.camZooms != null) {
			camZooms = FlxG.save.data.camZooms;
		}
		if(FlxG.save.data.camMovement != null) {
			camMovement = FlxG.save.data.camMovement;
		}
		if(FlxG.save.data.hideHud != null) {
			hideHud = FlxG.save.data.hideHud;
		}
		if(FlxG.save.data.noteOffset != null) {
			noteOffset = FlxG.save.data.noteOffset;
		}
		if(FlxG.save.data.arrowHSV != null) {
			arrowHSV = FlxG.save.data.arrowHSV;
		}
		if(FlxG.save.data.ghostTapping != null) {
			ghostTapping = FlxG.save.data.ghostTapping;
		}
		if(FlxG.save.data.timeBarType != null) {
			timeBarType = FlxG.save.data.timeBarType;
		}
		if(FlxG.save.data.timeBarStyle != null) {
			timeBarStyle = FlxG.save.data.timeBarStyle;
		}
		if(FlxG.save.data.scoreZoom != null) {
			scoreZoom = FlxG.save.data.scoreZoom;
		}
		if(FlxG.save.data.noReset != null) {
			noReset = FlxG.save.data.noReset;
		}
		if(FlxG.save.data.healthBarAlpha != null) {
			healthBarAlpha = FlxG.save.data.healthBarAlpha;
		}
		if(FlxG.save.data.comboOffset != null) {
			comboOffset = FlxG.save.data.comboOffset;
		}
		if(FlxG.save.data.hitTimingPositionType != null) {
			hitTimingPositionType = FlxG.save.data.hitTimingPositionType;
		}
		
		if(FlxG.save.data.ratingOffset != null) {
			ratingOffset = FlxG.save.data.ratingOffset;
		}
		if(FlxG.save.data.sickWindow != null) {
			sickWindow = FlxG.save.data.sickWindow;
		}
		if(FlxG.save.data.goodWindow != null) {
			goodWindow = FlxG.save.data.goodWindow;
		}
		if(FlxG.save.data.badWindow != null) {
			badWindow = FlxG.save.data.badWindow;
		}
		if(FlxG.save.data.safeFrames != null) {
			safeFrames = FlxG.save.data.safeFrames;
		}
		if(FlxG.save.data.hitsoundVolume != null) {
			hitsoundVolume = FlxG.save.data.hitsoundVolume;
		}
		if(FlxG.save.data.pauseMusic != null) {
			pauseMusic = FlxG.save.data.pauseMusic;
		}
		if(FlxG.save.data.gameplaySettings != null)
		{
			var savedMap:Map<String, Dynamic> = FlxG.save.data.gameplaySettings;
			for (name => value in savedMap)
			{
				gameplaySettings.set(name, value);
			}
		}
		
		// flixel automatically saves your volume!
		if(FlxG.save.data.volume != null)
		{
			FlxG.sound.volume = FlxG.save.data.volume;
		}
		if (FlxG.save.data.mute != null)
		{
			FlxG.sound.muted = FlxG.save.data.mute;
		}
		if (FlxG.save.data.checkForUpdates != null)
		{
			checkForUpdates = FlxG.save.data.checkForUpdates;
		}
		if (FlxG.save.data.antimash != null)
		{
			antimash = FlxG.save.data.antimash;
		}
		if (FlxG.save.data.splitScroll != null)
		{
			splitScroll = FlxG.save.data.splitScroll;
		}
		if (FlxG.save.data.altSplitScroll != null)
		{
			altSplitScroll = FlxG.save.data.altSplitScroll;
		}
		if (FlxG.save.data.bigCache != null)
		{
			bigCache = FlxG.save.data.bigCache;
		}
		if (FlxG.save.data.devMode != null)
		{
			devMode = FlxG.save.data.devMode;
		}
		if (FlxG.save.data.mainMenuPos != null)
		{
			mainMenuPos = FlxG.save.data.mainMenuPos;
		}
		if (FlxG.save.data.sfxPreset != null)
		{
			sfxPreset = FlxG.save.data.sfxPreset;
		}
		if (FlxG.save.data.advancedSfx != null)
		{
			advancedSfx = FlxG.save.data.advancedSfx;
		}
		if (FlxG.save.data.gameOverSong != null)
		{
			gameOverSong = FlxG.save.data.gameOverSong;
		}
		if (FlxG.save.data.mainSong != null)
		{
			mainSong = FlxG.save.data.mainSong;
		}
		if (FlxG.save.data.aeWatermarks != null)
		{
			aeWatermarks = FlxG.save.data.aeWatermarks;
		}
		if (FlxG.save.data.noteGlow != null)
		{
			noteGlow = FlxG.save.data.noteGlow;
		}
		if (FlxG.save.data.precisions != null)
		{
			precisions = FlxG.save.data.precisions;
		}
		if (FlxG.save.data.luaMenu != null)
		{
			luaMenu = FlxG.save.data.luaMenu;
		}
		if(FlxG.save.data.splashOpacity != null) {
			splashOpacity = FlxG.save.data.splashOpacity;
		}
		if(FlxG.save.data.underlay != null) {
			underlay = FlxG.save.data.underlay;
		}
		if(FlxG.save.data.oppUnderlay != null) {
			oppUnderlay = FlxG.save.data.oppUnderlay;
		}
		if(FlxG.save.data.screenRes != null) {
			screenRes = FlxG.save.data.screenRes;
		}
		if(FlxG.save.data.pauseExit != null) {
			pauseExit = FlxG.save.data.pauseExit;
		}
		if(FlxG.save.data.fullscreen != null) {
			fullscreen = FlxG.save.data.fullscreen;
			FlxG.fullscreen = fullscreen;
		}
		if(FlxG.save.data.resultsScreen != null) {
			resultsScreen = FlxG.save.data.resultsScreen;
		}
		if(FlxG.save.data.justUpdated != null) {
			justUpdated = FlxG.save.data.justUpdated;
		}
		if(FlxG.save.data.neededUpdate != null) {
			neededUpdate = FlxG.save.data.neededUpdate;
		}
		if(FlxG.save.data.colorblindMode != null) {
			colorblindMode = FlxG.save.data.colorblindMode;
		}
		if(FlxG.save.data.precisionDecimals != null) {
			precisionDecimals = FlxG.save.data.precisionDecimals;
		}
		if(FlxG.save.data.cameraMoveOnNotes != null) {
			cameraMoveOnNotes = FlxG.save.data.cameraMoveOnNotes;
		}
		if(FlxG.save.data.persistentBeats != null) {
			persistentBeats = FlxG.save.data.persistentBeats;
		}
		if(FlxG.save.data.loadSpeed != null) {
			loadSpeed = FlxG.save.data.loadSpeed;
		}
		#if desktop
		if(FlxG.save.data.autoPause != null) {
			autoPause = FlxG.save.data.autoPause;
		}
		#end
		else if(FlxG.save.data.noteSplashes != null) {
			splashOpacity = FlxG.save.data.noteSplashes ? 0.6 : 0;
			FlxG.save.data.noteSplashes = null;
		}
		if (FlxG.save.data.convertEK != null)
		{
			convertEK = FlxG.save.data.convertEK;
		}
		if (FlxG.save.data.comboStacking != null)
			comboStacking = FlxG.save.data.comboStacking;
		if (FlxG.save.data.showKeybindsOnStart != null)
			showKeybindsOnStart = FlxG.save.data.showKeybindsOnStart;

		var save:FlxSave = new FlxSave();
		save.bind('controls_v2', 'm3llyslayz');
		if(save != null && save.data.customControls != null) {
			var loadedControls:Map<String, Array<FlxKey>> = save.data.customControls;
			for (control => keys in loadedControls) {
				keyBinds.set(control, keys);
			}
			reloadControls();
		}
	}

	inline public static function getGameplaySetting(name:String, defaultValue:Dynamic):Dynamic {
		return /*PlayState.isStoryMode ? defaultValue : */ (gameplaySettings.exists(name) ? gameplaySettings.get(name) : defaultValue);
	}

	public static function reloadControls() {
		PlayerSettings.player1.controls.setKeyboardScheme(KeyboardScheme.Solo);
		TitleState.muteKeys = copyKey(keyBinds.get('volume_mute'));
		TitleState.volumeDownKeys = copyKey(keyBinds.get('volume_down'));
		TitleState.volumeUpKeys = copyKey(keyBinds.get('volume_up'));
		FlxG.sound.muteKeys = TitleState.muteKeys;
		FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
		FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey> {
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len) {
			if(copiedArray[i] == NONE) {
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
}
