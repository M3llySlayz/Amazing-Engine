function onStepHit()
    if curStep == 1279 then
        setProperty('defaultCamZoom', 1.5)
        setProperty('camHUD.visible', false)
    end
    if curStep == 1526 then
        setProperty('camHUD.visible', true)
    end
    if curStep == 1536 then
        setProperty('defaultCamZoom', 0.6)
        setProperty('floorspot.visible', true)
        setProperty('floorglow.visible', true)
    end
end