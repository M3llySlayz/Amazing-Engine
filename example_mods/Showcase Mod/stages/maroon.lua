function onCreate()
    makeLuaSprite('bg', 'stages/maroon/bg', -900, 0);
    makeLuaSprite('THE-SUN', 'stages/maroon/maroon', 1650, 1050);
    makeLuaSprite('opplatform', 'stages/maroon/opp_platform', 200, 1000);
    makeLuaSprite('bfplatform', 'stages/maroon/player_platform', 1150, 1700);

    addLuaSprite('bg', false);
    addLuaSprite('THE-SUN', false);
    addLuaSprite('opplatform', false);
    addLuaSprite('bfplatform', false);

    scaleObject('bg', 2, 2);
    scaleObject('opplatform', 1, 1);
    scaleObject('bfplatform', 0.8, 0.8);
    scaleObject('THE-SUN', 0.5, 0.5);

    close(true)
end