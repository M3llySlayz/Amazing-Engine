--By: BlueColorsin's Shitty Scripts production--
--Simple Splitscroll Script--
--Melly, how did you not logically think about this: Irshaad--

-- Changelog 26/05/2023
function math.round(val) 
    return math.floor(val+0.5)
end
--This is needed for rounding variables clearly.
--Also now all keys should be supported
--it's 10:51 as i'm writing this. -Irshaad

local on
local alt
local BarConfig = {0, -20}

function onCreate()
    on = getPropertyFromClass('ClientPrefs', 'splitScroll')
    alt = getPropertyFromClass('ClientPrefs', 'altSplitScroll');
end

function onCreatePost()
    if on == true and alt == false then
    -- if downscroll == false then 
        if not downscroll then
            if mania == 0 then
                --do nothing lmao
            end
            if mania == 1 then
                for i = 0,0 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            if mania == 2 then
                for i = 0,0 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            if mania == 3 then
                for i = 0,1 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            if mania == 4 then
                for i = 0,1 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            if mania == 5 then
                for i = 0,2 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 6 then
                for i = 0,2 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            if mania == 7 then
                for i = 0,3 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            if mania == 8 then
                for i = 0,3 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 9 then
                for i = 0,4 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 10 then
                for i = 0,4 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 11 then
                for i = 0,5 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 12 then
                for i = 0,5 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 13 then
                for i = 0,6 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 14 then
                for i = 0,6 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 15 then
                for i = 0,7 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 16 then
                for i = 0,7 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == 17 then
                for i = 0,8 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true)
                end
            end
            if mania == nil then
                for i = 0,1 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',true) 
                end
            end
            BarConfig = {706, 620}
        else -- if downscroll == true then
            if mania == 0 then
                --do nothing lmao
            end
            if mania == 1 then
                for i = 0,0 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
            if mania == 2 then
                for i = 0,0 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
            if mania == 3 then
                for i = 0,1 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
            if mania == 4 then
                for i = 0,1 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
            if mania == 5 then
                for i = 0,2 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 6 then
                for i = 0,2 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
            if mania == 7 then
                for i = 0,3 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
            if mania == 8 then
                for i = 0,3 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 9 then
                for i = 0,4 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 10 then
                for i = 0,4 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 11 then
                for i = 0,5 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 12 then
                for i = 0,5 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 13 then
                for i = 0,6 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 14 then
                for i = 0,6 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 15 then
                for i = 0,7 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 16 then
                for i = 0,7 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == 17 then
                for i = 0,8 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false)
                end
            end
            if mania == nil then
                for i = 0,1 do
                    setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                    setPropertyFromGroup('playerStrums',i,'downScroll',false) 
                end
            end
        end
    else if alt == true then
        if not downscroll then
            if mania == nil then
                for i = 0,3 do
                    if (math.round(i / 2)) == (i / 2) then
                        setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                        setPropertyFromGroup('playerStrums',i,'downScroll',true)
                    end
                end
            else -- if mania has an int in it
                for i = 0,mania do
                    if (math.round(i / 2)) == (i / 2) then
                        setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') + 500))
                        setPropertyFromGroup('playerStrums',i,'downScroll',true)
                    end
                end
            end
            BarConfig = {706, 620}
        else -- if downscroll == true then
            if mania == nil then
                for i = 0,3 do
                    if (math.round(i / 2)) == (i / 2) then
                        setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                        setPropertyFromGroup('playerStrums',i,'downScroll',false)
                    end
                end
            else
                for i = 0,mania do
                    if (math.round(i / 2)) == (i / 2) then
                        setPropertyFromGroup('playerStrums', i, 'y', (getPropertyFromGroup('strumLineNotes', i, 'y') - 500))
                        setPropertyFromGroup('playerStrums',i,'downScroll',false)
                    end
                end
            end
        end
        -- Icon Shit
        setProperty('iconP1.y', BarConfig[2]) --sets both of the icons too there value
        setProperty('iconP2.y', BarConfig[2])
        setProperty('scoreTxt.y', BarConfig[1]) -- scoreTxt out of the way :D
        setProperty('healthBar.y', BarConfig[1]) -- as you can tell this is setProperty abuse
        setProperty('healthBarOverlay.y', BarConfig[1])
        end
    end
end
