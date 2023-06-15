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
	public static var categoriesLoaded:Map<String, FreeplayCategory> = new Map<String, FreeplayCategory>();
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

	public function new(categoryFile:FreeplayCategoryFile, fileName:String) {
		category = categoryFile.category;
		name = categoryFile.name;
		songs = categoryFile.songs;
		songColors = categoryFile.songColors;
		color = categoryFile.color;

		this.fileName = fileName;
	}

	public static function reloadCategoryFiles()
	{
		categoryList = [];
		categoriesLoaded.clear();
		#if MODS_ALLOWED
		var disabledMods:Array<String> = [];
		var modsListPath:String = 'modsList.txt';
		var directories:Array<String> = [Paths.mods(), Paths.getPreloadPath()];
		var originalLength:Int = directories.length;
		if(FileSystem.exists(modsListPath))
		{
			var stuff:Array<String> = CoolUtil.coolTextFile(modsListPath);
			for (i in 0...stuff.length)
			{
				var splitName:Array<String> = stuff[i].trim().split('|');
				if(splitName[1] == '0') // Disable mod
				{
					disabledMods.push(splitName[0]);
				}
				else // Sort mod loading order based on modsList.txt file
				{
					var path = haxe.io.Path.join([Paths.mods(), splitName[0]]);
					//trace('trying to push: ' + splitName[0]);
					if (sys.FileSystem.isDirectory(path) && !Paths.ignoreModFolders.contains(splitName[0]) && !disabledMods.contains(splitName[0]) && !directories.contains(path + '/'))
					{
						directories.push(path + '/');
						//trace('pushed Directory: ' + splitName[0]);
					}
				}
			}
		}
	
		var modsDirectories:Array<String> = Paths.getModDirectories();
		for (folder in modsDirectories)
		{
			var pathThing:String = haxe.io.Path.join([Paths.mods(), folder]) + '/';
			if (!disabledMods.contains(folder) && !directories.contains(pathThing))
			{
				directories.push(pathThing);
				//trace('pushed Directory: ' + folder);
			}
		}
		#else
		var directories:Array<String> = [Paths.getPreloadPath()];
		var originalLength:Int = directories.length;
		#end
	
		var sexList:Array<String> = CoolUtil.coolTextFile(Paths.getPreloadPath('data/modCategoriesList.txt'));
		for (i in 0...sexList.length) {
			for (j in 0...directories.length) {
				var fileToCheck:String = directories[j] + 'data/modCategoriesList.json';
				if(!categoriesLoaded.exists(sexList[i])) {
					var category:FreeplayCategoryFile = getCategoryFile(fileToCheck);
					if(category != null) {
						var categoryFile:FreeplayCategory = new FreeplayCategory(category, sexList[i]);
	
						#if MODS_ALLOWED
						if(j >= originalLength) {
							categoryFile.folder = directories[j].substring(Paths.mods().length, directories[j].length-1);
						}
						#end
	
						if(categoryFile != null) {
							categoriesLoaded.set(sexList[i], categoryFile);
							categoryList.push(sexList[i]);
						}
					}
				}
			}
		}
	
		#if MODS_ALLOWED
		for (i in 0...directories.length) {
			var directory:String = directories[i] + 'data/';
			if(FileSystem.exists(directory)) {
				var listOfCategories:Array<String> = CoolUtil.coolTextFile(directory + 'categoryList.txt');
				for (daCategory in listOfCategories)
				{
					var path:String = directory + 'modsCategoriesList.json';
					if(sys.FileSystem.exists(path))
					{
						addCategory(daCategory, path, directories[i], i, originalLength);
					}
				}
	
				for (file in FileSystem.readDirectory(directory))
				{
					var path = haxe.io.Path.join([directory, file]);
					if (!sys.FileSystem.isDirectory(path) && file.endsWith('.json'))
					{
						addCategory(file.substr(0, file.length - 5), path, directories[i], i, originalLength);
					}
				}
			}
		}
		#end
	}

	private static function addCategory(categoryToCheck:String, path:String, directory:String, i:Int, originalLength:Int)
	{
		if(!categoriesLoaded.exists(categoryToCheck))
		{
			var category:FreeplayCategoryFile = getCategoryFile(path);
			if(category != null)
			{
				var categoryFile:FreeplayCategory = new FreeplayCategory(category, categoryToCheck);
				if(i >= originalLength)
				{
					#if MODS_ALLOWED
						categoryFile.folder = directory.substring(Paths.mods().length, directory.length-1);
					#end
				}
				categoriesLoaded.set(categoryToCheck, categoryFile);
				categoryList.push(categoryToCheck);
			}
		}
	}
		
	private static function getCategoryFile(path:String):FreeplayCategoryFile {
		var rawJson:String = null;

		#if MODS_ALLOWED
		if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(OpenFlAssets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end
		
		if(rawJson != null && rawJson.length > 0) {
			return cast Json.parse(rawJson);
		}
		return null;
	}
}
