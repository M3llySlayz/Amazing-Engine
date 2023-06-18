#if MULTI_MODDABLE
package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import FreeplayCategory;

using StringTools;

class FreeplayCategoryState extends MusicBeatState {
	public var categoriesList:Array<String> = ['base game'];
	public var categoryNamesList:Array<String> = ['vanilla'];
	public var categoryColors:Array<FlxColor> = [0xFFAB6BBF];

	//public var categories:Array<FreeplayCategory> = [];

	public static var categoryNames:Array<String> = []; // Freeplay Category Title in Freeplay
	public static var curSelected:Int = 0;

	public var bg:FlxSprite;
	public var categorySpr:FlxSprite;
	public var alphabetText:Alphabet;

	public var camOther:FlxCamera;

	var blackBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
	var lightingBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF777777);

	var selectedSomethin:Bool = true;
	override public function create() {
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;
		FlxG.cameras.add(camOther, false);

		FreeplayCategory.reloadCategoryFiles();
		for (categoriesLoaded in 0...FreeplayCategory.categoryList.length) {
			var categories = FreeplayCategory.categoriesLoaded.get(FreeplayCategory.categoryList[categoriesLoaded]);
			categoriesList.push(categories.category);
			categoryNamesList.push(categories.name);
			categoryColors.push(FlxColor.fromRGB(categories.color[0], categories.color[1], categories.color[2]));
		}

		categoryNames = categoryNamesList;

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = categoryColors[curSelected];
		add(bg);

		categorySpr = new FlxSprite().loadGraphic(Paths.image('categories/' + categoriesList[curSelected]));
		categorySpr.screenCenter();
		categorySpr.alpha = 0;
		categorySpr.x += 60;
		add(categorySpr);

		alphabetText = new Alphabet(0, FlxG.height - 200, categoryNamesList[curSelected], true);
		alphabetText.x = categorySpr.width / 3;
		alphabetText.alpha = 0;
		alphabetText.x -= 60;
		add(alphabetText);

		//blackBG.cameras = [camOther];
		//add(blackBG);

		lightingBG.cameras = [camOther];
		lightingBG.blend = ADD;
		lightingBG.alpha = 0;
		add(lightingBG);

		//FlxTween.tween(blackBG, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});
		FlxTween.tween(categorySpr, {alpha: 1, x: categorySpr.x - 60}, 0.75, {ease: FlxEase.quintOut, startDelay: 0.15});
		FlxTween.tween(alphabetText, {alpha: 1, x: alphabetText.x + 60}, 0.75, {ease: FlxEase.quintOut, startDelay: 0.25, onComplete: function(twm:FlxTween) {
			selectedSomethin = false;
		}});
		super.create();
		CustomFadeTransition.nextCamera = camOther;
	}

	var swagCount = 0;
	override public function update(elapsed:Float) {
		bg.scale.set(1.25, 1.25);
		bg.screenCenter(X);

		if (!selectedSomethin) {
			if (FlxG.mouse.wheel != 0)
				changeSelection(-FlxG.mouse.wheel);

			if (controls.UI_LEFT_P) 
			{
				changeSelection(-1);
			}

			if (controls.UI_RIGHT_P) 
			{
				changeSelection(1);
			}

			if (controls.ACCEPT || FlxG.mouse.justPressed) {
				selectCategory();
			}
		}

		if (controls.BACK || FlxG.mouse.justPressedRight)
		{
			selectedSomethin = true;
			SoundEffects.playSFX('cancel', false);
			MusicBeatState.switchState(new MainMenuState());
		}

		if (curSelected < 0) curSelected = categoriesList.length-1;
		if (curSelected > categoriesList.length-1) curSelected = 0;

		if (!selectedSomethin) {
			categorySpr.loadGraphic(Paths.image('categories/' + categoriesList[curSelected]));
			alphabetText.text = categoryNamesList[curSelected];
			alphabetText.x = categorySpr.width / 3;
			bg.color = categoryColors[curSelected];
			categorySpr.screenCenter();
		}
		else categorySpr.screenCenter(Y);
	}

	public function changeSelection(change:Int = 1) {
		curSelected += change;
		SoundEffects.playSFX('scroll', false);
		if (curSelected < 0) curSelected = categoriesList.length-1;
		if (curSelected > categoriesList.length-1) curSelected = 0;
	}

	public function selectCategory() {
		var categories = FreeplayCategory.categoriesLoaded.get(categoriesList[curSelected]);
		if (curSelected != 0) { // Null check
			if (!categories.startLocked) {
				lightingBG.alpha = 1;
				selectedSomethin = true;
				SoundEffects.playSFX('confirm', false);
				FlxFlicker.flicker(categorySpr, 1.5, 0.05, false);
				FlxTween.tween(lightingBG, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});
				FlxTween.tween(alphabetText, {alpha: 0, x: alphabetText.x - 24}, 1, {ease: FlxEase.smoothStepOut});
				FlxTween.tween(categorySpr, {alpha: 0}, 0.75, {ease: FlxEase.smoothStepOut, startDelay: 0.75});
				new FlxTimer().start(1.5, function(tmr:FlxTimer) {
					FreeplayState.curCategory = categoriesList[curSelected];
					if (FreeplayState.curCategory == 'base game') FreeplayState.curCategory = '';
					LoadingState.loadAndSwitchState(new FreeplayState());
				});
			} else SoundEffects.playSFX('cancel', false);
		} else {
			lightingBG.alpha = 1;
			selectedSomethin = true;
			SoundEffects.playSFX('confirm', false);
			FlxFlicker.flicker(categorySpr, 1.5, 0.05, false);
			FlxTween.tween(lightingBG, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});
			FlxTween.tween(alphabetText, {alpha: 0, x: alphabetText.x - 24}, 1, {ease: FlxEase.smoothStepOut});
			FlxTween.tween(categorySpr, {alpha: 0}, 0.75, {ease: FlxEase.smoothStepOut, startDelay: 0.75});
			new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				FreeplayState.curCategory = categoriesList[curSelected];
				if (FreeplayState.curCategory == 'base game') FreeplayState.curCategory = '';
				LoadingState.loadAndSwitchState(new FreeplayState());
			});
		}
	}
}
#end
