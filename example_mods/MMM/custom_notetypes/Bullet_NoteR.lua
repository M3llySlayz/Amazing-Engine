function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Bullet_NoteR' then --Check if the note on the chart is a Bullet Note
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'dodge/Bullet_NoteR'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashHue', 0); --custom notesplash color, why not
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashSat', -20);
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashBrt', 1);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let BF's notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has penalties
			end
		end
	end
end

local shootAnims = {"singRIGHT", "singUP", "singDOWN", "singLEFT"}
local dodgeAnims = {"Shoot", "Shoot", "Shoot", "Shoot"}
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Bullet_NoteR' then
			playSound('tactieshoot', 0.6);
			characterPlayAnim('dad', 'dodge', true) 
			setProperty('dad.specialAnim', true);
			characterPlayAnim('boyfriend', dodgeAnims[direction + 1], true);
			setProperty('boyfriend.specialAnim', true);
			cameraShake('camGame', 0.01, 0.2);
    end
end

function noteMiss(id, direction, noteType, isSustainNote)
	if noteType == 'Bullet_NoteR' and difficulty == 1 then
		setProperty('health', -0.01);
	elseif noteType == 'Bullet_NoteR' and difficulty == 0 then
		setProperty('health', getProperty('health')-0.8);
		runTimer('bleed', 0.2, 20);
		playSound('hankded', 0.6);
		characterPlayAnim('boyfriend', 'hurt', true);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	-- A loop from a timer you called has been completed, value "tag" is it's tag
	-- loops = how many loops it will have done when it ends completely
	-- loopsLeft = how many are remaining
	if tag == 'bleed' then
		setProperty('health', getProperty('health')-0.001);
	end
	if tag == 'shootanim' then
		setProperty('dad.curCharacter', curDad);
	end
end