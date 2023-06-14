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
    public var categoriesList:Array<String> = ['base game'];
    public var categoryNamesList:Array<String> = ['vanilla'];
    public var categoryColors:Array<FlxColor> = [0xFFAB6BBF];

    public static var swagModCategoryFile:Array<Dynamic> = [ // Wants: Category, Category Name, Category Songs (Song Name, Song Character), Song Colors (in RGB), Category Color
	/* Example layout:
        {
            "category": "test 1",
            "name": "Test Category 1",
            "songs": [
                ["Test 1", "bf"],
                ["Test 2", "bf"],
                ["Test 3", "bf"]
            ],
            "songColors": [
                [0, 255, 255],
                [127, 255, 255],
                [255, 255, 255]
            ],
            "color": 0xFF00FFFF
        },
        */
        {
            "category": "test 1",
            "name": "Test Category 1",
            "songs": [
                ["Test 1", "bf"],
                ["Test 2", "bf"],
                ["Test 3", "bf"]
            ],
            "songColors": [
                [0, 255, 255],
                [127, 255, 255],
                [255, 255, 255]
            ],
            "color": 0xFF00FFFF
        },
        {
            "category": "test 2",
            "name": "Test Category 2",
            "songs": [
                ["Test 1 2", "bf"],
                ["Test 2 2", "bf"],
                ["Test 3 2", "bf"]
            ],
            "songColors": [
                [0, 255, 255],
                [127, 255, 255],
                [255, 255, 255]
            ],
            "color": 0xFF99FFFF
        },
        {
            "category": "test 3",
            "name": "Test Category 3",
            "songs": [
                ["Test 1 3", "bf"],
                ["Test 2 3", "bf"],
                ["Test 3 3", "bf"]
            ],
            "songColors": [
                [0, 255, 255],
                [127, 255, 255],
                [255, 255, 255]
            ],
            "color": 0xFFFFFFFF
        }
    ];

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

        // Refresh mod category files then reload them
        refreshModCategories();

        for (category in 0...swagModCategoryFile.length) {
            categoriesList.push(swagModCategoryFile[category].category);
            categoryNamesList.push(swagModCategoryFile[category].name);
            categoryColors.push(swagModCategoryFile[category].color);
        }

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuDesat'));
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
        FlxTween.tween(categorySpr, {alpha: 1, x: categorySpr.x - 60}, 0.725, {ease: FlxEase.smootherStepOut, startDelay: 0.15});
        FlxTween.tween(alphabetText, {alpha: 1, x: alphabetText.x + 60}, 0.725, {ease: FlxEase.smootherStepOut, startDelay: 0.25, onComplete: function(twm:FlxTween) {
            selectedSomethin = false;
        }});
        super.create();
        CustomFadeTransition.nextCamera = camOther;
    }

    var swagCount = 0;
    override public function update(elapsed:Float) {
        bg.scale.set(1.25, 1.25);
        bg.screenCenter(X);

        // Just testing some stuff...
        /* if (FlxG.keys.justPressed.P && swagCount < FreeplayCategoryState.swagModCategoryFile[FreeplayCategoryState.curSelected].songs.length-1) swagCount++;
        if (FlxG.keys.justPressed.O && swagCount > 0) swagCount--;
        if (FlxG.keys.justPressed.A) trace(FreeplayCategoryState.swagModCategoryFile[FreeplayCategoryState.curSelected].songs[swagCount][0]);
        if (FlxG.keys.justPressed.B) trace(FreeplayCategoryState.swagModCategoryFile[FreeplayCategoryState.curSelected].songs[swagCount][1]);
        if (FlxG.keys.justPressed.Z) trace(FreeplayCategoryState.swagModCategoryFile[FreeplayCategoryState.curSelected].songColors[swagCount][0]);
        if (FlxG.keys.justPressed.X) trace(FreeplayCategoryState.swagModCategoryFile[FreeplayCategoryState.curSelected].songColors[swagCount][1]);
        if (FlxG.keys.justPressed.C) trace(FreeplayCategoryState.swagModCategoryFile[FreeplayCategoryState.curSelected].songColors[swagCount][2]);
        if (FlxG.keys.justPressed.K) trace(curSelected - 3); */

        if (!selectedSomethin) {
            if (controls.UI_LEFT_P) 
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeSelection(-1);
            }

            if (controls.UI_RIGHT_P) 
            {
                FlxG.sound.play(Paths.sound('scrollMenu'));
                changeSelection(1);
            }

            if (controls.ACCEPT) {
                    selectCategory();
	    }}

            if (controls.BACK)
            {
                selectedSomethin = true;
                FlxG.sound.play(Paths.sound('cancelMenu'));
                MusicBeatState.switchState(new MainMenuState());
            }
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
        if (curSelected < 0) curSelected = categoriesList.length-1;
        if (curSelected > categoriesList.length-1) curSelected = 0;
    }

    public function selectCategory() {
        lightingBG.alpha = 1;
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
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

    public static function refreshModCategories() {
        swagModCategoryFile = [
            {
                "category": "test 1",
                "name": "Test Category 1",
                "songs": [
                    ["Test 1", "bf"],
                    ["Test 2", "bf"],
                    ["Test 3", "bf"]
                ],
                "songColors": [
                    [0, 255, 255],
                    [127, 255, 255],
                    [255, 255, 255]
                ],
                "color": 0xFF00FFFF
            },
            {
                "category": "test 2",
                "name": "Test Category 2",
                "songs": [
                    ["Test 1 2", "bf"],
                    ["Test 2 2", "bf"],
                    ["Test 3 2", "bf"]
                ],
                "songColors": [
                    [0, 255, 255],
                    [127, 255, 255],
                    [255, 255, 255]
                ],
                "color": 0xFF99FFFF
            },
            {
                "category": "test 3",
                "name": "Test Category 3",
                "songs": [
                    ["Test 1 3", "bf"],
                    ["Test 2 3", "bf"],
                    ["Test 3 3", "bf"]
                ],
                "songColors": [
                    [0, 255, 255],
                    [127, 255, 255],
                    [255, 255, 255]
                ],
                "color": 0xFFFFFFFF
            }
        ];
    }
}
#end
