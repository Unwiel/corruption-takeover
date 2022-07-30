function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Day3Bullets' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'picod1/note/Bullets');
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0'); --Default value is: 0.023, health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.275'); --Default value is: 0.0475, health lost on miss

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
	if noteType == "Day3Bullets" then
		cameraShake('game',0.01,0.1)
		playSound('shoot', 0.6)
	end

	if noteType == "Day3Bullets" and noteData == 0 then
		characterPlayAnim('BF','singLEFT-alt',false)
	end
	
	if noteType == "Day3Bullets" and noteData == 1 then
		characterPlayAnim('BF','singDOWN-alt',false)
	end
	
	if noteType == "Day3Bullets" and noteData == 2 then
		characterPlayAnim('BF','singUP-alt',false)
	end
	
	if noteType == "Day3Bullets" and noteData == 3 then
		characterPlayAnim('BF','singRIGHT-alt',false)
	end
end

function noteMiss(noteType) 
     if noteType == "Day3Bullets" then
		cameraShake('game',0.01,0.1)
		playSound('shoot', 0.6)
	end
end 

