function onCreate()
    makeLuaSprite('bg', 'stages/sas1', -1100, -400)
    scaleObject('bg', 1.4, 1.3)
    
    makeLuaSprite('floorspot', 'stages/sas2', -800, 100)

    makeLuaSprite('floorglow', 'stages/sas3', -800, 100)

    addLuaSprite('bg', false)
    addLuaSprite('floorspot', false)
    addLuaSprite('floorglow', false)
    setProperty('floorspot.visible', false)
    setProperty('floorglow.visible', false)
end