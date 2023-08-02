function onCreate()
    makeLuaSprite('bg', 'stages/secret_bg', -2350, -450);
    makeLuaSprite('windows', 'stages/secret_screens', -2050, -450);
    makeLuaSprite('alert', 'stages/alert', -2050, -450);
    makeLuaSprite('broken', 'stages/broken', -2050, -450);
    makeLuaSprite('platform', 'stages/secret_platform2', 800, 1300);

    scaleObject('bg', 3.5, 3.5);
    scaleObject('windows', 3, 3);
    scaleObject('alert', 3, 3);
    scaleObject('broken', 3, 3);

    addLuaSprite('bg', false);
    addLuaSprite('windows', false);
    addLuaSprite('alert', false);
    addLuaSprite('broken', false)
    addLuaSprite('platform', false);
    

    setProperty('alert.visible', false);
    setProperty('broken.visible', false);
end

function onBeatHit()
   
    if curBeat == 32 then
        setProperty('alert.visible', true)
        setProperty('black.visible', false)
    end

    if curBeat == 96 then
        setProperty('alert.visible', false)
    end

    if curBeat == 256 then
        setProperty('alert.visible', true)
    end
   
    if curBeat == 352 then
        setProperty('broken.visible', true);
        setProperty('alert.visible', false);
        setProperty('windows.visible', false);
        doTweenY('broken', 'broken', 2200, 1, 'linear');
    end
 
    if curBeat == 360 then
        setProperty('windows.visible', false);
        setProperty('broken.visible', false);
        makeLuaSprite('platform', 'stages/secret_platform2', -75, 1300); --yes again
        addLuaSprite('platform', false);
    end
end