function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'PlayableGFV2'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'GFDie'); --put in mods/sounds/
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
end