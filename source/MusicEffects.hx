package;

import flixel.FlxG;

class MusicEffects {
    /**
        *The main function for playing music in Amazing Engine.
        *
        * @param    music   What type of song you're playing. You may choose from `menu`, `pause`, or `game over`.
        * @param    volume  The volume of the song, obviously.
        * @param    end     For game overs, whether you want the file for the confirmation.
    **/
    public static function playMusic(music:String, volume:Int, end:Bool = false){
        var normie = false;
        if (ClientPrefs.sfxPreset == 'Default') normie = true;
        switch (music){
            case 'menu':
                if (normie){
                    FlxG.sound.playMusic(Paths.music('menu songs' + ClientPrefs.mainSong), volume);
                } else {
                    FlxG.sound.playMusic(Paths.music('menu songs' + ClientPrefs.sfxPreset + '/' + ClientPrefs.mainSong), volume);
                }
            case 'pause':
                if (normie){
                    FlxG.sound.playMusic(Paths.music('pause songs' + ClientPrefs.pauseMusic), volume);
                } else {
                    FlxG.sound.playMusic(Paths.music('pause songs' + ClientPrefs.sfxPreset + '/' + ClientPrefs.pauseMusic), volume);
                }
            case 'game over':
                if (!end){
                    if (normie){
                        FlxG.sound.playMusic(Paths.music('death songs' + ClientPrefs.gameOverSong), volume);
                    } else {
                        FlxG.sound.playMusic(Paths.music('death songs' + ClientPrefs.sfxPreset + '/' + ClientPrefs.gameOverSong), volume);
                    }
                } else {
                    if (normie){
                        FlxG.sound.playMusic(Paths.music('death songs' + ClientPrefs.gameOverSong + '-End'), volume);
                    } else {
                        FlxG.sound.playMusic(Paths.music('death songs' + ClientPrefs.sfxPreset + '/' + ClientPrefs.gameOverSong + '-End'), volume);
                    }
                }
        }
    }
}