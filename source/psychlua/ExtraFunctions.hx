package psychlua;

import sys.FileSystem;
import sys.io.File;
import js.html.File;
import openfl.display.BitmapData;
#if LUA_ALLOWED
import llua.Lua;
import llua.LuaL;
import llua.State;
import llua.Convert;
#end

import animateatlas.AtlasFrameMaker;
import flixel.FlxG;
import flixel.addons.effects.FlxTrail;
import flixel.input.keyboard.FlxKey;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
#if (flixel < "5.3.0")
import flixel.system.FlxSound;
#else
import flixel.sound.FlxSound;
#end
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets;
import flixel.math.FlxMath;
import flixel.util.FlxSave;
import flixel.addons.transition.FlxTransitionableState;
import flixel.system.FlxAssets.FlxShader;
import haxe.Json;

using StringTools;
//
// Things to trivialize some dumb stuff like splitting strings on older Lua
//

class ExtraFunctions
{
	public static function implement(funk:FunkinLua)
	{
		var lua:State = funk.lua;
		
		Lua_helper.add_callback(lua, "loadJsonOptions", function(inclMainFol:Bool = true, ?modNames:Array<String> = null) {
			#if MODS_ALLOWED
			if (modNames == null) modNames = [];
			if (modNames.length < 1) modNames.push(Paths.currentModDirectory);
			for(mod in Paths.getModDirectories(inclMainFol)) if(modNames.contains(mod) || (inclMainFol && mod == '')) {
				var path:String = haxe.io.Path.join([Paths.mods(), mod, 'options']);
				if(FileSystem.exists(path)) for(file in FileSystem.readDirectory(path)) {
					var folder:String = path + '/' + file;
					if(FileSystem.isDirectory(folder)) for(rawFile in FileSystem.readDirectory(folder)) if(rawFile.endsWith('.json')) {
						var rawJson = File.getContent(folder + '/' + rawFile);
						if (rawJson != null && rawJson.length > 0) {
							var json = Json.parse(rawJson);
							if (!ClientPrefs.modsOptsSaves.exists(mod)) ClientPrefs.modsOptsSaves.set(mod, []);
							if (!ClientPrefs.modsOptsSaves[mod].exists(json.variable)) {
								if (!Reflect.hasField(json, 'defaultValue')) {
									var type:String = 'bool';
									if (Reflect.hasField(json, 'type')) type = json.type;
									ClientPrefs.modsOptsSaves[mod][json.variable] =
										CoolUtil.getOptionDefVal(type, Reflect.field(json, 'options'));
								} else {
									ClientPrefs.modsOptsSaves[mod][json.variable] = json.defaultValue;
								}
							}
						}
					}
				}
			}
			return ClientPrefs.modsOptsSaves.toString();
			#else
			funk.luaTrace('loadJsonOptions: Platform unsupported for Json Options!', false, false, FlxColor.RED);
			return false;
			#end
		});
		Lua_helper.add_callback(lua, "getOptionSave", function(variable:String, isJson:Bool = false, ?modName:String = null) {
			if (!isJson) {
				return Reflect.getProperty(ClientPrefs, variable);
			} else if (isJson) {
				#if MODS_ALLOWED
				if (modName == null) modName = Paths.currentModDirectory;
				if (ClientPrefs.modsOptsSaves.exists(modName) && ClientPrefs.modsOptsSaves[modName].exists(variable)) {
					return ClientPrefs.modsOptsSaves[modName][variable];
				}
				#else
				funk.luaTrace('getOptionSave: Platform unsupported for Json Options!', false, false, FlxColor.RED);
				#end
			}
			return null;
		});
		Lua_helper.add_callback(lua, "setOptionSave", function(variable:String, value:Dynamic, isJson:Bool = false, ?modName:String = null) {
			if (!isJson) {
				Reflect.setProperty(ClientPrefs, variable, value);
				return Reflect.getProperty(ClientPrefs, variable) != null ? true : false;
			} else if (isJson) {
				#if MODS_ALLOWED
				if (modName == null) modName = Paths.currentModDirectory;
				if (ClientPrefs.modsOptsSaves.exists(modName) && ClientPrefs.modsOptsSaves[modName].exists(variable)) {
					ClientPrefs.modsOptsSaves[modName][variable] = value;
					return true;
				}
				#else
				funk.luaTrace('setOptionSave: Platform unsupported for Json Options!', false, false, FlxColor.RED);
				#end
			}
			return false;
		});
		Lua_helper.add_callback(lua, "saveSettings", function() {
			ClientPrefs.saveSettings();
			return true;
		});

		// File management
		Lua_helper.add_callback(lua, "checkFileExists", function(filename:String, ?absolute:Bool = false) {
			#if MODS_ALLOWED
			if(absolute)
			{
				return FileSystem.exists(filename);
			}

			var path:String = Paths.modFolders(filename);
			if(FileSystem.exists(path))
			{
				return true;
			}
			return FileSystem.exists(Paths.getPath('assets/$filename', TEXT));
			#else
			if(absolute)
			{
				return Assets.exists(filename);
			}
			return Assets.exists(Paths.getPath('assets/$filename', TEXT));
			#end
		});
		Lua_helper.add_callback(lua, "saveFile", function(path:String, content:String, ?absolute:Bool = false)
		{
			try {
				if(!absolute)
					File.saveContent(Paths.mods(path), content);
				else
					File.saveContent(path, content);

				return true;
			} catch (e:Dynamic) {
				funk.luaTrace("saveFile: Error trying to save " + path + ": " + e, false, false, FlxColor.RED);
			}
			return false;
		});
		Lua_helper.add_callback(lua, "deleteFile", function(path:String, ?ignoreModFolders:Bool = false)
		{
			try {
				#if MODS_ALLOWED
				if(!ignoreModFolders)
				{
					var lePath:String = Paths.modFolders(path);
					if(FileSystem.exists(lePath))
					{
						FileSystem.deleteFile(lePath);
						return true;
					}
				}
				#end

				var lePath:String = Paths.getPath(path, TEXT);
				if(Assets.exists(lePath))
				{
					FileSystem.deleteFile(lePath);
					return true;
				}
			} catch (e:Dynamic) {
				funk.luaTrace("deleteFile: Error trying to delete " + path + ": " + e, false, false, FlxColor.RED);
			}
			return false;
		});
		Lua_helper.add_callback(lua, "getTextFromFile", function(path:String, ?ignoreModFolders:Bool = false) {
			return Paths.getTextFromFile(path, ignoreModFolders);
		});
		Lua_helper.add_callback(lua, "directoryFileList", function(folder:String) {
			var list:Array<String> = [];
			#if sys
			if(FileSystem.exists(folder)) {
				for (folder in FileSystem.readDirectory(folder)) {
					if (!list.contains(folder)) {
						list.push(folder);
					}
				}
			}
			#end
			return list;
		});

		// String tools
		Lua_helper.add_callback(lua, "stringStartsWith", function(str:String, start:String) {
			return str.startsWith(start);
		});
		Lua_helper.add_callback(lua, "stringEndsWith", function(str:String, end:String) {
			return str.endsWith(end);
		});
		Lua_helper.add_callback(lua, "stringSplit", function(str:String, split:String) {
			return str.split(split);
		});
		Lua_helper.add_callback(lua, "stringTrim", function(str:String) {
			return str.trim();
		});

		// Randomization
		Lua_helper.add_callback(lua, "getRandomInt", function(min:Int, max:Int = FlxMath.MAX_VALUE_INT, exclude:String = '') {
			var excludeArray:Array<String> = exclude.split(',');
			var toExclude:Array<Int> = [];
			for (i in 0...excludeArray.length)
			{
				toExclude.push(Std.parseInt(excludeArray[i].trim()));
			}
			return FlxG.random.int(min, max, toExclude);
		});
		Lua_helper.add_callback(lua, "getRandomFloat", function(min:Float, max:Float = 1, exclude:String = '') {
			var excludeArray:Array<String> = exclude.split(',');
			var toExclude:Array<Float> = [];
			for (i in 0...excludeArray.length)
			{
				toExclude.push(Std.parseFloat(excludeArray[i].trim()));
			}
			return FlxG.random.float(min, max, toExclude);
		});
		Lua_helper.add_callback(lua, "getRandomBool", function(chance:Float = 50) {
			return FlxG.random.bool(chance);
		});
	}
}