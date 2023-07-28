-- Normal Splitscroll By: BlueColorsin's Shitty Scripts production--
--Every Other Splitscroll Made By Irshaad--
--SwapScroll Made By Irshaad--
--ScrollType Script--

-- Changelog 26/05/2023
function math.round(val) 
    return math.floor(val+0.5)
end
--This is needed for rounding variables clearly.
--Also now all keys should be supported
--it's 10:51 as i'm writing this. -Irshaad

local scrollType --28/06/2023. I'm surprised that 2 days of sleep deprivation, I am still able to do this
local swapType --25/07/2023. It's been almost a month, It's time splitscroll got an update. I've got tons of assignments to do yet so little time though, won't you agree? --26/07/2023 5 Assignments done, 1 to go.
local swapReverse
local xDisplacement
local BarConfig = {0, -20}

function onCreate()

    if getPropertyFromClass('ClientPrefs', 'splitScroll') ~= 'None' then
        setProperty('skipArrowStartTween', true)
    else 
        if getPropertyFromClass('ClientPrefs', 'swapScroll') ~= 'None' then
            setProperty('skipArrowStartTween', true)
        end
    end

    scrollType = getPropertyFromClass('ClientPrefs', 'splitScroll')
    swapType = getPropertyFromClass('ClientPrefs', 'swapScroll')
    swapSwap = getPropertyFromClass('ClientPrefs', 'swapReverse') --27/07/23 Is it me or does seeing swap so many times make you think you spelt it wrong. -Irshaad
end

function onCreatePost()

    if swapType == 'None' then
        --do nothing again lol
    else
        if swapType == 'Quarter' then
            if (swapSwap) then
                i = mania
                while i ~= 0 do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if i >= ((mania / 4) * 3) then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                    i = i - 1
                end
            else
                for i = 0,mania do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if i <= (mania / 4) then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                end
            end
        end
        if swapType == 'Half' then
            if (swapSwap) then
                i = mania
                while i ~= 0 do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if i >= (mania / 2) then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                    i = i - 1
                end
            else
                for i = 0,mania-1 do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if i <= (mania / 2) then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                end
            end
        end
        if swapType == 'Three Quarter' then
            if (swapSwap) then
                i = mania
                while i ~= 0 do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if i >= ((mania / 4) * 3) then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                    i = i - 1
                end
            else
                for i = 0,mania do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if i >= (mania / 4) then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                end
            end
        end
        if swapType == 'Full' then
            for i = 0,mania do
                xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
            end
        end
        if scrollType == 'Quarter Alt' then
            if (swapSwap) then
                counter = 0
                i = mania
                while i ~= 0 do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if counter == 0 then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                    counter = counter + 1
                    if counter == 4 then
                        counter = 0
                    end
                    i = i - 1
                end
            else
                counter = 0
                for i = 0,mania-1 do
                    xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                    if counter == 0 then
                        setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                        setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                    end
                    counter = counter + 1
                    if counter == 4 then
                        counter = 0
                    end
                end
            end
            if scrollType == 'Half Alt' then
                if (swapSwap) then
                    counter = 0
                    i = mania
                    while i ~= 0 do
                        xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                        if counter < 1 and counter > 2 then
                            setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                            setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                        end
                        counter = counter + 1
                        if counter == 4 then
                            counter = 0
                        end
                        i = i - 1
                    end
                else
                    counter = 0
                    for i = 0,mania-1 do
                        xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                        if counter > 0 and counter < 3 then
                            setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                            setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                        end
                        counter = counter + 1
                        if counter == 4 then
                            counter = 0
                        end
                    end
                end
                if scrollType == 'Three Quarter Alt' then
                    if (swapSwap) then
                        counter = 0
                        i = mania
                        while i ~= 0 do
                            xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                            if counter < 1 and counter > 2 then
                                setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                                setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                            end
                            counter = counter + 1
                            if counter == 4 then
                                counter = 0
                            end
                            i = i - 1
                        end
                    else
                        counter = 0
                        for i = 0,mania-1 do
                            xDisplacement = (getPropertyFromGroup('playerStrums', i, 'x') - getPropertyFromGroup('opponentStrums', i, 'x'))
                            if counter > 0 and counter < 3 then
                                setPropertyFromGroup('opponentStrums', i, 'x', (getPropertyFromGroup('opponentStrums', i, 'x') + xDisplacement))
                                setPropertyFromGroup('playerStrums', i, 'x', (getPropertyFromGroup('playerStrums', i, 'x') - xDisplacement))
                            end
                            counter = counter + 1
                            if counter == 4 then
                                counter = 0
                            end
                        end
                    end
                end
            end
        end
    end
    if not downscroll then --DownScroll Off
        if scrollType == 'None' then
            --do nothing lmao
        end
        if scrollType == 'Normal' then
            for i = 0,(math.round(mania / 2) - 1) do
                setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                setPropertyFromGroup('playerStrums',i,'downScroll',true) 
            end
        end
        if scrollType == 'Alt' then
            counter = 0
            for i = 0,mania-1 do
                if counter <= 1 then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
                counter = counter + 1
                if counter == 4 then
                    counter = 0
                end
            end
        end
        if scrollType == 'Up n\' Down' then
            for i = 0,mania-1 do
                if (math.round(i / 2)) == (i / 2) then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
        end
        if scrollType == 'Double Down' then
            for i = 0,mania-1 do
                if i > (mania / 4) and i < ((mania / 4) * 3) then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
        end
        if scrollType == 'Double Down Alt' then
            counter = 0
            for i = 0,mania-1 do
                if counter > 0 and counter < 3 then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
                counter = counter + 1
                if counter == 4 then
                    counter = 0
                end
            end
        end
        --[[ THIS WAS DISCONTINUED. MAY CONTINUE AT SOME POINT -Irshaad
            
        if scrollType == 'Split SplitScroll' then
            for i = 0,(math.round(mania / 2))-1 do
                setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                setPropertyFromGroup('playerStrums', i, 'x', getPropertyFromGroup('strumLineNotes', i, 'x'))
                setPropertyFromGroup('playerStrums',i,'downScroll',true) 
            end
        end
        if scrollType == 'Up n\' Down Split SplitScroll' then--]]

        BarConfig = {706, 620}
    else --DownScroll On
        if scrollType == 'None' then
            --do nothing lmao
        end
        if scrollType == 'Normal' then
            for i = 0,(math.round(mania / 2))-1 do
                setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                setPropertyFromGroup('playerStrums',i,'downScroll',false) 
            end
        end
        if scrollType == 'Alt' then
            counter = 0
            for i = 0,mania-1 do
                if counter <= 1 then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
                counter = counter + 1
                if counter == 4 then
                    counter = 0
                end
            end
        end
        if scrollType == 'Up n\' Down' then
            for i = 0,mania-1 do
                if (math.round(i / 2)) == (i / 2) then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
        end
        if scrollType == 'Double Down' then
            for i = 0,mania-1 do
                if i > (mania / 4) and i < ((mania / 4) * 3) then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
        end
        if scrollType == 'Double Down Alt' then
            counter = 0
            for i = 0,mania-1 do
                if counter > 0 and counter < 3 then
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
                counter = counter + 1
                if counter == 4 then
                    counter = 0
                end
            end
        end
    end
    -- Icon Shit
    if scrollType ~= 'None' then
        setProperty('iconP1.y', BarConfig[2]) --sets both of the icons too there value
        setProperty('iconP2.y', BarConfig[2])
        setProperty('scoreTxt.y', BarConfig[1]) -- scoreTxt out of the way :D
        setProperty('healthBar.y', BarConfig[1]) -- as you can tell this is setProperty abuse
        setProperty('healthBarOverlay.y', BarConfig[1])
    end
end
