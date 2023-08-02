function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an ArrowNote
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'ArrowNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'ArrowNote'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '-0.25'); --Default value is: 0.23, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.5'); --Default value is: 0.0475, health lost on miss
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', true);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
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
	if noteType == 'ArrowNote' then
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
        playSound('bowmiss', 1);
		characterPlayAnim('dad', 'bow', false);
		characterPlayAnim('bf', 'hurt', false);
	end
end

-- Called after the note miss calculations
-- Player missed a note by letting it go offscreen
function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'ArrowNote' then
		playSound('bowhit', 1); --plays sound on dodging the note
		characterPlayAnim('dad', 'bow', false);
		characterPlayAnim('bf', 'dodge', false);
	end
end