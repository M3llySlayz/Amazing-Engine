function onCreate()

    makeLuaSprite('bg', 'stages/i', -400, 0);
    scaleObject('bg', 1.6, 1.5)
    makeLuaSprite('bg2', 'stages/BG_back_finale', -400, 0)
    makeLuaSprite('floor', 'stages/BG_floor_symmetrical', -400, 0)
    makeLuaSprite('black', 'stages/black', -400, 0)
    scaleObject('bg2', 1.6, 1.5)
    scaleObject('floor', 1.6, 1.5)
    scaleObject('black', 1.6, 1.5)
    addLuaSprite('bg2', false)
    addLuaSprite('floor', false)
    addLuaSprite('black', true)
    addLuaSprite('bg', false)
    setProperty('black.visible', false)
end

function onStepHit()
    if curStep == 1301 then
    setProperty('bg.visible', false)
    setProperty('black.visible', true)
    setProperty('camHUD.visible', false)
    end
end

function onBeatHit()
    if curBeat == 338 then
        setProperty('black.visible', false)
        setProperty('camHUD.visible', true)
    end
end