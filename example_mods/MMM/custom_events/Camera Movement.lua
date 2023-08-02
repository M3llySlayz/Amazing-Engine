function onEvent(n, v1, v2)
    if n == 'Camera Movement' then
        setProperty('camGame.x', getProperty('camGame.x') + tonumber(v1))
        setProperty('camGame.y', getProperty('camGame.y') + tonumber(v2))
    end
end