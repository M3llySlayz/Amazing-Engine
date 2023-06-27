package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

#if cpp
import e.Memory;
#end

import flixel.FlxG;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class FPS extends TextField
{
	public function new(x:Float = 6, y:Float = 6, color:Int = 0xFFFFFFFF)
	{
		super();

		this.x = x;
		this.y = y;

		drawFPS();
		drawMemory();

		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("Antonio Bold", 15, color);
		defaultTextFormat.bold = true;
		autoSize = LEFT;
		multiline = true;
		text = "FPS: 0\n - Time: 0 ms";

		addEventListener(Event.ENTER_FRAME, (e:Event) -> enterFrame(Sys.time()));
	}

	public function enterFrame(deltaTime:Float) {
		updateFPS(deltaTime);
		updateMemory();
		text = FPSText + MemoryText;
	}

	// Frames Counter

	var FPS:Float;
	var FPSText:String;
	var currentFps:Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Date>;

	function drawFPS() {
		cacheCount = 0;
		currentTime = 0;
		times = [];
	}

	var intervalTime:Float;
	var ms:Float;
	var maxMs:Float = 16;

	// I wrote this from scratch
	function updateFPS(deltaTime:Float) {
		currentTime += deltaTime;
		times.push(Date.now());
		for (i in 0...times.length) {
			if (times[i] != null && times[i].getTime() + 1000 < Date.now().getTime()) {
				times.remove(times[i]);
			}
		}
		currentFps = times.length;

		intervalTime = 1 / currentFps;
		ms = Std.int(intervalTime * 1000);
		if (ms < maxMs) maxMs = ms;

		FPSText = 'FPS: ' + HelperFunctions.truncateFloat(currentFps, 2) + /* This text appears if your framerate is higher than the refresh rate */ ((ClientPrefs.framerate > times.length + 9 && TitleState.skippedIntro) ? ' (Slowdown mode)' : '') + '\n - Time: $ms ms (Max: $maxMs ms)';
		updateFPSTextColor();
	}

	// Smooth fps color change
	function updateFPSTextColor() {
		// Testing...
		//trace(Math.pow(10, 9));
		// Math.pow(10, 9) * 4
		if (TotalMemory >= 12000000000 || currentFps <= times.length / 2) {
			textColor = 0xFFFF0000;
		} else {
			textColor = 0xFFFFFFFF;
		}
	}

	// Memory Counter

	var PeakMemory:Float;
	var CurrentMemory:Float;
	var TotalMemory:Float;
	var GarbageMemory:Float;

	function drawMemory() {
		PeakMemory = 0;
		CurrentMemory = 0;
		TotalMemory = 0;
		GarbageMemory = 0;
	}

	var MemoryText:String;

	var MemoryString:String;
	var CurrentMemoryString:String;
	var PeakMemoryString:String;
	var GarbageMemoryString:String;

	function updateMemory() {
		CurrentMemory = Memory.getCurrentUsage();
		PeakMemory = Memory.getPeakUsage();
		TotalMemory = CurrentMemory + PeakMemory;
		GarbageMemory = cpp.vm.Gc.memUsage();

		//checkMemory();
		MemoryText = '\nMemory: ${CoolUtil.formatBytes(TotalMemory / 2)}\n- Current: ${CoolUtil.formatBytes(CurrentMemory / 2)}, Peak: ${CoolUtil.formatBytes(PeakMemory / 2)}\nGarbage Memory: ${CoolUtil.formatBytes(GarbageMemory)} Freed';
	}

	/*
	function checkMemory() {
		'${CoolUtil.formatBytes(CurrentMemory)} / ${CoolUtil.formatBytes(Memory.getPeakUsage())}';
	}

	function convertToMemoryUnits(baseFloat:Float, whatToConvert:Float, units:String):String {
		return HelperFunctions.truncateFloat(baseFloat / whatToConvert, 2) + ' $units';
	}
	*/
}
