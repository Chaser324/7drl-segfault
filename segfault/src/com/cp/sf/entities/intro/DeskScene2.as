package com.cp.sf.entities.intro 
{
	import com.cp.sf.GFX;
	import com.cp.sf.SoundManager;
	import com.cp.sf.worlds.IntroWorld;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author 
	 */
	public class DeskScene2 extends Entity 
	{
		private var bubble:Spritemap;
		private var screenAnim:Spritemap;
		
		private var endTimer:Timer;
		
		public function DeskScene2() 
		{
			bubble = new Spritemap(GFX.GFX_INTRO_SLEEP_BUBBLE, 72, 66);
			bubble.add("anim", [0, 1], 2, true);
			bubble.x = 450;
			bubble.y = 290;
			
			screenAnim = new Spritemap(GFX.GFX_INTRO_SCREEN_2, 166, 88);
			screenAnim.add("anim", [0, 1, 2, 3, 4, 5], 5, true);
			screenAnim.play("anim");
			screenAnim.x = 294;
			screenAnim.y = 318;
			
			addGraphic(new Image(GFX.GFX_INTRO_DESK));
			addGraphic(new Image(GFX.GFX_INTRO_KEYBOARD));
			addGraphic(new Image(GFX.GFX_INTRO_MONITOR_2));
			addGraphic(screenAnim);
			addGraphic(bubble);
			addGraphic(new Image(GFX.GFX_INTRO_PERSON_2));
			
			bubble.play("anim");
			
			endTimer = new Timer(3000, 1);
			endTimer.addEventListener(TimerEvent.TIMER, nextScene);
			endTimer.start();
		}
		
		private function nextScene(e:TimerEvent):void
		{
			endTimer = null;
			IntroWorld(FP.world).nextScene();
		}
		
	}

}