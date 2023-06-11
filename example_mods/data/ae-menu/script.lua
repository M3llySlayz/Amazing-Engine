local StoryPos = {150, 100}

local FreeplayPos = {160, 260}

local CreditsPos = {160, 420}

local select = 0

local lock = false

function onCreate()
	if songName == 'ae-menu' then
		setProperty('skipCountdown', true)
		precacheMusic(getPropertyFromClass('ClientPrefs', 'mainSong'))
		precacheSound('ui sfx/'..getPropertyFromClass('ClientPrefs', 'sfxPreset')..'/scrollMenu')
		precacheSound('ui sfx/'..getPropertyFromClass('ClientPrefs', 'sfxPreset')..'/confirmMenu')
		precacheSound('ui sfx/'..getPropertyFromClass('ClientPrefs', 'sfxPreset')..'/cancelMenu')
	end
end

function onCreatePost()

if songName == 'ae-menu' then 

--this is for making the default stuff invisible
if getPropertyFromClass('ClientPrefs', 'sfxPreset') ~= null then
	playMusic('menu songs/'..getPropertyFromClass('ClientPrefs', 'sfxPreset')..'Freaky')
else
	playMusic('menu songs/Freaky')
end
	setProperty('timeTxt.visible', false)
	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
	setProperty('healthBar.visible', false)
	setProperty('healthBarBG.visible', false)
	setProperty('scoreTxt.visible', false)
	setProperty('boyfriend.visible', false)
	setProperty('gf.visible', false)
	setProperty('dad.visible', false)
	setProperty('timeBar.visible', false)
	
	--menu background
	makeLuaSprite('menuBG', 'mainmenu/menuBG', 0, 0);
	scaleObject('menuBG', 1.5, 1.5)
	setScrollFactor('menuBG', 0, 0);
	setObjectCamera('menuBG', 'hud');
	screenCenter('menuBG');
	baseY = getProperty('menuBG.y')
	setProperty('menuBG.y', baseY - 100)
	addLuaSprite('menuBG', true)
	--addGlitchEffect('menuBG', 2, 1.9)

	makeLuaSprite('anchor', '', 0, -1000);

	--storymode asset
	makeAnimatedLuaSprite('story', 'mainmenu/menu_story_mode', StoryPos[1] + 25, StoryPos[2]);
	scaleObject('story', 1, 1);
	addAnimationByPrefix('story', 'basicWOW', 'story_mode basic', 24, true);
	addAnimationByPrefix('story', 'whiteWOW', 'story_mode white', 24, true);
	addLuaSprite('story', true);
	setObjectCamera('story', 'hud');
	setProperty('story.scale.x', 0.75)
	setProperty('story.scale.y', 0.75)
	setProperty('story.y', StoryPos[2] - 25)
	objectPlayAnimation('story', 'whiteWOW', true);

	--freeplay asset
	makeAnimatedLuaSprite('freeplay', 'mainmenu/menu_freeplay', FreeplayPos[1] - 50, FreeplayPos[2]);
	scaleObject('freeplay', 1, 1);
	addAnimationByPrefix('freeplay', 'basic', 'freeplay basic', 24, true);
	addAnimationByPrefix('freeplay', 'white', 'freeplay white', 24, true);
	addLuaSprite('freeplay', true);
	setObjectCamera('freeplay', 'hud');
	objectPlayAnimation('freeplay', 'basic', true);

	--credits asset
	makeAnimatedLuaSprite('credits', 'mainmenu/menu_credits', CreditsPos[1] - 50, CreditsPos[2]);
	scaleObject('credits', 1, 1);
	addAnimationByPrefix('credits', 'basic', 'credits basic', 24, true);
	addAnimationByPrefix('credits', 'white', 'credits white', 24, true);
	addLuaSprite('credits', true);
	setObjectCamera('credits', 'hud');
	objectPlayAnimation('credits', 'basic', true);

	--you can add more if you want by the way

	--this is for making all the notes disappear (im too stupid to use for loops)
	a = 0
	repeat
	noteTweenAlpha('alphaTween'..a, a, 0, 0.01, cubeInOut)
	a = a + 1
	until (a == 8)

	selectChange()
	end
end

--function onStartCountdown()
--if songName == 'menu' then 
--for some reason this disables pausing? im not sure why
--if you want to test things make sure you disable this or else you'll have to restart the engine all the time
--playMusic('mainMenu\freakyMenu', 0.8, true)
--end
--end

function onUpdate()

	if songName == 'menu' then 

		if lock == false then
			--when enter pressed
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') then
				playSound('ui sfx/'..getPropertyFromClass('ClientPrefs', 'sfxPreset')..'/confirmMenu')
				if select == 0 then
					doTweenZoom('storyZoom', 'camHUD', 5, 0.5, 'quadOut')
					--loadSong shat out on me for some reason
					runHaxeCode('MusicBeatState.switchState(new StoryMenuState());')
					lock = true
					debugPrint('Loading into Story Mode...')
				elseif select == 1 then
					doTweenZoom('freeplayZoom', 'camHUD', 5, 0.5, 'quadOut')
					--loadSong shat out on me for some reason
					runHaxeCode('MusicBeatState.switchState(new FreeplayCategoryState());')
					lock = true
					debugPrint('Loading into Freeplay...')
				elseif select == 2 then
					doTweenZoom('storyZoom', 'camHUD', 5, 0.5, 'quadOut')
					--loadSong shat out on me for some reason
					runHaxeCode('MusicBeatState.switchState(new CreditsState());')
					lock = true
					debugPrint('Loading into Credits...')
				end
			end

			--when up pressed
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.UP') then
				select = select - 1
				if select < 0 then
					select = 2
				end
				selectChange()
			end

			--when down pressed (these are all self-explanatory)
			if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.DOWN') then
				select = select + 1
				if select > 2 then
					select = 0
				end
				selectChange()
			end
		end
	end
end

--this is the function for when you press up or down to change and animate the buttons
function selectChange()

	doTweenY('moveBG', 'menuBG', baseY + (select - 1) * 100, 0.5, 'circInOut')

	playSound('ui sfx/'..getPropertyFromClass('ClientPrefs', 'sfxPreset')..'/scrollMenu')

	if select == 0 then
		objectPlayAnimation('story', 'whiteWOW', true);
		setProperty('story.scale.x', 0.75)
		setProperty('story.scale.y', 0.75)
		doTweenX('moveStory', 'story', StoryPos[1], 0.5, 'circInOut')
		--setProperty('story.x', StoryPos[1] - 75)
		setProperty('story.y', StoryPos[2] - 25)
	else
		objectPlayAnimation('story', 'basicWOW', true);
		setProperty('story.scale.x', 1)
		setProperty('story.scale.y', 1)
		doTweenX('moveStory2', 'story', StoryPos[1] - 50, 0.5, 'circInOut')
		--setProperty('story.x', StoryPos[1] - 50)
		setProperty('story.y', StoryPos[2])
	end

	if select == 1 then
		objectPlayAnimation('freeplay', 'white', true);
		setProperty('freeplay.scale.x', 0.75)
		setProperty('freeplay.scale.y', 0.75)
		doTweenX('moveFreeplay', 'freeplay', FreeplayPos[1], 0.5, 'circInOut')
		--setProperty('freeplay.x', FreeplayPos[1] - 75)
		setProperty('freeplay.y', FreeplayPos[2] - 25)
	else
		objectPlayAnimation('freeplay', 'basic', true);
		setProperty('freeplay.scale.x', 1)
		setProperty('freeplay.scale.y', 1)
		doTweenX('moveFreeplay2', 'freeplay', FreeplayPos[1]-50, 0.5, 'circInOut')
		--setProperty('freeplay.x', FreeplayPos[1] - 50)
		setProperty('freeplay.y', FreeplayPos[2])
	end

	if select == 2 then
		objectPlayAnimation('credits', 'white', true);
		setProperty('credits.scale.x', 0.75)
		setProperty('credits.scale.y', 0.75)
		doTweenX('moveCredits', 'credits', CreditsPos[1], 0.5, 'circInOut')
		--setProperty('credits.x', CreditsPos[1] - 75)
		setProperty('credits.y', CreditsPos[2] - 25)
	else
		objectPlayAnimation('credits', 'basic', true);
		setProperty('credits.scale.x', 1)
		setProperty('credits.scale.y', 1)
		doTweenX('moveCredits2', 'credits', CreditsPos[1]-50, 0.5, 'circInOut')
		--setProperty('credits.x', CreditsPos[1] - 50)
		setProperty('credits.y', CreditsPos[2])
	end
end