function onStepHit()
	if curStep==1056 then
	setProperty('camHUD.visible', false);
	end
	if curStep ==1198 then
	setProperty('camHUD.visible', true);
	end
	if curStep==1472 then
 	setProperty('camHUD.visible', false);
	end
end

function onBeatHit()
	if curBeat ==132 then
	setProperty('camHUD.visible', false);
	end
	if curBeat ==163 then
	setProperty('camHUD.visible', true);
	end
end