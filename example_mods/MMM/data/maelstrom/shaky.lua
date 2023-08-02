function onCreate()
    setProperty('camHUD.y', -800);
    makeLuaSprite('black', 'stages/black', -2350, -450)
    scaleObject('black', 3.5, 3.5)
    addLuaSprite('black', true);
    setProperty('iconP1.alpha', 0);
    setProperty('iconP2.alpha', 0);
    setProperty('healthBar.alpha', 0);
    setProperty('healthBarBG.alpha', 0);
    setProperty('scoreTxt.alpha', 0);
end

function onSongStart()
    setProperty('timeBar.alpha', 0);
    setProperty('timeBarBG.alpha', 0);
    setProperty('timeTxt.alpha', 0);
    doTweenY('intro', 'camHUD', 0, 0.3, 'linear')
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    triggerEvent('Screen Shake', tonumber('0.05, 0.02'), tonumber('0.05, 0.02'));
    triggerEvent('Camera Follow Pos','','')
end
function onStepHit()
    if curStep == 1792 then
            setPropertyFromGroup('playerStrums', 0, 'downScroll', true)
            setPropertyFromGroup('playerStrums', 1, 'downScroll', true)
            setPropertyFromGroup('playerStrums', 2, 'downScroll', true)
            setPropertyFromGroup('playerStrums', 3, 'downScroll', true)
        end
    if curStep == 1920 then
        setPropertyFromGroup('playerStrums', 0, 'downScroll', false)
        setPropertyFromGroup('playerStrums', 1, 'downScroll', false)
    end
    if curStep == 2048 then
        setPropertyFromGroup('playerStrums', 2, 'downScroll', false)
        setPropertyFromGroup('playerStrums', 3, 'downScroll', false)
    end
end

local xx2 = 900;
local yy2 = 950;
local ofs = 80;
local followchars = true;
local del = 0;
local del2 = 0;


function onUpdate()
    if curStep >= 1528 then
	if del > 0 then
		del = del - 1
	end
	if del2 > 0 then
		del2 = del2 - 1
	end
    if followchars == true then
        if mustHitSection == true then
            if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
            end
            if getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
            end
	    if getProperty('boyfriend.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx2,yy2)
            end
        end
    end
    else
        triggerEvent('Camera Follow Pos','','')
    end
end