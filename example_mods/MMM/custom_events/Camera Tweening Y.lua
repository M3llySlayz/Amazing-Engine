function onEvent(n, v1, v2)
    if n == 'Camera Tweening Y' then
        doTweenY('herewego', 'camGame', getProperty('camGame.y') + tonumber(v1), tonumber(v2), 'CircInOut');
        doTweenY('herewego2', 'camHUD', getProperty('camHUD.y') + tonumber(v1), tonumber(v2), 'CircInOut');
    end
end