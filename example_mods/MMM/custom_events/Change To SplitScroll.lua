function onEvent(name, value1, value2)
    noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') + 250),3,"backOut")
    noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') + 250),3,"backOut")
    noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') + 250),3,"backOut")
    noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') + 250),3,"backOut")
    
    function onStepHit()
        if curStep == 32 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') + 250),3,"backOut")
            noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') + 250),3,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') - 250),3,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') - 250),3,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',true) 
            setPropertyFromGroup('playerStrums',1,'downScroll',true) 
        end
        
        if curStep == 96 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') - 500),3,"backOut")
            noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') - 500),3,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') + 500),3,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') + 500),3,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',false) 
            setPropertyFromGroup('playerStrums',1,'downScroll',false)
            setPropertyFromGroup('playerStrums',2,'downScroll',true) 
            setPropertyFromGroup('playerStrums',3,'downScroll',true) 
        end

        if curStep == 128 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') + 500),3,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') - 500),3,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',true) 
            setPropertyFromGroup('playerStrums',2,'downScroll',false) 
        end

        if curStep == 192 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') - 500),3,"backOut")
            noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') + 500),3,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') + 500),3,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') - 500),3,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',false) 
            setPropertyFromGroup('playerStrums',1,'downScroll',true)
            setPropertyFromGroup('playerStrums',2,'downScroll',true) 
            setPropertyFromGroup('playerStrums',3,'downScroll',false) 
        end

        if curStep == 224 then
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') - 500),3,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') + 500),3,"backOut")
            setPropertyFromGroup('playerStrums',2,'downScroll',false) 
            setPropertyFromGroup('playerStrums',3,'downScroll',true) 
        end

        if curStep == 384 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') + 250),3,"backOut")
            noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') - 250),3,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') + 250),3,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') - 250),3,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',false) 
            setPropertyFromGroup('playerStrums',1,'downScroll',false)
            setPropertyFromGroup('playerStrums',2,'downScroll',false) 
            setPropertyFromGroup('playerStrums',3,'downScroll',false) 
        end

        if curStep == 416 then
            noteTweenX("x5",4,(getPropertyFromGroup('strumLineNotes', 4, 'x') + 350),1.5,"backOut")
            noteTweenX("x8",7,(getPropertyFromGroup('strumLineNotes', 7, 'x') - 350),1.5,"backOut")
            setProperty('botplayTxt.y', (getPropertyFromGroup('strumLineNotes', 4, 'y') + 250))
            setTextString('botplayTxt', 'Melly\'s gonna hate me lmao')
            setProperty('botplayTxt.visible', true)
        end

        if curStep == 432 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') - 250),1.5,"backOut")
            noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') - 250),1.5,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') - 250),1.5,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') - 250),1.5,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',false) 
            setPropertyFromGroup('playerStrums',1,'downScroll',false)
            setPropertyFromGroup('playerStrums',2,'downScroll',false) 
            setPropertyFromGroup('playerStrums',3,'downScroll',false) 
        end

        if curStep == 448 then
            setProperty('botplayTxt.visible', false)
        end

        if curStep == 736 then
            setPropertyFromGroup('playerStrums',0,'downScroll',true) 
            setPropertyFromGroup('playerStrums',1,'downScroll',true)
            setPropertyFromGroup('playerStrums',2,'downScroll',true) 
            setPropertyFromGroup('playerStrums',3,'downScroll',true) 
        end

        if curStep == 1024 then
            noteTweenX("x6",5,(getPropertyFromGroup('strumLineNotes', 5, 'x') + 125),1.5,"backOut")
            noteTweenX("x7",6,(getPropertyFromGroup('strumLineNotes', 6, 'x') - 125),1.5,"backOut")
            setTextString('botplayTxt', 'I\'m not done with you yet.')
            setProperty('botplayTxt.visible', true)
        end

        if curStep == 1056 then
            setProperty('botplayTxt.visible', false)
        end

        if curStep == 1152 then
            noteTweenAngle("r6",5,180,1.5,"backOut")
            noteTweenAngle("r7",6,180,1.5,"backOut")
            setTextString('botplayTxt', 'Now I\'m done :)')
            setProperty('botplayTxt.visible', true)
        end

        if curStep == 1184 then
            noteTweenX("x5",4,(getPropertyFromGroup('strumLineNotes', 4, 'x') - 350),1.5,"backOut")
            noteTweenX("x8",7,(getPropertyFromGroup('strumLineNotes', 7, 'x') + 350),1.5,"backOut")
            setProperty('botplayTxt.visible', false)
        end

        if curStep == 1216 then
            noteTweenY("y5",4,(getPropertyFromGroup('strumLineNotes', 4, 'y') - 500),1.5,"backOut")
            noteTweenY("y6",5,(getPropertyFromGroup('strumLineNotes', 5, 'y') - 500),1.5,"backOut")
            noteTweenY("y7",6,(getPropertyFromGroup('strumLineNotes', 6, 'y') - 500),1.5,"backOut")
            noteTweenY("y8",7,(getPropertyFromGroup('strumLineNotes', 7, 'y') - 500),1.5,"backOut")
            setPropertyFromGroup('playerStrums',0,'downScroll',false) 
            setPropertyFromGroup('playerStrums',1,'downScroll',false)
            setPropertyFromGroup('playerStrums',2,'downScroll',false) 
            setPropertyFromGroup('playerStrums',3,'downScroll',false) 
        end

        if curStep == 1280 then
            noteTweenX("x6",5,(getPropertyFromGroup('strumLineNotes', 5, 'x') - 125),1.5,"backOut")
            noteTweenX("x7",6,(getPropertyFromGroup('strumLineNotes', 6, 'x') + 125),1.5,"backOut")
        end
        
        if curStep == 1376 then
            noteTweenAngle("r6",5,0,1.5,"backOut")
            noteTweenAngle("r7",6,0,1.5,"backOut")
        end
    end
end