function onCreate()
	--Create Background sprites
	makeLuaSprite('hue', 'stages/hue', -1200, -650);
	setLuaSpriteScrollFactor('hue', 0.9);
	
	makeLuaSprite('island', 'stages/island', -1300, -400);

	-- sprites that only load if Low Quality is turned off
	if not lowQuality then
		--Low Quality mode not yet implemented
	end

	addLuaSprite('island', false);
	addLuaSprite('hue', false);
	
	--close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end