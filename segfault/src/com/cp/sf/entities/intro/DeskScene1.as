package com.cp.sf.entities.intro 
{
	import com.cp.sf.GFX;
	import com.cp.sf.worlds.IntroWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	
	/**
	 * ...
	 * @author 
	 */
	public class DeskScene1 extends Entity 
	{
		protected var head:Image;
		
		protected var headTween:VarTween;
		
		protected var screenAnim:Spritemap;
		protected var animCount:int = 0;
		
		public function DeskScene1() 
		{
			head = new Image(GFX.GFX_INTRO_PERSON_1_HEAD);
			
			headTween = new VarTween(reverseHeadTween);
			headTween.tween(head, "x", -10, 0.25);
			this.addTween(headTween);
			
			screenAnim = new Spritemap(GFX.GFX_INTRO_SCREEN_1, 166, 88, nextScene);
			screenAnim.add("anim1", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 7, false);
			screenAnim.add("anim2", [9, 10, 11, 12], 7, false);
			screenAnim.x = 294;
			screenAnim.y = 318;
		
			addGraphic(new Image(GFX.GFX_INTRO_DESK));
			addGraphic(new Image(GFX.GFX_INTRO_KEYBOARD));
			addGraphic(new Image(GFX.GFX_INTRO_MONITOR_1));
			addGraphic(screenAnim);
			addGraphic(new Image(GFX.GFX_INTRO_PERSON_1));
			addGraphic(head);
			
			screenAnim.play("anim1");
		}
		
		private function reverseHeadTween():void
		{
			this.clearTweens();
			
			headTween = new VarTween(resetHeadTween);
			headTween.tween(head, "x", 0, 0.25);
			addTween(headTween);
		}
		
		private function resetHeadTween():void
		{
			this.clearTweens();
			
			headTween = new VarTween(reverseHeadTween);
			headTween.tween(head, "x", -10, 0.3);
			addTween(headTween);
		}
		
		private function nextScene():void
		{
			++animCount;
			if (animCount > 2)
			{
				IntroWorld(FP.world).nextScene();
			}
			else
			{
				screenAnim.play("anim2", true);
			}
		}
		
	}

}