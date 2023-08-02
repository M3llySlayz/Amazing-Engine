package editors;

import FreeplayCategory.FreeplayCategoryFile;
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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flash.net.FileFilter;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.utils.Assets as OpenFlAssets;
import openfl.utils.ByteArray;

using StringTools;

class CategoryEditor extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];
	private var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	public var ignoreWarnings = false;

	public var camGame:FlxCamera;
	public var camUI:FlxCamera;
	public var camOther:FlxCamera;

	public var bg:FlxSprite;
	public var categorySpr:FlxSprite;
	public var alphabetText:Alphabet;
	public var lockedTxt:FlxText;
	public var lockIcon:FlxSprite;

	var category:FreeplayCategoryFile = null;
	public function new(category:FreeplayCategoryFile = null) {
		super();
		this.category = FreeplayCategory.createCategoryFile();
		if(category != null) this.category = category;
		else this.category.category = 'example';
	}

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Category Editor", "Listing songs and stuff", null, false, null, 'chart');
		#end

		persistentUpdate = true;

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.color = FlxColor.fromRGB(category.color[0], category.color[1], category.color[2], 255);
		add(bg);

		categorySpr = new FlxSprite().loadGraphic(Paths.image('categories/placeholder'));
		categorySpr.antialiasing = ClientPrefs.globalAntialiasing;
		categorySpr.screenCenter();
		categorySpr.alpha = 0;
		categorySpr.x += 60;
		add(categorySpr);

		alphabetText = new Alphabet(categorySpr.width / 3, FlxG.height - 200, 'Category Name', true);
		alphabetText.alpha = 0;
		alphabetText.x -= 60;
		add(alphabetText);
		
		lockedTxt = new FlxText(0, Std.int(FlxG.height - 200), 0, 'Locked Category!', 64);
		lockedTxt.visible = false;
		add(lockedTxt);

		lockIcon = new FlxSprite(0, 0).loadGraphic(Paths.image('Freeplay_Category_LockIcon'));
		lockIcon.antialiasing = true;
		lockIcon.visible = false;
		lockIcon.screenCenter();
		add(lockIcon);

		//FlxTween.tween(blackBG, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});
		FlxTween.tween(categorySpr, {alpha: 1, x: categorySpr.x - 60}, 0.75, {ease: FlxEase.quintOut, startDelay: 0.15});
		FlxTween.tween(alphabetText, {alpha: 1, x: FlxG.width / 6}, 0.75, {ease: FlxEase.quintOut, startDelay: 0.25});
		lockedTxt.screenCenter(X);
		
		camGame = new FlxCamera();
		camUI = new FlxCamera();
		camOther = new FlxCamera();
		camUI.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camUI, false);
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;

		var tabs = [
			{name: 'Category', label: 'Category'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.cameras = [camUI];
		UI_box.resize(270, 380);
		UI_box.x = 940;
		UI_box.y = 25;
		UI_box.scrollFactor.set();
		add(UI_box);
		UI_box.selected_tab = 0;

		text =
		"W/S or Up/Down - Change selected item
		\nEnter - Apply changes
		\nSpace - Get selected item data
		\nDelete - Delete selected item
		\nR - Reset inputs
		\n1 - Add title
		\n2 - Add credit
		";

		var tipTextArray:Array<String> = text.split('\n');
		for (i in 0...tipTextArray.length) {
			var tipText:FlxText = new FlxText(UI_box.x, UI_box.y + UI_box.height + 8, 0, tipTextArray[i], 14);
			tipText.y += i * 9;
			tipText.setFormat(Paths.font("vcr.ttf"), 14, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			tipText.borderSize = 1;
			tipText.scrollFactor.set();
			add(tipText);
			tipText.cameras = [camUI];
		}

		addCategoryUI();

		bg.color = getCurrentBGColor();
		
		super.create();
	}

	var categoryInput:FlxUIInputText;
	var nameInput:FlxUIInputText;
	var colorInput:FlxUIInputText;
	var colorSquare:FlxSprite;
	var lockedCheck:FlxUICheckBox;
	var hiddenCheck:FlxUICheckBox;

	function addCategoryUI():Void
	{
		var yDist:Float = 20;
		categoryInput = new FlxUIInputText(60, 20, 180, '', 8);
		lockedCheck = new FlxUICheckBox(20, categoryInput.y + yDist, null, null, 'Start Locked?', 110);
		lockedCheck.textX += 3;
		lockedCheck.textY += 4;
		if (FlxG.save.data.lockedCheck == null) FlxG.save.data.lockedCheck = true;
		lockedCheck.checked = FlxG.save.data.lockedCheck;
		lockedCheck.callback = function()
		{
			FlxG.save.data.lockedCheck = lockedCheck.checked;
		};

		nameInput = new FlxUIInputText(60, categoryInput.y + 100, 180, '', 8);
		colorInput = new FlxUIInputText(60, nameInput.y + yDist, 70, '', 8);
		colorSquare = new FlxSprite(colorInput.x + 80, colorInput.y).makeGraphic(15, 15, 0xFFFFFFFF);
		
		blockPressWhileTypingOn.push(categoryInput);
		blockPressWhileTypingOn.push(nameInput);
		blockPressWhileTypingOn.push(colorInput);
		
		var loadFile:FlxButton = new FlxButton(resetAll.x, resetAll.y + 25, "Load Credits", function()
		{
			loadCategory();
		});

		var saveFile:FlxButton = new FlxButton(loadFile.x + 90, loadFile.y, "Save Credits", function()
		{
			saveCategory(category);
		});

		var tab_group_category = new FlxUI(null, UI_box);
		tab_group_category.name = "Category";

		tab_group_category.add(categoryInput);
		tab_group_category.add(nameInput);
		tab_group_category.add(lockedCheck);
		tab_group_category.add(hiddenCheck);
		tab_group_category.add(colorInput);
		tab_group_category.add(makeSquareBorder(colorSquare, 18));
		tab_group_category.add(colorSquare);
		tab_group_category.add(new FlxText(categoryInput.x - 40, categoryInput.y, 0, 'Category:'));
		tab_group_category.add(new FlxText(nameInput.x - 40, nameInput.y, 0, 'Display Name:'));
		tab_group_category.add(new FlxText(colorInput.x - 40, colorInput.y, 0, 'Color:'));

		tab_group_category.add(loadFile);
		tab_group_category.add(saveFile);

		UI_box.addGroup(tab_group_category);
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var blockInput:Bool = false;
		for (inputText in blockPressWhileTypingOn) {
			if(inputText.hasFocus) {
				FlxG.sound.muteKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.volumeUpKeys = [];
				blockInput = true;
				break;
			}
		}		

		if(!quitting && !blockInput)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}
				if(FlxG.mouse.wheel != 0)
				{
					SoundEffects.playSFX('scroll', false);
					changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				}

				if((FlxG.keys.justPressed.S || FlxG.keys.justPressed.DOWN) || (FlxG.keys.justPressed.W || FlxG.keys.justPressed.UP))
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(FlxG.keys.justPressed.ENTER) {
				setItemData();
				updateCreditObjects();
				changeSelection();
			}

			if(FlxG.keys.justPressed.SPACE) {
				dataGoToInputs();
			}

			if(FlxG.keys.justPressed.DELETE) {
				deleteSelItem();
			}

			if(FlxG.keys.pressed.R){
				cleanInputs();
			}

			if(FlxG.keys.justPressed.ONE) {
				addTitle();
			}
			if(FlxG.keys.justPressed.TWO) {
				addCredit();
			}

			if (FlxG.keys.justPressed.BACKSPACE || FlxG.keys.justPressed.ESCAPE || FlxG.mouse.justPressedRight)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.mouse.visible = false;
				//FlxG.sound.play(Paths.sound('cancelMenu'));
				SoundEffects.playSFX('cancel', false);
				MusicBeatState.switchState(new editors.MasterEditorMenu());
				quitting = true;
			}
		}
		if(blockInput){
			if (FlxG.keys.justPressed.ENTER) {
				for (i in 0...blockPressWhileTypingOn.length) {
					if(blockPressWhileTypingOn[i].hasFocus) {
						blockPressWhileTypingOn[i].hasFocus = false;
					}
				}
			}
		}
		
		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				item.x = 200;
			}
		}
		super.update(elapsed);
	}

	function makeSquareBorder(object:FlxSprite, size:Int){ // Just to make color squares look a little nice and easier to see
		var x:Float = object.x;
		var y:Float = object.y;
		var offset:Float = 1.5;

		var border:FlxSprite = new FlxSprite(x - offset, y - offset).makeGraphic(size, size, 0xFF000000);
		return(border);
	}

	function getCurrentBGColor() {
		var bgColor:String = creditsStuff[curSelected][4];
		if(!bgColor.startsWith('0x')) {
			bgColor = '0xFF' + bgColor;
		}
		return Std.parseInt(bgColor);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			if(sender == iconInput) {
				showIconExist(iconInput.text);
			}
			if(sender == colorInput) {
				iconColorShow();
			}
		}
	}

	// Save & Load functions
	var _file:FileReference;
	public static function saveCategory(category:FreeplayCategoryFile) {
		var data:String = Json.stringify(weekFile, "\t");
		if (data.length > 0)
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, category + ".json");
		}
	}
	function onSaveComplete(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.notice("Successfully saved file.");
	}

	function onSaveCancel(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}

	function onSaveError(_):Void
	{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
		FlxG.log.error("Problem saving file");
	}
	
	public static function loadCategory() {
		var jsonFilter:FileFilter = new FileFilter('JSON', 'json');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([jsonFilter]);
	}

	var loadError:Bool = false;
	function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		#if sys
		var fullPath:String = null;
		@:privateAccess
		if(_file.__path != null) fullPath = _file.__path;

		if(fullPath != null) {
			var rawTxt:String = File.getContent(fullPath);
			if(rawTxt != null) {
				creditsStuff = [];
				var firstarray:Array<String> = rawTxt.split('\n');
				for(i in firstarray)
				{
					var arr:Array<String> = i.replace('\\n', '\n').split("::");
					creditsStuff.push(arr);
				}
					
				updateCreditObjects();
				changeSelection();
				return;
			}
		}
		loadError = true;
		_file = null;
		#else
		trace("File couldn't be loaded! You aren't on Desktop, are you?");
		#end
	}

	function onLoadCancel(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Cancelled file loading.");
	}
	
	function onLoadError(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Problem loading file");
	}
}
