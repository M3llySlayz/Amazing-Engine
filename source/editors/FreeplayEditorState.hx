package editors;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.ui.FlxButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import flash.net.FileFilter;
import lime.system.Clipboard;
import haxe.Json;
#if sys
import sys.io.File;
import sys.FileSystem;
#end
import Category;

using StringTools;

class CategoryEditorState extends MusicBeatState
{
	var categoryFile:CategoryFile = null;
	public function new(categoryFile:CategoryFile = null)
	{
		super();
		this.categoryFile = Category.createCategoryFile();
		if(CategoryFile != null) this.CategoryFile = CategoryFile;
	}

	var bg:FlxSprite;
	private var categoryImage:FlxSprite;
	private var alphabetText:Alphabet;

	override function create() {
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;

		bg.color = FlxColor.WHITE;
		add(bg);

		categoryImage = new FlxSprite().loadGraphic(Paths.image('categories/base game'));
		categoryImage.antialiasing = ClientPrefs.globalAntialiasing;
		categoryImage.screenCenter();
		categoryImage.updateHitbox();
		add(categoryImage);

		alphabetText = new Alphabet(0, FlxG.height - 200, 'base game', true);
        alphabetText.x = categoryImage.width / 3;
        alphabetText.alpha = 1;
        alphabetText.x -= 60;
        add(alphabetText);

		addEditorBox();
		super.create();
	}

	override function update(elapsed:Float) {
		if(CategoryEditorState.loadedCategory != null) {
			super.update(elapsed);
			MusicBeatState.switchState(new CategoryEditorCategoryState(CategoryEditorState.loadedCategory));
			CategoryEditorState.loadedCategory = null;
			return;
		}
		
		if(imageInputText.hasFocus) {
			FlxG.sound.muteKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.volumeUpKeys = [];
			if(FlxG.keys.justPressed.ENTER) {
				imageInputText.hasFocus = false;
			}
		} else {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
			if(FlxG.keys.justPressed.ESCAPE) {
				MusicBeatState.switchState(new editors.MasterEditorMenu());
				FlxG.sound.playMusic(Paths.music(ClientPrefs.mainSong));
			}
		}
		super.update(elapsed);
	}

	var UI_box:FlxUITabMenu;
	var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	function addEditorBox() {
		var tabs = [
			{name: 'Category', label: 'Category'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 200);
		UI_box.x = FlxG.width - UI_box.width - 100;
		UI_box.y = FlxG.height - UI_box.height - 60;
		UI_box.scrollFactor.set();
		
		UI_box.selected_tab_id = 'Category';
		addCategoryUI();
		add(UI_box);

		var blackBlack:FlxSprite = new FlxSprite(0, 630).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackBlack.alpha = 0.6;
		add(blackBlack);

		var loadCategoryButton:FlxButton = new FlxButton(0, 650, "Load Category", function() {
			CategoryEditorState.loadCategory();
		});
		loadCategoryButton.screenCenter(X);
		loadCategoryButton.x -= 120;
		add(loadCategoryButton);
		
		var storyModeButton:FlxButton = new FlxButton(0, 650, "Story Mode", function() {
			MusicBeatState.switchState(new CategoryEditorState(CategoryFile));
			
		});
		storyModeButton.screenCenter(X);
		add(storyModeButton);

		var freeplayButton:FlxButton = new FlxButton(0, 685, "Freeplay", function() {
			MusicBeatState.switchState(new CategoryEditorFreeplayState(CategoryFile));
			
		});
		freeplayButton.screenCenter(X);
		add(freeplayButton);
	
		var saveCategoryButton:FlxButton = new FlxButton(0, 650, "Save Category", function() {
			FreeplayEditorState.saveCategory(categoryFile);
		});
		saveCategoryButton.screenCenter(X);
		saveCategoryButton.x += 120;
		add(saveCategoryButton);
	}

	var bgColorStepperR:FlxUINumericStepper;
	var bgColorStepperG:FlxUINumericStepper;
	var bgColorStepperB:FlxUINumericStepper;
	var imageInputText:FlxUIInputText;
	function addCategoryUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Category";

		bgColorStepperR = new FlxUINumericStepper(10, 40, 20, 255, 0, 255, 0);
		bgColorStepperG = new FlxUINumericStepper(80, 40, 20, 255, 0, 255, 0);
		bgColorStepperB = new FlxUINumericStepper(150, 40, 20, 255, 0, 255, 0);

		var copyColor:FlxButton = new FlxButton(10, bgColorStepperR.y + 25, "Copy Color", function() {
			Clipboard.text = bg.color.red + ',' + bg.color.green + ',' + bg.color.blue;
		});
		var pasteColor:FlxButton = new FlxButton(140, copyColor.y, "Paste Color", function() {
			if(Clipboard.text != null) {
				var leColor:Array<Int> = [];
				var splitted:Array<String> = Clipboard.text.trim().split(',');
				for (i in 0...splitted.length) {
					var toPush:Int = Std.parseInt(splitted[i]);
					if(!Math.isNaN(toPush)) {
						if(toPush > 255) toPush = 255;
						else if(toPush < 0) toPush *= -1;
						leColor.push(toPush);
					}
				}

				if(leColor.length > 2) {
					imageInputText.text = CategoryFile.category;
					bgColorStepperR.value = leColor[0];
					bgColorStepperG.value = leColor[1];
					bgColorStepperB.value = leColor[2];
					updateBG();
				}
			}
		});

		imageInputText = new FlxUIInputText(10, bgColorStepperR.y + 70, 100, 'base game', 8);
		
		tab_group.add(new FlxText(10, bgColorStepperR.y - 18, 0, 'Selected background Color R/G/B:'));
		tab_group.add(new FlxText(10, imageInputText.y - 18, 0, 'Selected image:'));
		tab_group.add(bgColorStepperR);
		tab_group.add(bgColorStepperG);
		tab_group.add(bgColorStepperB);
		tab_group.add(copyColor);
		tab_group.add(pasteColor);
		tab_group.add(imageInputText);
		UI_box.addGroup(tab_group);
	}

	function updateBG() {
		CategoryFile.categoryColor[0] = Math.round(bgColorStepperR.value);
		CategoryFile.categoryColor[1] = Math.round(bgColorStepperG.value);
		CategoryFile.categoryColor[2] = Math.round(bgColorStepperB.value);
		bg.color = FlxColor.fromRGB(CategoryFile.categoryColor[0], CategoryFile.categoryColor[1], CategoryFile.categoryColor[2]);
	}

	function updateImage() {
		remove(categoryImage);
		categoryImage.destroy();
		categoryImage = new FlxSprite().loadGraphic(Paths.image('categories/' + CategoryFile.category));
		categoryImage.antialiasing = ClientPrefs.globalAntialiasing;
		categoryImage.screenCenter();
		add(categoryImage);
	}

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			CategoryFile.category = imageInputText.text.trim();
			alphabetText.text = imageInputText.text.trim();
            alphabetText.x = categoryImage.width / 3;
			alphabetText.x -= 60;
			updateImage();
		} else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			if(sender == bgColorStepperR || sender == bgColorStepperG || sender == bgColorStepperB) {
				updateBG();
			}
		}
	}
}

class FreeplayEditorState extends MusicBeatState
{
	var CategoryFile:CategoryFile = null;
	public function new(CategoryFile:CategoryFile = null)
	{
		super();
		this.CategoryFile = CategoryData.createCategoryFile();
		if(CategoryFile != null) this.CategoryFile = CategoryFile;
	}

	var bg:FlxSprite;
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<HealthIcon> = [];

	var curSelected = 0;

	override function create() {
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;

		bg.color = FlxColor.WHITE;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...CategoryFile.songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, CategoryFile.songs[i][0], true);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			songText.snapToPosition();

			var icon:HealthIcon = new HealthIcon(CategoryFile.songs[i][1]);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		addEditorBox();
		changeSelection();
		super.create();
	}
	
	var UI_box:FlxUITabMenu;
	var blockPressWhileTypingOn:Array<FlxUIInputText> = [];
	function addEditorBox() {
		var tabs = [
			{name: 'Freeplay', label: 'Freeplay'},
		];
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(250, 200);
		UI_box.x = FlxG.width - UI_box.width - 100;
		UI_box.y = FlxG.height - UI_box.height - 60;
		UI_box.scrollFactor.set();
		
		UI_box.selected_tab_id = 'Category';
		addFreeplayUI();
		add(UI_box);

		var blackBlack:FlxSprite = new FlxSprite(0, 630).makeGraphic(FlxG.width, 50, FlxColor.BLACK);
		blackBlack.alpha = 0.6;
		add(blackBlack);

		var loadCategoryButton:FlxButton = new FlxButton(0, 650, "Load Category", function() {
			CategoryEditorState.loadCategory();
		});
		loadCategoryButton.screenCenter(X);
		loadCategoryButton.x -= 120;
		add(loadCategoryButton);
		
		var storyModeButton:FlxButton = new FlxButton(0, 650, "Story Mode", function() {
			MusicBeatState.switchState(new CategoryEditorState(CategoryFile));
			
		});
		storyModeButton.screenCenter(X);
		add(storyModeButton);

		var categoryButton:FlxButton = new FlxButton(0, 685, "Category", function() {
			MusicBeatState.switchState(new CategoryEditorCategoryState(CategoryFile));
			
		});
		categoryButton.screenCenter(X);
		add(categoryButton);
	
		var saveCategoryButton:FlxButton = new FlxButton(0, 650, "Save Category", function() {
			CategoryEditorState.saveCategory(CategoryFile);
		});
		saveCategoryButton.screenCenter(X);
		saveCategoryButton.x += 120;
		add(saveCategoryButton);
	}
	
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>) {
		if(id == FlxUIInputText.CHANGE_EVENT && (sender is FlxUIInputText)) {
			CategoryFile.songs[curSelected][1] = iconInputText.text;
			iconArray[curSelected].changeIcon(iconInputText.text);
		} else if(id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)) {
			if(sender == bgColorStepperR || sender == bgColorStepperG || sender == bgColorStepperB) {
				updateBG();
			}
		}
	}

	var bgColorStepperR:FlxUINumericStepper;
	var bgColorStepperG:FlxUINumericStepper;
	var bgColorStepperB:FlxUINumericStepper;
	var iconInputText:FlxUIInputText;
	function addFreeplayUI() {
		var tab_group = new FlxUI(null, UI_box);
		tab_group.name = "Freeplay";

		bgColorStepperR = new FlxUINumericStepper(10, 40, 20, 255, 0, 255, 0);
		bgColorStepperG = new FlxUINumericStepper(80, 40, 20, 255, 0, 255, 0);
		bgColorStepperB = new FlxUINumericStepper(150, 40, 20, 255, 0, 255, 0);

		var copyColor:FlxButton = new FlxButton(10, bgColorStepperR.y + 25, "Copy Color", function() {
			Clipboard.text = bg.color.red + ',' + bg.color.green + ',' + bg.color.blue;
		});
		var pasteColor:FlxButton = new FlxButton(140, copyColor.y, "Paste Color", function() {
			if(Clipboard.text != null) {
				var leColor:Array<Int> = [];
				var splitted:Array<String> = Clipboard.text.trim().split(',');
				for (i in 0...splitted.length) {
					var toPush:Int = Std.parseInt(splitted[i]);
					if(!Math.isNaN(toPush)) {
						if(toPush > 255) toPush = 255;
						else if(toPush < 0) toPush *= -1;
						leColor.push(toPush);
					}
				}

				if(leColor.length > 2) {
					bgColorStepperR.value = leColor[0];
					bgColorStepperG.value = leColor[1];
					bgColorStepperB.value = leColor[2];
					updateBG();
				}
			}
		});

		iconInputText = new FlxUIInputText(10, bgColorStepperR.y + 70, 100, '', 8);

		var hideFreeplayCheckbox:FlxUICheckBox = new FlxUICheckBox(10, iconInputText.y + 30, null, null, "Hide Category from Freeplay?", 100);
		hideFreeplayCheckbox.checked = CategoryFile.hideFreeplay;
		hideFreeplayCheckbox.callback = function()
		{
			CategoryFile.hideFreeplay = hideFreeplayCheckbox.checked;
		};
		
		tab_group.add(new FlxText(10, bgColorStepperR.y - 18, 0, 'Selected background Color R/G/B:'));
		tab_group.add(new FlxText(10, iconInputText.y - 18, 0, 'Selected icon:'));
		tab_group.add(bgColorStepperR);
		tab_group.add(bgColorStepperG);
		tab_group.add(bgColorStepperB);
		tab_group.add(copyColor);
		tab_group.add(pasteColor);
		tab_group.add(iconInputText);
		tab_group.add(hideFreeplayCheckbox);
		UI_box.addGroup(tab_group);
	}

	function updateBG() {
		CategoryFile.songs[curSelected][2][0] = Math.round(bgColorStepperR.value);
		CategoryFile.songs[curSelected][2][1] = Math.round(bgColorStepperG.value);
		CategoryFile.songs[curSelected][2][2] = Math.round(bgColorStepperB.value);
		bg.color = FlxColor.fromRGB(CategoryFile.songs[curSelected][2][0], CategoryFile.songs[curSelected][2][1], CategoryFile.songs[curSelected][2][2]);
	}

	function changeSelection(change:Int = 0) {
		SoundEffects.playSFX('scroll', false);

		curSelected += change;

		if (curSelected < 0)
			curSelected = FreeplayCategoryFile.songs.length - 1;
		if (curSelected >= CategoryFile.songs.length)
			curSelected = 0;

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
		trace(CategoryFile.songs[curSelected]);
		iconInputText.text = CategoryFile.songs[curSelected][1];
		bgColorStepperR.value = Math.round(CategoryFile.songs[curSelected][2][0]);
		bgColorStepperG.value = Math.round(CategoryFile.songs[curSelected][2][1]);
		bgColorStepperB.value = Math.round(CategoryFile.songs[curSelected][2][2]);
		updateBG();
	}

	override function update(elapsed:Float) {
		if(CategoryEditorState.loadedCategory != null) {
			super.update(elapsed);
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new CategoryEditorFreeplayState(CategoryEditorState.loadedCategory));
			CategoryEditorState.loadedCategory = null;
			return;
		}
		
		if(iconInputText.hasFocus) {
			FlxG.sound.muteKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.volumeUpKeys = [];
			if(FlxG.keys.justPressed.ENTER) {
				iconInputText.hasFocus = false;
			}
		} else {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
			if(FlxG.keys.justPressed.ESCAPE) {
				MusicBeatState.switchState(new editors.MasterEditorMenu());
				FlxG.sound.playMusic(Paths.music(ClientPrefs.mainSong));
			}

			if(controls.UI_UP_P) changeSelection(-1);
			if(controls.UI_DOWN_P) changeSelection(1);
		}
		super.update(elapsed);
	}

	private static var _file:FileReference;
	public static function loadCategory() {
		var jsonFilter:FileFilter = new FileFilter('JSON', 'json');
		_file = new FileReference();
		_file.addEventListener(Event.SELECT, onLoadComplete);
		_file.addEventListener(Event.CANCEL, onLoadCancel);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file.browse([jsonFilter]);
	}
	
	public static var loadedCategory:CategoryFile = null;
	public static var loadError:Bool = false;
	private static function onLoadComplete(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);

		#if sys
		var fullPath:String = null;
		@:privateAccess
		if(_file.__path != null) fullPath = _file.__path;

		if(fullPath != null) {
			var rawJson:String = File.getContent(fullPath);
			if(rawJson != null) {
				loadedCategory = cast Json.parse(rawJson);
				if(loadedCategory.CategoryCharacters != null && loadedCategory.CategoryName != null) //Make sure it's really a Category
				{
					var cutName:String = _file.name.substr(0, _file.name.length - 5);
					trace("Successfully loaded file: " + cutName);
					loadError = false;

					CategoryFileName = cutName;
					_file = null;
					return;
				}
			}
		}
		loadError = true;
		loadedCategory = null;
		_file = null;
		#else
		trace("File couldn't be loaded! You aren't on Desktop, are you?");
		#end
	}

	/**
		* Called when the save file dialog is cancelled.
		*/
		private static function onLoadCancel(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Cancelled file loading.");
	}

	/**
		* Called if there is an error while saving the gameplay recording.
		*/
	private static function onLoadError(_):Void
	{
		_file.removeEventListener(Event.SELECT, onLoadComplete);
		_file.removeEventListener(Event.CANCEL, onLoadCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		_file = null;
		trace("Problem loading file");
	}

	public static function saveCategory(categoryFile:CategoryFile) {
		var data:String = Json.stringify(categoryFile, "\t");
		if (data.length > 0)
		{
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data, categoryFileName + ".json");
		}
	}

	private static function onSaveComplete(_):Void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL, onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
			FlxG.log.notice("Successfully saved file.");
		}
	
		/**
			* Called when the save file dialog is cancelled.
			*/
			private static function onSaveCancel(_):Void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL, onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
		}
	
		/**
			* Called if there is an error while saving the gameplay recording.
			*/
		private static function onSaveError(_):Void
		{
			_file.removeEventListener(Event.COMPLETE, onSaveComplete);
			_file.removeEventListener(Event.CANCEL, onSaveCancel);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file = null;
			FlxG.log.error("Problem saving file");
		}
}
