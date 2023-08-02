---@diagnostic disable: lowercase-global
local xx = 1120;
local yy = 1700;
local xx2 = 1220;
local yy2 = 1700;
local ofs = 60;
local followchars = true;
cam = 'normal';

function onUpdate()
    if cam == 'normal' then
        xx = 1120;
        yy = 1700;
        xx2 = 1220;
        yy2 = 1700;
        ofs = 60;
    elseif cam == 'bf' then
        xx = 1020;
        yy = 1700;
        xx2 = 1220;
        yy2 = 1700;
        ofs = 60;
    elseif cam == 'opponent' then
        xx = 920;
        yy = 1600;
        xx2 = 1520;
        yy2 = 1800;
        ofs = 60;
    elseif cam == 'oppswap' then
        xx = 1700;
        yy = 1600;
        xx2 = 2100;
        yy2 = 1800;
        ofs = 60;
    elseif cam == 'bfswap' then
        xx = 820;
        yy = 1700;
        xx2 = 820;
        yy2 = 1700;
        ofs = 60;
    elseif cam == 'oppswap2' then
        xx = 1700;
        yy = 1600;
        xx2 = 2100;
        yy2 = 1600;
        ofs = 60;
    end
    if followchars == true then
        if mustHitSection == false then
            if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singLEFT-alt' then
                triggerEvent('Camera Follow Pos',xx-ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singRIGHT-alt' then
                triggerEvent('Camera Follow Pos',xx+ofs,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'singUP-alt' then
                triggerEvent('Camera Follow Pos',xx,yy-ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'singDOWN-alt' then
                triggerEvent('Camera Follow Pos',xx,yy+ofs)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle-alt' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
            if getProperty('dad.animation.curAnim.name') == 'idle' then
                triggerEvent('Camera Follow Pos',xx,yy)
            end
        else
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
    else
        triggerEvent('Camera Follow Pos','','')
    end
end

function onEvent(n, v1, v2)
    if n == 'Maroon Cam' then
        if v1 == 'bf' or v1 == 'boyfriend' or v1 == 1 then
            cam = 'bf';
        elseif v1 == 'opp' or v1 == 'opponent' or v1 == 2 then
            cam = 'opponent';
        elseif v1 == 'normal' or v1 == 'off' or v1 == 0 then
            cam = 'normal';
        elseif v1 == 'oppswap' or v1 == 'right' then
            cam = 'oppswap';
        elseif v1 == 'bfswap' or v1 == 'left' then
            cam = 'bfswap';
        elseif v1 == 'oppswap2' or v1 == 'rightup' then
            cam = 'oppswap2'
        end
    end
end