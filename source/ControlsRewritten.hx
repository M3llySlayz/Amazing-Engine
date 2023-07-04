/* This was a rewritten version of Controls
import flixel.FlxG;
class ControlsRewritten {
    // Pressed
    public var UI_LEFT:Bool;
    public var UI_DOWN:Bool;
    public var UI_UP:Bool;
    public var UI_RIGHT:Bool;
    public var DEV_BIND:Bool;
    public var DEBUG_PATTERN_1:Bool;
    public var DEBUG_PATTERN_2:Bool;

    // Just Pressed
    public var UI_LEFT_P:Bool;
    public var UI_DOWN_P:Bool;
    public var UI_UP_P:Bool;
    public var UI_RIGHT_P:Bool;
    public var DEV_BIND_P:Bool;
    public var DEBUG_PATTERN_1_P:Bool;
    public var DEBUG_PATTERN_2_P:Bool;

    // Released
    public var UI_LEFT_R:Bool;
    public var UI_DOWN_R:Bool;
    public var UI_UP_R:Bool;
    public var UI_RIGHT_R:Bool;
    public var DEBUG_PATTERN_1_R:Bool;
    public var DEBUG_PATTERN_2_R:Bool;
    public var DEV_BIND_R:Bool;

    // Gameplay
    public var ACCEPT:Bool;
    public var BACK:Bool;
    public var PAUSE:Bool;
    public var RESET:Bool;

    public function update(elapsed:Float)
    {
        try {
        // Pressed
        UI_LEFT = checkKeyPressed('ui_left');
        UI_DOWN = checkKeyPressed('ui_down');
        UI_UP = checkKeyPressed('ui_up');
        UI_RIGHT = checkKeyPressed('ui_right');
        DEBUG_PATTERN_1 = checkKeyPressed('debug_1');
        DEBUG_PATTERN_2 = checkKeyPressed('debug_2');
        DEV_BIND = checkKeyPressed('dev_bind');

        // Just Pressed
        UI_LEFT_P = checkKeyJustPressed('ui_left');
        UI_DOWN_P = checkKeyJustPressed('ui_down');
        UI_UP_P = checkKeyJustPressed('ui_up');
        UI_RIGHT_P = checkKeyJustPressed('ui_right');
        DEBUG_PATTERN_1_P = checkKeyJustPressed('debug_1');
        DEBUG_PATTERN_2_P = checkKeyJustPressed('debug_2');
        DEV_BIND_P = checkKeyJustPressed('dev_bind');

        // Released
        UI_LEFT_R = checkKeyReleased('ui_left');
        UI_DOWN_R = checkKeyReleased('ui_down');
        UI_UP_R = checkKeyReleased('ui_up');
        UI_RIGHT_R = checkKeyReleased('ui_right');
        DEBUG_PATTERN_1_R = checkKeyReleased('debug_1');
        DEBUG_PATTERN_2_R = checkKeyReleased('debug_2');
        DEV_BIND_R = checkKeyReleased('dev_bind');

        // Gameplay
        ACCEPT = checkKeyJustPressed('accept');
        BACK = checkKeyJustPressed('back');
        PAUSE = checkKeyJustPressed('pause');
        RESET = checkKeyJustPressed('reset');
        } catch (e:Any) {}
    }

    public function checkKeyPressed(key:String):Bool
    {
        return FlxG.keys.anyPressed(ClientPrefs.copyKey(ClientPrefs.keyBinds.get(key)));
    }

    public function checkKeyJustPressed(key:String):Bool
    {
        return FlxG.keys.anyJustPressed(ClientPrefs.copyKey(ClientPrefs.keyBinds.get(key)));
    }

    public function checkKeyReleased(key:String):Bool
    {
        return FlxG.keys.anyJustReleased(ClientPrefs.copyKey(ClientPrefs.keyBinds.get(key)));
    }
}
*/