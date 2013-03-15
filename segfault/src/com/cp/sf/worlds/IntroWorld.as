package com.cp.sf.worlds 
{
	import com.cp.sf.entities.intro.DeskScene1;
	import com.cp.sf.entities.intro.DeskScene2;
	import com.cp.sf.entities.intro.DeskScene3;
	import com.cp.sf.entities.intro.IntroText;
	import com.cp.sf.GFX;
	import com.cp.sf.SoundManager;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author 
	 */
	public class IntroWorld extends World 
	{
		private var introText:IntroText;
		private var deskScene1:DeskScene1;
		private var deskScene2:DeskScene2;
		private var deskScene3:DeskScene3;
		
		protected var fadeOut:Image;
		
		protected var fadeTween:VarTween;
		protected var soundFadeTween:VarTween;
		
		private var scene:int = 0;
		
		public function IntroWorld(scene:int = 0) 
		{
			this.scene = scene - 1;
		}
		
		override public function begin():void
		{
			nextScene();
		}
		
		override public function end():void
		{
			this.removeAll();
			super.end();
		}
		
		override public function update():void
		{
			super.update();
		}
		
		public function nextScene():void
		{
			++scene;
			
			switch (scene)
			{
				case 0:
					introText = new IntroText(GFX.GFX_INTRO_TEXT0_BG, GFX.GFX_INTRO_TEXT0_FG);
					this.add(introText);
					SoundManager.currentMusic = SoundManager.music_intro;
					break;
				case 1:
					this.remove(introText);
					
					deskScene1 = new DeskScene1();
					this.add(deskScene1);
					
					break;
				case 2:
					this.remove(deskScene1);
					
					introText = new IntroText(GFX.GFX_INTRO_TEXT1_BG, GFX.GFX_INTRO_TEXT1_FG);
					this.add(introText);
					
					break;
				case 3:
					this.remove(introText);
					
					//SoundManager.currentMusic.stop();
					
					deskScene2 = new DeskScene2();
					this.add(deskScene2);
					
					break;
				case 4:
					this.remove(deskScene2);
					
					//SoundManager.currentMusic.play();
					
					introText = new IntroText(GFX.GFX_INTRO_TEXT2_BG, GFX.GFX_INTRO_TEXT2_FG);
					this.add(introText);
					
					break;
				case 5:
					this.remove(introText);
					
					SoundManager.currentMusic.stop();
					
					FP.world = new CharCreateWorld();
					
					break;
				case 6:
					introText = new IntroText(GFX.GFX_INTRO_TEXT3_BG, GFX.GFX_INTRO_TEXT3_FG);
					this.add(introText);
					SoundManager.currentMusic = SoundManager.music_intro;
					SoundManager.currentMusic.play();
					break;
				case 7:
					this.remove(introText);
					
					deskScene3 = new DeskScene3();
					this.add(deskScene3);
					
					fadeOut = new Image(new BitmapData(800, 600, false, 0xFF000000));
					fadeOut.alpha = 0;
					addGraphic(fadeOut, -1);
					
					this.clearTweens();
					fadeTween = new VarTween(nextWorld);
					fadeTween.tween(fadeOut, "alpha", 1.0, 8, Ease.quadIn);
					this.addTween(fadeTween);
					
					soundFadeTween = new VarTween();
					soundFadeTween.tween(SoundManager.currentMusic, "volume", 0, 3, Ease.quadIn);
					this.addTween(soundFadeTween);
					
					break;
				default:
					break;
			}
		}
		
		private function nextWorld():void
		{
			deskScene3.stop();
			FP.world = new GameWorld();
		}
		
	}

}