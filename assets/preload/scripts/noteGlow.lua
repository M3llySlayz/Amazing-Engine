local options = {
	timeDelayDivider = 1.25, -- Recommended around 1.5
	brightAdd = 2.35, -- Recommended around 2.5
	ease = 'backInOut', -- 😎
	startSlightlyDark = true -- Recommended if the note gets darker on tween start. So it doesn't look awkward.
}

function onCreate()
	if getPropertyFromClass('ClientPrefs', 'noteGlow') == false then
		close(true);
	end
end

local fakeIndex = 0 -- When notes spawn their index is 0 and `.length` sometimes would repeat. So I made fake index.
function onSpawnNote(membersIndex, noteData, noteType, isSustainNote)
	if canHitNote(membersIndex) and getPropertyFromGroup('notes', membersIndex, 'colorSwap.brightness') <= 1 then
		local timeToStart = (getProperty('spawnTime') / 1000) / options.timeDelayDivider
		local scrollMult = getProperty('songSpeed') / getPropertyFromGroup('notes', membersIndex, 'multSpeed')
		-- debugPrint(timeToStart, ' ', timeToStart / scrollMult)
		runHaxeCode([[
			var daNote:Note = game.notes.members[]] .. tostring(membersIndex) .. [[];
			daNote.colorSwap.brightness -= ]] .. tostring(options.startSlightlyDark and 0.17 or 0) .. [[;
			game.modchartTweens.set('noteGlowID]] .. tostring(fakeIndex) .. [[', FlxTween.tween(daNote.colorSwap, {brightness: daNote.colorSwap.brightness + ]] .. tostring(options.brightAdd) .. [[}, ]] .. tostring((timeToStart / scrollMult) / playbackRate) .. [[, {
				ease: game.luaArray[0].getFlxEaseByString(']] .. tostring(options.ease) .. [['),
				startDelay: ]] .. tostring(timeToStart / playbackRate) .. [[,
				onComplete: function(twn:FlxTween) {
					// game.addTextToDebug('Brightness raised! Distance from strum ' + (Conductor.songPosition - daNote.strumTime) + '.', 0xFFffffff);
				}
			}));
		]])
		fakeIndex = fakeIndex + (isSustainNote and 0.1 or 1) -- sustains be funi
	end
end

-- Checks if the note can be pressed withput it hurting you.
---@param membersIndex number
---@return boolean
function canHitNote(membersIndex)
	for daNote, index in propFromGroup('notes') do
		if index == membersIndex then
			local points = {canHit = 0, cantHit = 0}
			if daNote.get('hitCausesMiss') then points.cantHit = points.cantHit + 1 else points.canHit = points.canHit + 1 end
			if daNote.get('hitHealth') > -1 then points.canHit = points.canHit + 1 else points.cantHit = points.cantHit + 1 end
			if daNote.get('missHealth') < 0 then points.canHit = points.canHit + 1 else points.cantHit = points.cantHit + 1 end
			if daNote.get('ignoreNote') then points.cantHit = points.cantHit + 1 else points.canHit = points.canHit + 1 end
			return points.canHit > points.cantHit
		end
	end
	return
end

-- function from Mayo78
function propFromGroup(object)
	local index = -1
	return function()
		index = index + 1
		if index < getProperty(object .. '.length') then
			local func = {}
			function func.get(property) --no colons cause it doesnt need to reference itself
				return getPropertyFromGroup(object, index, property)
			end
			function func.set(property, value)
				setPropertyFromGroup(object, index, property, value)
			end
			return func, index
		end
	end
end