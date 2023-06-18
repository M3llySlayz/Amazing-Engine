package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class ResultsScreenSubState extends FlxSubState {
	var background:FlxSprite;
	var resultsText:FlxText;
	var resultsTxt:FlxText;
	var songNameText:FlxText;
	var difficultyNameTxt:FlxText;
	var judgementCounterTxt:FlxText;
	var pressEnterTxt:FlxText;
	var pressEnterTxtSine:Float = 0;

	public var iconPlayer1:HealthIcon;
	public var iconPlayer2:HealthIcon;

	var results = [0];
	var score = 0;
	var misses = 0;
	var percent = 0.0;
	var name = '';

	var selectedSomethin = true;
	public function new(daResults:Array<Int>, campaignScore:Int, songMisses:Int, ratingPercent:Float, ratingName:String) {
		super();
		results = daResults;
		score = campaignScore;
		misses = songMisses;
		percent = ratingPercent;
		name = ratingName;
	}

	override function create() {
		persistentUpdate = true;
		background = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		background.color = FlxColor.fromRGB(
			PlayState.instance.dad.healthColorArray[0],
			PlayState.instance.dad.healthColorArray[1],
			PlayState.instance.dad.healthColorArray[2]
		);
		background.scrollFactor.set();
		background.updateHitbox();
		background.screenCenter();
		background.alpha = 0;
		background.antialiasing = ClientPrefs.globalAntialiasing;
		add(background);

		resultsText = new FlxText(5, 0, 0, 'RESULTS', 72);
		resultsText.scrollFactor.set();
		resultsText.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resultsText.updateHitbox();
		add(resultsText);

		resultsTxt = new FlxText(5, resultsText.height, FlxG.width, '', 48);
		resultsTxt.text = 'Sicks: ' + results[0] + '\nGoods: ' + results[1] + '\nBads: ' + results[2] + '\nShits: ' + results[3];
		resultsTxt.scrollFactor.set();
		resultsTxt.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		resultsTxt.updateHitbox();
		add(resultsTxt);

		songNameText = new FlxText(0, 155, 0, '', 124);
		songNameText.text = "Song: " + PlayState.SONG.song;
		songNameText.scrollFactor.set();
		songNameText.setFormat("VCR OSD Mono", 72, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songNameText.updateHitbox();
		songNameText.screenCenter(X);
		add(songNameText);

		difficultyNameTxt = new FlxText(0, 155 + songNameText.height, 0, '', 100);
		difficultyNameTxt.text = "Difficulty: " + CoolUtil.difficultyString();
		difficultyNameTxt.scrollFactor.set();
		difficultyNameTxt.setFormat("VCR OSD Mono", 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		difficultyNameTxt.updateHitbox();
		difficultyNameTxt.screenCenter(X);
		add(difficultyNameTxt);

		judgementCounterTxt = new FlxText(0, difficultyNameTxt.y + difficultyNameTxt.height + 45, FlxG.width, '', 86);
		judgementCounterTxt.text = 'Score: ' + score + '\nMisses: ' + misses + '\nAccuracy: ' + percent + '%\nRating: ' + name;
		judgementCounterTxt.scrollFactor.set();
		judgementCounterTxt.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		judgementCounterTxt.updateHitbox();
		judgementCounterTxt.screenCenter(X);
		add(judgementCounterTxt);

		pressEnterTxt = new FlxText(400, 650, FlxG.width - 800, "[Press ENTER to continue]", 32);
		pressEnterTxt.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		pressEnterTxt.scrollFactor.set();
		pressEnterTxt.visible = true;
		add(pressEnterTxt);

		iconPlayer1 = new HealthIcon(PlayState.instance.boyfriend.healthIcon, true);
		iconPlayer1.setGraphicSize(Std.int(iconPlayer1.width * 1.2));
		iconPlayer1.updateHitbox();
		add(iconPlayer1);

		iconPlayer2 = new HealthIcon(PlayState.instance.dad.healthIcon, false);
		iconPlayer2.setGraphicSize(Std.int(iconPlayer2.width * 1.2));
		iconPlayer2.updateHitbox();
		add(iconPlayer2);

		resultsText.alpha = 0;
		resultsTxt.alpha = 0;
		songNameText.alpha = 0;
		difficultyNameTxt.alpha = 0;
		judgementCounterTxt.alpha = 0;
		iconPlayer1.alpha = 0;
		iconPlayer2.alpha = 0;
		pressEnterTxt.alpha = 0;

		iconPlayer1.setPosition(FlxG.width - iconPlayer1.width - 10, FlxG.height - iconPlayer1.height - 15);
		iconPlayer2.setPosition(10, iconPlayer1.y);

		FlxTween.tween(background, {alpha: 1}, 0.75, {ease: FlxEase.quadOut});
		FlxTween.tween(resultsText, {alpha: 1, y: 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.2});
		FlxTween.tween(songNameText, {alpha: 1, y: songNameText.y + 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.2});
		FlxTween.tween(difficultyNameTxt, {alpha: 1, y: difficultyNameTxt.y + 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.75});
		FlxTween.tween(resultsTxt, {alpha: 1, y: resultsTxt.y + 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.6});
		FlxTween.tween(judgementCounterTxt, {alpha: 1, y: judgementCounterTxt.y + 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.6});
		FlxTween.tween(iconPlayer1, {alpha: 1, y: FlxG.height - iconPlayer1.height - 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.8});
		FlxTween.tween(iconPlayer2, {alpha: 1, y: FlxG.height - iconPlayer2.height - 5}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.8});
		FlxTween.tween(pressEnterTxt, {alpha: 1}, 0.75, {ease: FlxEase.quadOut, startDelay: 0.1, onComplete: function(_) {
			selectedSomethin = false;
		}});

		super.create();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float) {
		if (pressEnterTxt.visible && !selectedSomethin) {
			pressEnterTxtSine += 100 * elapsed;
			pressEnterTxt.alpha = 1 - Math.sin((Math.PI * pressEnterTxtSine) / 120);
		}

		if (PlayerSettings.player1.controls.ACCEPT && !selectedSomethin) {
			FlxTween.tween(background, {alpha: 0}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(resultsText, {alpha: 0, y: 0}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(songNameText, {alpha: 0, y: songNameText.y - 5}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(difficultyNameTxt, {alpha: 0, y: difficultyNameTxt.y - 5}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(resultsTxt, {alpha: 0, y: resultsTxt.y - 5}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(judgementCounterTxt, {alpha: 0, y: judgementCounterTxt.y - 5}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(iconPlayer1, {alpha: 0, y: iconPlayer1.y + 5}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(iconPlayer2, {alpha: 0, y: iconPlayer2.y + 5}, 0.75, {ease: FlxEase.quadOut});
			FlxTween.tween(pressEnterTxt, {alpha: 0}, 0.75, {ease: FlxEase.quadOut});
			new FlxTimer().start(0.75, function(_) {
				if (PlayState.isStoryMode) {
					LoadingState.loadAndSwitchState(new StoryMenuState());
				} else {
					LoadingState.loadAndSwitchState(new FreeplayState());
				}
			});
			selectedSomethin = true;
		}
		super.update(elapsed);
	}
}
