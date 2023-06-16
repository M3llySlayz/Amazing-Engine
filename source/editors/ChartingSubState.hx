package editors;

import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

using StringTools;

class ChartingSubState extends MusicBeatSubstate
{
	// Chart Save UI
	var chartSaveBG:FlxSprite;
	var chartSaveTitle:FlxText;
	var chartSaveDescription:FlxText;
	var chartPathImportInputTxt:FlxUIInputText;
	var chartPathExportInputTxt:FlxUIInputText;
	var chartPathFindTxt:FlxText;
	var chartPathSaveTxt:FlxText;
	var chartImportButton:FlxButton;
	var chartExportButton:FlxButton;

	public function new(?uiType = 'None') {
		super();
		switch(uiType) {
			case 'None':
				addBlankUI();
			case 'Saving':
				addChartSavingUI();
			default:
				addBlankUI();
		}
	}

	function addBlankUI() {}

	function addChartSavingUI() {
		var rawChartFile = haxe.Json.stringify({"song": PlayState.SONG}, "\t");

		/* var saveCallback = function() {
			trace('ligma wet balls');
		} */

		var importCallback = function() {
			trace('swag');
		};

		var exportCallback = function() {
			trace('swag');
		};

		chartSaveBG = new FlxSprite().makeGraphic(960, 640, 0xFF000000);
		chartSaveBG.screenCenter();
		chartSaveBG.alpha = 0.5;
		add(chartSaveBG);

		chartSaveTitle = new FlxText(0, chartSaveBG.y + 5, 0, 'Save Chart', 64);
		chartSaveTitle.screenCenter(X);
		add(chartSaveTitle);

		chartSaveDescription = new FlxText(0, chartSaveTitle.y + 66, 0, '- Press BACK to exit', 24);
		chartSaveDescription.screenCenter(X);
		add(chartSaveDescription);

		FlxG.stage.window.textInputEnabled = true;

		chartPathImportInputTxt = new FlxUIInputText(0, chartSaveBG.y + chartSaveBG.height - 72, Std.int(chartSaveBG.width / 1.5), 'assets/data/${Paths.formatToSongPath(PlayState.SONG.song)}/${Paths.formatToSongPath(PlayState.SONG.song)+CoolUtil.getDifficultyFilePath()}.json', 16);
		chartPathImportInputTxt.screenCenter(X);
		add(chartPathImportInputTxt);
		
		chartPathExportInputTxt = new FlxUIInputText(0, chartPathImportInputTxt.y + 32, Std.int(chartSaveBG.width / 1.5), chartPathImportInputTxt.text, 16);
		chartPathExportInputTxt.screenCenter(X);
		add(chartPathExportInputTxt);
		
		chartPathFindTxt = new FlxText(chartPathImportInputTxt.x - 112, chartPathImportInputTxt.y, 0, 'Find: ', 20);
		chartPathFindTxt.antialiasing = false;
		add(chartPathFindTxt);

		chartPathSaveTxt = new FlxText(chartPathFindTxt.x - 32, chartPathExportInputTxt.y, 0, 'Export to: ', 20);
		chartPathSaveTxt.antialiasing = false;
		add(chartPathSaveTxt);

		importCallback = function() {
			try {
				if (sys.FileSystem.exists(chartPathImportInputTxt.text)) {
					if(chartPathImportInputTxt.text.endsWith('.json')) {
						PlayState.SONG = cast haxe.Json.parse(sys.io.File.getContent(chartPathImportInputTxt.text));
						//trace(cast haxe.Json.parse(sys.io.File.getContent(chartPathImportInputTxt.text)));
						MusicBeatState.resetState();
					}
				} else {
					trace('Failed to import chart: "${chartPathImportInputTxt.text}"\n- Cannot find chart file: "${chartPathImportInputTxt.text.replace('assets/data/', '')}"');
				}
			} catch (e:Any) {
				trace('Failed to import chart: "${chartPathImportInputTxt.text}"\n- Exception thrown!');
			}
			/* try {
				if (sys.FileSystem.exists(chartPathImportInputTxt.text)) {
					if(chartPathImportInputTxt.text.endsWith('.json')) {
						PlayState.SONG = Song.parseJSONshit(haxe.Json.stringify({"song": chartPathImportInputTxt.text}, "\t"));
						close();
						MusicBeatState.resetState();
					}
				} else {
					trace(PlayState.SONG);
					trace('Failed to import chart: "${chartPathImportInputTxt.text}"\n- Not a valid directory!');
				}
			} catch (e:Any) {
				trace('Failed to import chart: "${chartPathImportInputTxt.text}"\n- Exception thrown!');
			} */
		};

		exportCallback = function() {
			try {
				if(chartPathExportInputTxt.text.endsWith('.json')) sys.io.File.saveContent(chartPathExportInputTxt.text, haxe.Json.stringify({"song": PlayState.SONG}, "\t"));
			} catch (e:Any) {
				trace('Failed to export chart: "${chartPathExportInputTxt.text}"\n- Exception thrown!');
			}
			/* CoolUtil.dumpText(
				chartPathExportInputTxt.text.replace('${Paths.formatToSongPath(PlayState.SONG.song)}/${Paths.formatToSongPath(PlayState.SONG.song)+CoolUtil.getDifficultyFilePath()}', ''),
				chartPathExportInputTxt.text.replace('assets/data/', ''), 'json', haxe.Json.stringify({"song": PlayState.SONG}, "\t")
			); */
		};

		chartImportButton = new FlxButton(chartSaveBG.x + 360, chartSaveBG.y + chartSaveBG.height - 100, 'Import', importCallback);
		chartImportButton.screenCenter(X);
		chartImportButton.x -= Std.int(chartImportButton.width / 1.5);
		add(chartImportButton);

		chartExportButton = new FlxButton(chartImportButton.x + 120, chartImportButton.y, 'Export', exportCallback);
		chartExportButton.screenCenter(X);
		chartExportButton.x += Std.int(chartExportButton.width / 1.5);
		add(chartExportButton);

		// Set Scrollfactors because It's better that way
		chartSaveBG.scrollFactor.set();
		chartSaveTitle.scrollFactor.set();
		chartSaveDescription.scrollFactor.set();
		chartPathImportInputTxt.scrollFactor.set();
		chartPathExportInputTxt.scrollFactor.set();
		chartPathFindTxt.scrollFactor.set();
		chartPathSaveTxt.scrollFactor.set();
	}

	override public function update(elapsed:Float) {
		if(chartPathImportInputTxt.hasFocus || chartPathExportInputTxt.hasFocus) {
			FlxG.sound.muteKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.volumeUpKeys = [];
			if(FlxG.keys.justPressed.ENTER) {
				chartPathImportInputTxt.hasFocus = false;
				chartPathExportInputTxt.hasFocus = false;
			}
		} else {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
			if(controls.BACK) close();
			//if(controls.UI_LEFT_P) trace(chartPathExportInputTxt.name);	
		}
		super.update(elapsed);
	}
}