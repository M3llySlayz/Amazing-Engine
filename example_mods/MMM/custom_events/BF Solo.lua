function onEvent(n, v1, v2)
    if n == 'BF Solo' then
        doTweenAlpha('score', 'scoreTxt', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('timeBar', 'timeBar', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('timeBarBG', 'timeBarBG', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('time', 'timeTxt', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('health', 'healthBar', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('healthBG', 'healthBarBG', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('iconBF', 'iconP1', tonumber(v2), tonumber(v1), 'linear');
        doTweenAlpha('iconOP', 'iconP2', tonumber(v2), tonumber(v1), 'linear');
    end
end