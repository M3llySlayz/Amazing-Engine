function onCreate()
    setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-pixel-dead');

    --low quality things
    makeLuaSprite('LQbg', 'City Path', -625, 275);
    makeAnimatedLuaSprite('LQrain', 'Rain', -625, 275);
    makeLuaSprite('dark', '', -625, 275);

    --darkness because who needs pngs
    makeGraphic('dark', 640, 360, 000000);

    addAnimationByPrefix('LQrain', 'idle', 'CP Idle', 24, true);

    scaleObject('LQbg', 3.5, 4);
    scaleObject('LQrain', 3.5, 4);
    scaleObject('dark', 3.5, 4);

    objectPlayAnimation('LQrain', 'idle', true);

    addLuaSprite('LQbg', false);
    addLuaSprite('LQrain', true);
    addLuaSprite('dark', true);

    setProperty('dark.alpha', 0.4);
    setProperty('LQbg.antialiasing', false);

    --high quality things
    makeAnimatedLuaSprite('bg', 'City Path Good', -625, 50);
    makeAnimatedLuaSprite('rain', 'Rain Good', -625, 50);

    addAnimationByPrefix('bg', 'idle', 'CP Idle', 8, true);
    addAnimationByPrefix('rain', 'idle', 'CP Idle', 15, true);

    scaleObject('bg', 3.5, 4);
    scaleObject('rain', 3.5, 4);

    objectPlayAnimation('bg', 'idle', true);
    objectPlayAnimation('rain', 'idle', true);

    addLuaSprite('bg', false);
    addLuaSprite('rain', true);

    setProperty('bg.antialiasing', false);
end

function onCreatePost()
    if lowQuality then
        setProperty('bg.visible', false);
        setProperty('rain.visible', false);
    elseif not lowQuality then
        setProperty('LQbg.visible', false)
        setProperty('LQrain.visible', false)
    end
end

function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0 then
		objectPlayAnimation('LQrain', 'idle', true);
        objectPlayAnimation('bg', 'idle', true);
        objectPlayAnimation('rain', 'idle', true);
	end
end