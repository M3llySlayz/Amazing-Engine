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
	var chartPathInputTxt:FlxUIInputText;
	var chartExtensionTxt:FlxText;
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

		chartPathInputTxt = new FlxUIInputText(0, chartSaveBG.y + chartSaveBG.height - 40, Std.int(chartSaveBG.width / 1.5), 'assets/data/${Paths.formatToSongPath(PlayState.SONG.song)}/${Paths.formatToSongPath(PlayState.SONG.song)+CoolUtil.getDifficultyFilePath()}.json', 16);
		chartPathInputTxt.screenCenter(X);
		add(chartPathInputTxt);

		importCallback = function() {
			trace('Work in progress');
		};

		exportCallback = function() {
			try {
                sys.io.File.saveContent(chartPathInputTxt.text, haxe.Json.stringify({"song": PlayState.SONG}, "\t"));
            } catch (e:Any) {
                trace('Failed to save chart: "${chartPathInputTxt.text}"\n- Not a valid directory!');
            }
			/* CoolUtil.dumpText(
				chartPathInputTxt.text.replace('${Paths.formatToSongPath(PlayState.SONG.song)}/${Paths.formatToSongPath(PlayState.SONG.song)+CoolUtil.getDifficultyFilePath()}', ''),
				chartPathInputTxt.text.replace('assets/data/', ''), 'json', haxe.Json.stringify({"song": PlayState.SONG}, "\t")
			); */
		};

		chartImportButton = new FlxButton(chartSaveBG.x + 360, chartSaveBG.y + chartSaveBG.height - 68, 'Import', importCallback);
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
		chartPathInputTxt.scrollFactor.set();
	}

	override public function update(elapsed:Float) {
		if(chartPathInputTxt.hasFocus) {
			FlxG.sound.muteKeys = [];
			FlxG.sound.volumeDownKeys = [];
			FlxG.sound.volumeUpKeys = [];
			if(FlxG.keys.justPressed.ENTER) {
				chartPathInputTxt.hasFocus = false;
			}
		} else {
			FlxG.sound.muteKeys = TitleState.muteKeys;
			FlxG.sound.volumeDownKeys = TitleState.volumeDownKeys;
			FlxG.sound.volumeUpKeys = TitleState.volumeUpKeys;
			if(controls.BACK) close();
			//if(controls.UI_LEFT_P) trace(chartPathInputTxt.name);	
		}
		super.update(elapsed);
	}
}
