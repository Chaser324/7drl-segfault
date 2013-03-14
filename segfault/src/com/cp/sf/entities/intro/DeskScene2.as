package com.cp.sf.entities.intro 
{
	import com.cp.sf.GFX;
	import com.cp.sf.SoundManager;
	import com.cp.sf.worlds.IntroWorld;
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
		private var loopCount:int = 0;
		
		public function DeskScene2() 
		{
			bubble = new Spritemap(GFX.GFX_INTRO_SLEEP_BUBBLE, 72, 66);
			bubble.add("inhale", [1], 0, false);
			bubble.add("exhale", [0], 0, false);
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
			
			inhale();
		}
		
		private function inhale():void
		{
			bubble.play("inhale");
			SoundManager.playSound(SoundManager.SFX_INTRO_INHALE,0, exhale);
		}
		
		private function exhale():void
		{
			++loopCount;
			if (loopCount < 2)
			{
				bubble.play("exhale");
				SoundManager.playSound(SoundManager.SFX_INTRO_EXHALE, 0, inhale);
			}
			else
			{
				IntroWorld(FP.world).nextScene();
			}
		}
		
	}

}