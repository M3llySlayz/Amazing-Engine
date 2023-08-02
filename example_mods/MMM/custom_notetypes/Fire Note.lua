---@diagnostic disable: undefined-global, lowercase-global
function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Fire Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Fire Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'fire/NOTE_fire'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0'); --Default value is: 0.23, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.5'); --Default value is: 0.0475, health lost on miss
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);
			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
	--debugPrint('Script started!')
end

-- Function called when you hit a note (after note hit calculations)
-- id: The note member id, you can get whatever variable you want from this note, example: "getPropertyFromGroup('notes', id, 'strumTime')"
-- noteData: 0 = Left, 1 = Down, 2 = Up, 3 = Right
-- noteType: The note type string/tag
-- isSustainNote: If it's a hold note, can be either true or false
function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' then
		playSound('burnSound', 1) --plays sound on hitting the note
		local animToPlay = '';
		if noteData == 0 then
			--if the Left note is hit by you then
			animToPlay = 'sliceLeft';
			--play this animation on the opponent
		elseif noteData == 1 then
			--else if the down note is hit by you
			animToPlay = 'sliceDown';
			--play this, and so on
		elseif noteData == 2 then
			animToPlay = 'sliceUp';
		elseif noteData == 3 then
			animToPlay = 'sliceRight';
		end
        
		characterPlayAnim('dad', animToPlay, true);
		characterPlayAnim('bf', 'dodge', true);
	end
end

-- Called after the note miss calculations
-- Player missed a note by letting it go offscreen
function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'Fire Note' then
		characterPlayAnim('dad', animToPlay, true);
		characterPlayAnim('bf', 'hurt', true);
	end
end