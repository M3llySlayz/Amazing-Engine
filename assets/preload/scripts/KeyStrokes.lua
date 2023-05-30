-- by concow
--though obviously melly edited this for ae
local enableStrokes;
function onCreate()
	enableStrokes = getPropertyFromClass('ClientPrefs', 'keyStrokes');
end

function onCreatePost()
	if enableStrokes then
		addHaxeLibrary('InputFormatter');
		
		makeLuaSprite('keyleft', nil, 9, downscroll and 73 or 650);
		makeGraphic('keyleft', 60, 60, 'ffffff');
		addLuaSprite('keyleft', true);
		setObjectCamera('keyleft', 'other');
		setProperty('keyleft.alpha', 0.26);
		
		makeLuaSprite('keydown', nil, 75, downscroll and 73 or 650);
		makeGraphic('keydown', 60, 60, 'ffffff');
		addLuaSprite('keydown', true);
		setObjectCamera('keydown', 'other');
		setProperty('keydown.alpha', 0.26);
		
		makeLuaSprite('keyup', nil, 75, downscroll and 6 or 585);
		makeGraphic('keyup', 60, 60, 'ffffff');
		addLuaSprite('keyup', true);
		setObjectCamera('keyup', 'other');
		setProperty('keyup.alpha', 0.26);
		
		makeLuaSprite('keyright', nil, 141, downscroll and 73 or 650);
		makeGraphic('keyright', 60, 60, 'ffffff');
		addLuaSprite('keyright', true);
		setObjectCamera('keyright', 'other');
		setProperty('keyright.alpha', 0.26);
		
		runHaxeCode([[
			game.setOnLuas('leftKey', InputFormatter.getKeyName(game.keysArray[0][0]));
			game.setOnLuas('downKey', InputFormatter.getKeyName(game.keysArray[1][0]));
			game.setOnLuas('upKey', InputFormatter.getKeyName(game.keysArray[2][0]));
			game.setOnLuas('rightKey', InputFormatter.getKeyName(game.keysArray[3][0]));
		]]);
		
		makeLuaText('left', leftKey:upper(), 60, 8, downscroll and 89 or 666);
		setTextBorder('left', 0, 'ffffff');
		setTextSize('left', 22);
		setTextAlignment('left', 'center');
		setProperty('left.antialiasing', false);
		addLuaText('left');
		setObjectCamera('left', 'other');
		
		makeLuaText('down', downKey:upper(), 60, 74, downscroll and 89 or 666);
		setTextBorder('down', 0, 'ffffff');
		setTextSize('down', 22);
		setTextAlignment('down', 'center');
		setProperty('down.antialiasing', false);
		addLuaText('down');
		setObjectCamera('down', 'other');
		
		makeLuaText('up', upKey:upper(), 60, 74, downscroll and 22 or 601);
		setTextBorder('up', 0, 'ffffff');
		setTextSize('up', 22);
		setTextAlignment('up', 'center');
		setProperty('up.antialiasing', false);
		addLuaText('up');
		setObjectCamera('up', 'other');
		
		makeLuaText('right', rightKey:upper(), 60, 140, downscroll and 89 or 666);
		setTextBorder('right', 0, 'ffffff');
		setTextSize('right', 22);
		setTextAlignment('right', 'center');
		setProperty('right.antialiasing', false);
		addLuaText('right');
		setObjectCamera('right', 'other');
	end
end

keyToDir = {
	[0] = 'left',
	[1] = 'down',
	[2] = 'up',
	[3] = 'right',
}

function onKeyPress(key) --detective baldi is a fucking genius  
	initKeyStroke(key)
end

function onKeyRelease(key)
	keyStrokeFade(key);
end

function initKeyStroke(key)
	if enableStrokes then
		cancelTween('kfade' .. keyToDir[key]);
		cancelTween('fade' .. keyToDir[key]);
		setProperty(keyToDir[key] .. '.color', getColorFromHex('969697'));
		setProperty('key' .. keyToDir[key] .. '.alpha', 1);
	end
end

function keyStrokeFade(dir)
	if enableStrokes then
		doTweenColor('kfade' .. keyToDir[dir], keyToDir[dir], 'FFFFFF', 0.3);
		doTweenAlpha('fade' .. keyToDir[dir], 'key' .. keyToDir[dir], 0.26, 0.3);
	end
end