function onCreate()

	makeLuaSprite('bg','stages/bg', -600,-300);
	makeLuaSprite('floor','stages/floor',-600,-300);

	addLuaSprite('bg',false)
	addLuaSprite('floor',false)

	close(true);
end