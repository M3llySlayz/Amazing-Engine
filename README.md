![Amazing Engine Logo](https://user-images.githubusercontent.com/78555659/235371908-8510fa1f-aa10-4668-b62a-4d1632ded756.gif)

# Friday Night Funkin' - Amazing Engine
Engine originally used on [VS Astoria](https://gamebanana.com/mods/435389), intended to make Psych Engine easier to modify without source code.

## Installation:
You must have [the most up-to-date version of Haxe](https://haxe.org/download/), seriously, stop using 4.1.5, it misses some stuff.

Follow a Friday Night Funkin' source code compilation tutorial, after this run `haxelib install hmm` and `haxelib run hmm install` and you should be good.


If you don't want your mod to be able to run .lua scripts, delete the "LUA_ALLOWED" line on Project.xml


If you get an error about StatePointer when using Lua, run `haxelib remove linc_luajit` into Command Prompt/PowerShell, then re-install linc_luajit.

If you want video support on your mod, simply do `haxelib install hxCodec 2.5.1` and `haxelib set hxCodec 2.5.1` on a Command prompt/PowerShell

Otherwise, you can delete the "VIDEOS_ALLOWED" Line on Project.xml

## Credits:
* M3llySlayz - Programmer, Artist, Composer
* Irshaad - Programmer
* SomeGuyWhoLikesCoding - Programmer
* JB444m - Artist
* BoyBot69 - Composer

## Contributors
* NexIsDumb - Custom Options code

## Psych Creators 
* Shadow Mario - Programmer
* RiverOaken - Artist
* Yoshubs - Assistant Programmer

### Special Thanks
* bbpanzu - Ex-Programmer
* shubs - New Input System
* SqirraRNG - Crash Handler and Base code for Chart Editor's Waveform
* KadeDev - Fixed some cool stuff on Chart Editor and other PRs
* iFlicky - Composer of Psync and Tea Time, also made the Dialogue Sounds
* PolybiusProxy - .MP4 Video Loader Library (hxCodec)
* Keoiki - Note Splash Animations
* Smokey - Sprite Atlas Support
* Nebula the Zorua - LUA JIT Fork and some Lua reworks
_____________________________________

# Features

## Mod Support
* Probably one of the main points of this engine, you can code in .lua files outside of the source code, making your own weeks without even messing with the source!
* Comes with a Mod Organizing/Disabling Menu.

## Multi Key
* Goes up to 18k as of now, credits to tposejank (top left of the site shows his repository)
