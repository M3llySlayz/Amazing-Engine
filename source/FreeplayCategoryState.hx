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

using StringTools;

class FreeplayCategoryState extends MusicBeatState {
    public var categoriesList:Array<String> = ['base game', 'amongus']; // Change this line here. Don't forget about the hardcoding in FreeplayState aswell.
    public var categoryColors:Array<Dynamic> = [[171, 107, 191], [255, 255, 255]];
  
    public static var curSelected:Int = 0;

    var loadedWeeks:Array<WeekData> = [];

    public var bg:FlxSprite;
    public var categorySpr:FlxSprite;
    public var alphabetText:Alphabet;

    public var camOther:FlxCamera;

    var blackBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    var lightingBG:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF777777);

    var selectedSomethin:Bool = true;
    override public function create() {
        WeekData.reloadWeekFiles(true);

        camOther = new FlxCamera();
        camOther.bgColor.alpha = 0;
		FlxG.cameras.add(camOther, false);

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
        bg.color = FlxColor.fromRGB(categoryColors[curSelected][0], categoryColors[curSelected][1], categoryColors[curSelected][2]);
        add(bg);

        categorySpr = new FlxSprite().loadGraphic(Paths.image('categories/' + categoriesList[curSelected]));
        categorySpr.screenCenter();
        categorySpr.alpha = 0;
        categorySpr.x += 60;
        add(categorySpr);

        alphabetText = new Alphabet(0, FlxG.height - 200, categoriesList[curSelected], true);
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

        for (i in 0...WeekData.weeksList.length)
        {
            var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
            var isLocked:Bool = StoryMenuState.weekIsLocked(WeekData.weeksList[i]);
            if(!isLocked || !weekFile.hiddenUntilUnlocked)
            {
                loadedWeeks.push(weekFile);
            }
        }
        
        for (i in 0...loadedWeeks.length) {
            categoriesList.push(loadedWeeks[i].category);
            if (loadedWeeks[i].categoryColors[curSelected] != null)
                for (j in 0...2) categoryColors.push(loadedWeeks[i].categoryColors[curSelected][j]);
            else
                categoryColors.push([255, 255, 255]);
        }

        //FlxTween.tween(blackBG, {alpha: 0}, 0.5, {ease: FlxEase.smootherStepOut});
        FlxTween.tween(categorySpr, {alpha: 1, x: categorySpr.x - 60}, 0.5, {ease: FlxEase.smoothStepOut, startDelay: 0.15});
        FlxTween.tween(alphabetText, {alpha: 1, x: alphabetText.x + 60}, 0.5, {ease: FlxEase.smoothStepOut, startDelay: 0.15, onComplete: function(twm:FlxTween) {
            selectedSomethin = false;
        }});
        super.create();
        CustomFadeTransition.nextCamera = camOther;
    }

    override public function update(elapsed:Float) {
        bg.scale.set(1.25, 1.25);
        bg.screenCenter(X);
        if (!selectedSomethin) {

            if (FlxG.mouse.wheel != 0)
            {
                SoundEffects.playSFX('scroll', false);
                changeSelection(-FlxG.mouse.wheel);
            }

            if (controls.UI_LEFT_P) 
            {
                SoundEffects.playSFX('scroll', false);
                changeSelection(-1);
            }

            if (controls.UI_RIGHT_P) 
            {
                SoundEffects.playSFX('scroll', false);
                changeSelection(1);
            }

            if (controls.ACCEPT || FlxG.mouse.justPressed)
                if (curSelected != 2)
                    selectCategory();
                else
                    SoundEffects.playSFX('cancel', false);

            if (controls.BACK || FlxG.mouse.justPressedRight)
            {
                selectedSomethin = true;
                SoundEffects.playSFX('cancel', false);
                if (ClientPrefs.luaMenu){
                    PlayState.SONG = Song.loadFromJson('ae-menu', 'ae-menu');
                    LoadingState.loadAndSwitchState(new PlayState());
                } else {
                    MusicBeatState.switchState(new MainMenuState());
                }
            }
        }

        if (curSelected < 0) curSelected = categoriesList.length-1;
        if (curSelected > categoriesList.length-1) curSelected = 0;

        if (!selectedSomethin) {
            categorySpr.loadGraphic(Paths.image('categories/' + categoriesList[curSelected]));
            alphabetText.text = categoriesList[curSelected];
            alphabetText.x = categorySpr.width / 3;
            bg.color = FlxColor.fromRGB(categoryColors[curSelected][0], categoryColors[curSelected][1], categoryColors[curSelected][2]);
            categorySpr.screenCenter();
        }
        else categorySpr.screenCenter(Y);
    }

    public function changeSelection(change:Int = 1) {
        curSelected += change;
        if (curSelected < 0) curSelected = categoriesList.length-1;
        if (curSelected > categoriesList.length-1) curSelected = 0;
    }

    public function selectCategory() {
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
            if (FreeplayState.curCategory == 'amongus') FreeplayState.curCategory = 'amongus';
            MusicBeatState.switchState(new FreeplayState());
        });
    }
}
#end
