package;

#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;
import haxe.format.JsonParser;
import flixel.util.FlxColor;

using StringTools;

typedef FreeplayCategoryFile =
{
	//JSON stuff :sob:
	var category:String;
	var name:String;
	var songs:Array<Dynamic>;
	var songColors:Array<Dynamic>;
	var color:FlxColor;
}

class FreeplayCategory {
	public static var categoriesLoaded:Map<String, Category> = new Map<String, Category>();
	public static var categoryList:Array<String> = [];
	public var folder:String = '';

	//JSON stuff :sob:
	public var category:String;
	public var name:String;
	public var songs:Array<Dynamic>;
	public var songColors:Array<Dynamic>;
	public var color:FlxColor;

	public var fileName:String;

	public static function createCategoryFile():FreeplayCategoryFile {
		var categoryFile:FreeplayCategoryFile = {
			category: "test 1",
			name: "Test Category 1",
			songs: [
				["Test 1", "bf"],
				["Test 2", "bf"],
				["Test 3", "bf"]
			],
			songColors: [
				[0, 255, 255],
				[127, 255, 255],
				[255, 255, 255]
			],
			color: 0xFF00FFFF
		};
		return categoryFile;
	}

	public function new(categoryFile:CategoryFile, fileName:String) {
		category = categoryFile.category;
		name = categoryFile.name;
		songs = categoryFile.songs;
		songColors = categoryFile.songColors;
		color = categoryFile.color;

		this.fileName = fileName;
	}

	public function loadFromJson(rawJson:FreeplayCategoryFile) {
		if (rawJson != null) {
			try {
				if (!categoriesLoaded.exists(rawJson.category)) {
					categoriesLoaded.set(rawJson.category, rawJson);
					categoryList.push(rawJson.category);
				}
			} catch (e:Any) {
				trace('Failed to load Freeplay Category: "${rawJson.category}"\n- Exception thrown!');
			}
		}
	}
}
