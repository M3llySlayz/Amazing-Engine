-- Lua stuff
function onCreate()
	-- background shit
	-- sky
	makeLuaSprite('sky', 'stages/sky', -250, -350);
	setScrollFactor('sky', 0.1, 0.1);
	scaleObject('sky', 0.9, 0.9);

	-- city
	makeLuaSprite('city', 'stages/city', -300, -280);
	setScrollFactor('city', 0.15, 0.15);
	scaleObject('city', 0.9, 0.9);

	-- windows
	makeLuaSprite('windows', 'stages/windows', -300, -280);
	setScrollFactor('windows', 0.15, 0.15);
	scaleObject('windows', 0.9, 0.9);

	-- helicopter
	makeAnimatedLuaSprite('heli', 'stages/heli', -3000, -200);
	addAnimationByPrefix('heli', 'heli', 'heli', 24, true); --heli
	setScrollFactor('heli', 0.4, 0.3);
	scaleObject('heli', 0.9, 0.9);
	setProperty('heli.velocity.x', 400);

	-- testicles, balls, cojones, dwayne the rock johnsons
	makeAnimatedLuaSprite('dwayne_left', 'stages/deimos n sanford', -300, -200);
	addAnimationByPrefix('dwayne_left', 'reveal', 'deimos appears', 24, false);
	addAnimationByPrefix('dwayne_left', 'dwayne', 'deimos idle', 24, true);
	addAnimationByPrefix('dwayne_left', 'bop', 'deimos idle', 24, false);
	addAnimationByPrefix('dwayne_left', 'fire', 'deimshoot', 24, false);
	setScrollFactor('dwayne_left', 0.4, 0.5);
	setProperty('dwayne_left.alpha', 0.0001);

	makeAnimatedLuaSprite('dwayne_right', 'stages/deimos n sanford', 940, -200);
	addAnimationByPrefix('dwayne_right', 'reveal', 'Sanford appears', 24, false);
	addAnimationByPrefix('dwayne_right', 'dwayne', 'idle san', 24, true);
	addAnimationByPrefix('dwayne_right', 'bop', 'idle san', 24, false);
	addAnimationByPrefix('dwayne_right', 'fire', 'shoot san', 24, false);
	setScrollFactor('dwayne_right', 0.4, 0.5);
	setProperty('dwayne_right.alpha', 0.0001);

	-- fake dwaynes
	makeLuaSprite('fakedwayne_left', 'stages/dwayneLeft', -285, -200);
	setScrollFactor('fakedwayne_left', 0.4, 0.5);
	
	makeLuaSprite('fakedwayne_right', 'stages/dwayneRight', 1190, -200);
	setScrollFactor('fakedwayne_right', 0.4, 0.5);

	-- floor
	makeLuaSprite('floor', 'stages/floorA', -400, -350);
	scaleObject('floor', 1.15, 1.15);

	addLuaSprite('sky', false);
	addLuaSprite('city', false);
	addLuaSprite('windows', false);
	addLuaSprite('heli', false);
	addLuaSprite('dwayne_left', false);
	addLuaSprite('dwayne_right', false);
	addLuaSprite('fakedwayne_left', false);
	addLuaSprite('fakedwayne_right', false);
	addLuaSprite('floor', false);
end

local dwayneBop = false;
local leftDwayneIsShooting = false;
local rightDwayneIsShooting = false;
function onEvent(name, value1, value2)
	--debugPrint(name);
	--debugPrint(value1);
	--debugPrint(value2);
	if name == 'Change Character' then
		if getProperty('dad.curCharacter') == 'tricky' then
			setProperty('gf.visible', false);
			setProperty('dad.scrollFactor.x', 0.95);
			setProperty('dad.scrollFactor.y', 0.95);
			setProperty('dad.x', 383);
			setProperty('dad.y', -26);
			--characterPlayAnim('gf', 'idle-alt', true);
			--debugPrint('is tiky')
		else
			setProperty('gf.visible', true);
			setProperty('dad.scrollFactor.x', 1);
			setProperty('dad.scrollFactor.y', 1);
		end
	elseif name == 'Start Dwayne Bop' then
		--debugPrint('dwayne bopped! what a chad')
		objectPlayAnimation('dwayne_left', 'reveal');
		objectPlayAnimation('dwayne_right', 'reveal');
		setProperty('dwayne_left.alpha', 1);
		setProperty('dwayne_right.alpha', 1);
		removeLuaSprite('fakedwayne_left');
		removeLuaSprite('fakedwayne_right');
		leftDwayneIsShooting = true;
		rightDwayneIsShooting = true;
		dwayneBop = true;
	end
end

function onUpdate(elapsed)
	if leftDwayneIsShooting and getProperty('dwayne_left.animation.curAnim.finished') then
		leftDwayneIsShooting = false;
	end
	if rightDwayneIsShooting and getProperty('dwayne_right.animation.curAnim.finished') then
		rightDwayneIsShooting = false;
	end
end

function onBeatHit()
	if curBeat % 2 == 1 then
		return;
	end

	if not leftDwayneIsShooting and dwayneBop then
		objectPlayAnimation('dwayne_left', 'bop', true);
		setProperty('dwayne_left.offset.x', 7);
		setProperty('dwayne_left.offset.y', -53);
	end
	if not rightDwayneIsShooting and dwayneBop then
		objectPlayAnimation('dwayne_right', 'bop', true);
		setProperty('dwayne_right.offset.x', -139);
		setProperty('dwayne_right.offset.y', -53);
	end
end

function onMoveCamera(focus)
	if dwayneBop then
		setProperty('camFollow.y', getProperty('camFollow.y') - 100);
	end
end