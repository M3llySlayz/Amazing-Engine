function onCreatePost()
	setProperty('scoreTxt.visible', 0)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)
end

function onStepHit()
    if curStep == 388 then
        setProperty('camHUD.visible', false)
    end
    if curStep == 444 then
        setProperty('camHUD.visible', true)
    end
    if curStep == 452 then
        setProperty('camHUD.visible', false)
    end
    if curStep == 508 then
        setProperty('camHUD.visible', true)
    end
    if curStep == 1152 then
        setProperty('camHUD.visible', false)
        setProperty('healthBar.visible', false)
        setProperty('healthBarBG.visible', false)
    end
    if curStep == 1279 then
        setProperty('camHUD.visible', true)
    end
    if curStep == 1407 then
        setProperty('healthBar.visible', true)
        setProperty('healthBarBG.visible', true)
    end
    if curStep == 1668 then
        setProperty('camHUD.visible', false)
    end
    if curStep == 1724 then
        setProperty('camHUD.visible', true)
    end
    if curStep == 1732 then
        setProperty('camHUD.visible', false)
    end
    if curStep == 1788 then
        setProperty('camHUD.visible', true)
    end
    if curStep == 1920 then
        setProperty('healthBar.visible', false)
        setProperty('healthBarBG.visible', false)
    end
    if curStep == 2448 then
        setProperty('scoreTxt.visible', 1)
        setProperty('healthBar.visible', true)
        setProperty('healthBarBG.visible', true)
    end
end

