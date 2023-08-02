function onCreate()
	
	makeLuaSprite('club','stages/club', -600, -500);
	setScrollFactor('club', 0.9, 0.9);
	scaleObject('club', 1.75, 1.75)

	addLuaSprite('club',false)

	close(true);
end