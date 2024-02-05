@echo off
echo You must have GIT installed! [Press any key to Continue]
pause >nul
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib run flixel-tools setup
haxelib install flixel
haxelib install flixel-tools
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib install hxCodec
echo IF YOU DO NOT HAVE GIT INSTALLED, PLEASE INSTALL NOW!
pause >nul
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
haxelib git hxCodec https://github.com/polybiusproxy/hxCodec.git

curl -# -O https://download.visualstudio.microsoft.com/download/pr/3105fcfe-e771-41d6-9a1c-fc971e7d03a7/8eb13958dc429a6e6f7e0d6704d43a55f18d02a253608351b6bf6723ffdaf24e/vs_Community.exe
vs_Community.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 -p
echo Please wait until the popup is gone and it is fully installed before continuing
pause >nul
del vs_Community.exe
haxelib set flixel-tools 1.5.1
haxelib set flixel-ui 2.5.0
haxelib set flixel-addons 3.0.2
haxelib set flixel 5.2.2
haxelib set SScript 4.0.1
haxelib set tjson 1.4.0
haxelib set lime 8.0.1
haxelib set openfl 9.2.1
lime test windows
