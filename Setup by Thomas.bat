@echo off
title Psych Setup [0.6.3]
color d
echo ------------------------------------------
echo            Welcome to the Friendly
echo           FNF Psych Setup installer.
echo ------------------------------------------
echo { ! } The purpose of this script is to help install the correct libs and dependancies in one click.
echo -
echo { ! } Made by httpThomas.   
echo -
echo  To begin, press any key.
echo -

                    
echo                         ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;`                      
echo                   '````";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,``````.                
echo                        ,;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:                        
echo                       .............";;;;;;;^...........                         
echo                                   `;;;;;;;" .".                                 
echo                                  `;;;;;;;" `;;,.                                
echo                                '`;;;;;;;,.";;;;,                                
echo                              .,,;;;;;;;, .:;;;;;,                               
echo                             .,";;;;;;;:.  .:;;;;;,                              
echo                            ."^;;;;;;;:`:;;:`;;;;;;,                             
echo                            ``;;;;;;;:`;;;;;:`;;;;;;,                            
echo                            `;;;;;;;:.'''''''.';;;;;;,       Haxe please stop breaking Psych.                    
echo                           ';;;;;;;;.          ';;;;;;,                          
echo                          `;;;;;;;;'            `;;;;;;,                         
echo                         `;;;;;;;;'              `;;;;;;,                        
echo                        ';;;;;;;;`                ^;;;;;;"                       
echo                       ';;;;;;;;`                  ^;;;;;;,                      
echo                       .''''''''                    ```````'                                                           
pause >nul
:begin
:initialpage
cls
cls='clear'

echo ------------------------------------------
echo            Read carefully before
echo         procceding with the installation.
echo ------------------------------------------
echo { ! } Please make sure to have git and the last Haxe version.
echo -
echo { ! } Please make sure to have installed al VS tools 2019.
echo -
echo { ! } It is recommended to reboot your PC once it finishes, but it's not required.
echo -
echo { ! } CAUTION: Only use this script if downloaded from the Psych Engine Source Code Fix forum.
echo { ! } If unsure of the file origin it's recommended to not execute the file.
echo -
echo  If you have read everything, press any key to continue.
pause >nul
echo Select one of the following options:
:begin
cls
cls='clear'
echo 1) I have Haxe installed and the VS tools installed, please start installing everything.
echo -
echo 2) I don't have Haxe installed, please take me to the installation page.
echo -
echo 3) I don't have VS tools installed, please take me to the installation page.
echo -
echo 4) I have installed everything and still can't compile the game.
echo -
echo 5) Credits
echo -
echo 6) Exit

echo -
set /p op= Please choose one of the following options:
cls
cls='clear'
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3
if "%op%"=="4" goto op4
if "%op%"=="5" goto op5
if "%op%"=="6" goto op6
set /p op=Option:


:op1
echo ------------------------------------------
echo            Starting installation..
echo          Please don't close the bat.
echo ------------------------------------------
title FNF Setup - Installing libs, please be patient.
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-ui
haxelib install hscript
haxelib install flixel-tools
haxelib install flixel-addons
haxelib install actuate
haxelib run lime setup
haxelib run lime setup flixel
echo - HxCode is being installed, please remember to set "YES" to version 2.5.1
haxelib install hxCodec 2.5.1
haxelib set hxCodec 2.5.1
echo -
echo ------------------------------------------
echo     Part 1 completed. (Don't close the bat)
echo Libraries have been installed, commencing gits:
echo ------------------------------------------
echo -
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib git faxe https://github.com/uhrobots/faxe
echo - (N) made with love by Thomas
goto finishedinstaling

:op2
start https://haxe.org/download/file/4.3.1/haxe-4.3.1-win.exe/
exit

:op3
start https://visualstudio.microsoft.com/downloads/
exit

:op4
title Psych Setup [0.6.3] (Common issues)
echo ------------------------------------------
echo             Currently viewing:
echo             Common issues page
echo ------------------------------------------
echo -
echo {!} Problem: "Type not found : vlc.MP4Handler" or "Type not found : MP4Handler"
echo {!} Solution: Shouldn't happen, but if it does, just do: haxelib install hxCodec 2.5.1 haxelib set hxCodec 2.5.1
echo -
echo {!} Problem: Deprecation warnings
echo {!} Solution: For a permanent fix, Add haxedef name=no-deprecation-warnings  to your Project.xml above project.  
echo -
echo {!} Problem: source/Paths.hx:3: characters 8-36 : ... referenced here (Thanks to @plank #HASHLINKSWEEP for finding the fix)
echo {!} Solution: Replace import Paths; with #if(!macro) import Paths; #end in your Import.hx
echo -
echo {>} If you still have trouble, please join the Psych Engine Discord server for further help.
pause
goto initialpage

:op5
cls
cls='clear'
echo ------------------------------------------
echo             Currently viewing:
echo                Credits page
echo ------------------------------------------
title Psych Setup [0.6.3] (Credits Page)
echo {-} Bat/Script creator: httpThomas_ (.thomas0001)
echo {-} 0.6.3 Fixes by: superpowers04 - plank #HASHLINKSWEEP - atpx8
echo -
echo {-} Small fixes by: mrniz
echo {-} Libs suggested by: ShadowMario
echo -
echo  ,d88b.d88b,
echo  88888888888
echo  `Y8888888Y'
echo    `Y888Y'    
echo      `Y'
pause >nul


:finishedinstaling
cls
cls='clear'
echo ------------------------------------------
echo               Success!
echo  All libs and gits have been installed
echo ------------------------------------------
echo Thank you for using this automatic Psych Engine libs installer.
echo Please choose an option
echo =============
echo -
echo 1) Join Psych Engine discord server
echo 2) Support me on Youtube
echo 3) Exit
echo -
set /p op=Please choose an option:
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3

:op1
start https://discord.gg/psychengine
goto exit

:op2
start https://www.youtube.com/channel/UCwZTjL5HnHudsRKnFgvitDw
goto exit

:op3
goto exit

:exit
@exit