--Script made by XpsxExp.

--Dad variables.
local dadCamX = 0;
local dadCamY = 0;
local dadCamPos = {};
local dadCamOffset = {};
local dadCurAnim = '';
--Bf variables.
local bfCamX = 0;
local camZooming = true;
local bfCamY = 0;
local bfCamPos = {};
local bfCamOffset = {};
local bfCurAnim = '';
--Other
local canFollow = true;
local moveValue = 30;

function onCreate()
   makeLuaText('moveVal', 'Move Value: ' .. moveValue, 0, 10, 690);
   addLuaText('moveVal');
   
   setProperty('moveVal.visible', false);
   
   
end

function onCreatePost()
   --Dad stuff.
   dadCamOffset = getProperty('opponentCameraOffset');
   dadCamPos = getProperty('dad.cameraPosition')
   
   dadCamX = getMidpointX('dad') + 150 + dadCamPos[1] + dadCamOffset[1];
   dadCamY = getMidpointY('dad') - 100 + dadCamPos[2] + dadCamOffset[2];
   --BF stuff.
   bfCamOffset = getProperty('boyfriendCameraOffset');
   bfCamPos = getProperty('boyfriend.cameraPosition');
   
   bfCamX = getMidpointX('boyfriend') - 100 - bfCamPos[1] + bfCamOffset[1];
   bfCamY = getMidpointY('boyfriend') - 100 + bfCamPos[2] + bfCamOffset[2];
end

function goodNoteHit(id, direction, noteType, isSustainNote)
   if mustHitSection and canFollow then
      if direction == 0 then
         triggerEvent('Camera Follow Pos', bfCamX - moveValue, bfCamY);
      elseif direction == 1 then
         triggerEvent('Camera Follow Pos', bfCamX, bfCamY + moveValue);
      elseif direction == 2 then
         triggerEvent('Camera Follow Pos', bfCamX, bfCamY - moveValue);
      elseif direction == 3 then
         triggerEvent('Camera Follow Pos', bfCamX + moveValue, bfCamY);
      end
   end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
   if not mustHitSection and canFollow then
      if direction == 0 then
         triggerEvent('Camera Follow Pos', dadCamX - moveValue, dadCamY);
      elseif direction == 1 then
         triggerEvent('Camera Follow Pos', dadCamX, dadCamY + moveValue);
      elseif direction == 2 then
         triggerEvent('Camera Follow Pos', dadCamX, dadCamY - moveValue);
      elseif direction == 3 then
         triggerEvent('Camera Follow Pos', dadCamX + moveValue, dadCamY);
      end
   end
   
   
end

function noteMissPress(direction)
   if mustHitSection and canFollow then
      triggerEvent('Camera Follow Pos', bfCamX, bfCamY);
   end
   
   
end

function noteMiss(id, direction, noteType, isSustainNote)
   if mustHitSection and canFollow then
      triggerEvent('Camera Follow Pos', bfCamX, bfCamY);
   end
end


function onUpdate()

   --Debug stuff.
   if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.T') and not canFollow then
      canFollow = true;
	  debugPrint('Camera is now following');
   elseif getPropertyFromClass('flixel.FlxG', 'keys.justPressed.T') and canFollow then
      canFollow = false;
	  triggerEvent('Camera Follow Pos', nil, nil);
	  debugPrint('Camera is now not following');
   end
   
   if getPropertyFromClass('flixel.FlxG', 'keys.pressed.O') then
      moveValue = moveValue - 1;
   elseif getPropertyFromClass('flixel.FlxG', 'keys.pressed.P') then
      moveValue = moveValue + 1;
   end
   
   setTextString('moveVal', 'Move Value: ' .. moveValue);
   --Cam goes back to normal.
   dadCurAnim = getProperty('dad.animation.curAnim.name');
   bfCurAnim = getProperty('boyfriend.animation.curAnim.name');
   
   if bfCurAnim == 'idle' and mustHitSection and canFollow then
      triggerEvent('Camera Follow Pos', bfCamX, bfCamY);
   end
   
   if dadCurAnim == 'idle' and not mustHitSection and canFollow then
      triggerEvent('Camera Follow Pos', dadCamX, dadCamY);
   end
end



function onEvent(name, value1)
   if name == 'Change Character' then
      if value1 == 'dad' then
         dadCamOffset = getProperty('opponentCameraOffset');
         dadCamPos = getProperty('dad.cameraPosition')
   
         dadCamX = getMidpointX('dad') + 150 + dadCamPos[1] + dadCamOffset[1];
         dadCamY = getMidpointY('dad') - 100 + dadCamPos[2] + dadCamOffset[2];
	  elseif value1 == 'bf' then
         bfCamOffset = getProperty('boyfriendCameraOffset');
         bfCamPos = getProperty('boyfriend.cameraPosition');
   
         bfCamX = getMidpointX('boyfriend') - 100 - bfCamPos[1] + bfCamOffset[1];
         bfCamY = getMidpointY('boyfriend') - 100 + bfCamPos[2] + bfCamOffset[2];
	  end
   end
end
