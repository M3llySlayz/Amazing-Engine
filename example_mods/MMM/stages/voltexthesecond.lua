function onCreate()

    makeLuaSprite('bg', 'stages/BG_back_finale', -400, 0);
    scaleObject('bg', 1.6, 1.5);

    makeLuaSprite('floor', 'stages/BG_floor_symmetrical', -400, 0);
    scaleObject('floor', 1.6, 1.5);

    addLuaSprite('bg', false);
    addLuaSprite('floor', false)
end