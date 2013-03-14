package com.cp.sf.entities.intro 
{
	import com.cp.sf.worlds.IntroWorld;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import punk.fx.effects.GlitchFX;
	import punk.fx.effects.ScanLinesFX;
	import punk.fx.graphics.FXImage;
	
	/**
	 * ...
	 * @author 
	 */
	public class IntroText extends Entity 
	{
		protected var bg:FXImage;
		protected var fg:FXImage;
		
		protected var glitchTimerBg:Timer;
		protected var glitchTimerFg:Timer;
		
		protected var glitchEffectBg:GlitchFX;
		protected var glitchEffectFg:GlitchFX;
		protected var noiseEffect:ScanLinesFX;
		
		public function IntroText(bgSrc:Class, fgSrc:Class)
		{
			this.bg = new FXImage(bgSrc);
			this.fg = new FXImage(fgSrc);
			
			addGraphic(this.bg);
			addGraphic(this.fg);
			
			glitchEffectBg = new GlitchFX(20, 5, 1);
			bg.effects.add(glitchEffectBg);
			
			glitchEffectFg = new GlitchFX(20, 5, 1);
			fg.effects.add(glitchEffectFg);
			
			noiseEffect = new ScanLinesFX(true, 25);
			bg.effects.add(noiseEffect);
			
			glitchTimerBg = new Timer(300, 1);
			glitchTimerBg.addEventListener(TimerEvent.TIMER, stopBgGlitch);
			
			glitchTimerFg = new Timer(500, 1);
			glitchTimerFg.addEventListener(TimerEvent.TIMER, stopFgGlitch);
			
			glitchTimerBg.start();
			glitchTimerFg.start();	
		}
		
		private function stopBgGlitch(e:TimerEvent):void
		{
			glitchEffectBg.maxSlide = 0;
			glitchTimerBg = null;
		}
		
		private function stopFgGlitch(e:TimerEvent):void
		{
			glitchEffectFg.maxSlide = 0;
			
			glitchTimerFg = new Timer(1500, 1);
			glitchTimerFg.addEventListener(TimerEvent.TIMER, nextScene);
			glitchTimerFg.start();
		}
		
		private function nextScene(e:TimerEvent):void
		{
			IntroWorld(FP.world).nextScene();
		}
		
	}

}