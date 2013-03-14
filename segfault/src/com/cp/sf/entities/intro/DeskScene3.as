package com.cp.sf.entities.intro 
{
	import com.cp.sf.GFX;
	import com.cp.sf.SoundManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author 
	 */
	public class DeskScene3 extends Entity 
	{
		private var bubble:Spritemap;
		private var screen:Image;;
		private var loopCount:int = 0;
		
		private var vibeTimer:Timer;
		
		public function DeskScene3() 
		{
			bubble = new Spritemap(GFX.GFX_INTRO_SLEEP_BUBBLE, 72, 66);
			bubble.add("anim", [0, 1], 2, true);
			bubble.x = 450;
			bubble.y = 290;
			
			screen = new Image(GFX.GFX_INTRO_SCREEN_3);
			screen.x = 294;
			screen.y = 318;
			
			addGraphic(new Image(GFX.GFX_INTRO_DESK));
			addGraphic(new Image(GFX.GFX_INTRO_KEYBOARD));
			addGraphic(new Image(GFX.GFX_INTRO_MONITOR_3));
			addGraphic(screen);
			addGraphic(bubble);
			addGraphic(new Image(GFX.GFX_INTRO_PERSON_2));
			
			vibeTimer = new Timer(2000, 0);
			vibeTimer.addEventListener(TimerEvent.TIMER, playVibe);
			
			bubble.play("anim");
			vibeTimer.start();
		}
		
		public function stop():void
		{
			vibeTimer.stop();
			vibeTimer = null;
		}
		
		private function playVibe(e:TimerEvent):void
		{
			SoundManager.playSound(SoundManager.SFX_PHONE_VIBRATE);
		}
		
	}

}