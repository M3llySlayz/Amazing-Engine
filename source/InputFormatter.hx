import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

using StringTools;

class InputFormatter {
	public static function getKeyName(key:FlxKey):String {
		switch (key) {
			case BACKSPACE:
				return "BkSp";
			case CONTROL:
				return "Ctrl";
			case ALT:
				return "Alt";
			case CAPSLOCK:
				return "Caps";
			case PAGEUP:
				return "PgUp";
			case PAGEDOWN:
				return "PgDown";
			case ZERO:
				return "0";
			case ONE:
				return "1";
			case TWO:
				return "2";
			case THREE:
				return "3";
			case FOUR:
				return "4";
			case FIVE:
				return "5";
			case SIX:
				return "6";
			case SEVEN:
				return "7";
			case EIGHT:
				return "8";
			case NINE:
				return "9";
			case NUMPADZERO:
				return "NP0";
			case NUMPADONE:
				return "NP1";
			case NUMPADTWO:
				return "NP2";
			case NUMPADTHREE:
				return "NP3";
			case NUMPADFOUR:
				return "NP4";
			case NUMPADFIVE:
				return "NP5";
			case NUMPADSIX:
				return "NP6";
			case NUMPADSEVEN:
				return "NP7";
			case NUMPADEIGHT:
				return "NP8";
			case NUMPADNINE:
				return "NP9";
			case NUMPADMULTIPLY:
				return "NP*";
			case NUMPADPLUS:
				return "NP+";
			case NUMPADMINUS:
				return "NP-";
			case NUMPADPERIOD:
				return "NP.";
			case SEMICOLON:
				return ";";
			case COMMA:
				return ",";
			case PERIOD:
				return ".";
			case SLASH:
				return "Sl";
			case GRAVEACCENT:
				return "`";
			case LBRACKET:
				return "[";
			case BACKSLASH:
				return "BSl";
			case RBRACKET:
				return "]";
			case QUOTE:
				return "'";
			case PRINTSCREEN:
				return "PtSc";
			case SPACE:
				return "Sp";
			case NONE:
				return '---';
			default:
				var label:String = '' + key;
				if(label.toLowerCase() == 'null') return '---';
				return '' + label.charAt(0).toUpperCase() + label.substr(1).toLowerCase();
		}
	}
}