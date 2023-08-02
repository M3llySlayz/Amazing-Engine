function onCreate()
	makeAnimatedLuaSprite('ground','stages/ground', 600, 200);
	scaleObject('ground', 2, 2);

	addLuaSprite('ground', false);

	close(true);
end