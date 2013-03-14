package com.cp.sf 
{
	import net.flashpunk.Sfx;
	
	/**
	 * Container for Embedded Sounds and Sound Related Static Functions
	 */
	public final class SoundManager 
	{
		/**
		 * MUSIC EMBEDS
		 */
		
		[Embed(source="../../../../assets/music/title.mp3")]
		public static const MUSIC_TITLE:Class;
		
		/**
		 * SOUND EFFECT EMBEDS
		 */
		
		[Embed(source = "../../../../assets/sfx/title-gunshot.mp3")]
		public static const SFX_TITLE_GUNSHOT:Class;
		
		/**
		 * MUSIC INSTNANTIATIONS
		 */

		public static var music_title:Sfx = new Sfx(MUSIC_TITLE);		
		
		
		private static var _currentMusic:Sfx;

		public static function get currentMusic():Sfx
		{
			return _currentMusic;
		}

		public static function set currentMusic(music:Sfx):void
		{
			if(_currentMusic != music)
			{
				if(_currentMusic) _currentMusic.stop();
				_currentMusic = music;
				_currentMusic.volume = GV.volumeMusic;
				_currentMusic.loop(GV.volumeMusic);
			}
		}

		public static function playSound(sound:Class, pan:Number=0, callback:Function=null):void
		{
			var s:Sfx = new Sfx(sound, callback);
			s.play(GV.volumeSound, pan);
		}
		
	}

}