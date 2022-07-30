local canEnd = false;

function onEndSong()
   if not canEnd then
  
         setProperty('inCutscene', true);
         runTimer('startDialogue', 0.5)
         canEnd = true
         return Function_Stop;
      
   end
   return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'startDialogue' then
        setProperty('camOther.alpha', 0.35);
		startDialogue('dialogueEnd', '');
	end
end