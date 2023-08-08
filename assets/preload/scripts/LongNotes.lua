-- Script by @AppleHair#4645 : https://discord.com/channels/922849922175340586/922851578996744252/966676462579122216

function onCreatePost()
	if getPropertyFromClass('ClientPrefs', 'fixedLongNotes') then
		for i = 0, getProperty('unspawnNotes.length')-1 do
			-- Check if the note is an Sustain Note
			if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true);
			end
		end
	end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
	if getPropertyFromClass('ClientPrefs', 'fixedLongNotes') then
		if isSustainNote then
			-- Fix for play as opponent
			if cpuPlay then
				if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
					if getProperty('gf.animation.curAnim.curFrame')>4 then setProperty('gf.animation.curAnim.curFrame', 2) end
					setProperty('gf.holdTimer', 0);
				else
					if getProperty('dad.animation.curAnim.curFrame')>4 then setProperty('dad.animation.curAnim.curFrame', 2) end
					setProperty('dad.holdTimer', 0);
				end
			else
				if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
					if getProperty('gf.animation.curAnim.curFrame')>4 then setProperty('gf.animation.curAnim.curFrame', 2) end
					setProperty('gf.holdTimer', 0);
				else
					if getProperty('boyfriend.animation.curAnim.curFrame')>4 then setProperty('boyfriend.animation.curAnim.curFrame', 2) end
					setProperty('boyfriend.holdTimer', 0);
				end
			end
		end
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if getPropertyFromClass('ClientPrefs', 'fixedLongNotes') then
		if isSustainNote then
			-- Fix for play as opponent
			if cpuPlay then
				if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
					if getProperty('gf.animation.curAnim.curFrame')>4 then setProperty('gf.animation.curAnim.curFrame', 2) end
					setProperty('gf.holdTimer', 0);
				else
					if getProperty('boyfriend.animation.curAnim.curFrame')>4 then setProperty('boyfriend.animation.curAnim.curFrame', 2) end
					setProperty('boyfriend.holdTimer', 0);
				end
			else
				if getPropertyFromGroup('notes', id, 'gfNote') or noteType == 'GF Sing' then
					if getProperty('gf.animation.curAnim.curFrame')>4 then setProperty('gf.animation.curAnim.curFrame', 2) end
					setProperty('gf.holdTimer', 0);
				else
					if getProperty('dad.animation.curAnim.curFrame')>4 then setProperty('dad.animation.curAnim.curFrame', 2) end
					setProperty('dad.holdTimer', 0);
				end
			end
		end
	end
end