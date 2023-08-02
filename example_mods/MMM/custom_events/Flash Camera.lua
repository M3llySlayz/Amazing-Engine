function onEvent(n,v1,v2)
	if n == 'Flash Camera' then
		--makes the flash white if nothing is entered for v2
		if v2 == '' then
			v2 = 'ffffff'
		end
	   makeLuaSprite('flash', '', 0, 0);
        makeGraphic('flash',1280,720,v2)
	      addLuaSprite('flash', true);
	      setLuaSpriteScrollFactor('flash',0,0)
	      setProperty('flash.scale.x',2)
	      setProperty('flash.scale.y',2)
	      setProperty('flash.alpha',0)
		setProperty('flash.alpha',1)
		doTweenAlpha('flTw','flash',0,v1,'linear')
	end
end