package com.cp.sf.worlds 
{
	import com.cp.sf.entities.title.TitleButton;
	import com.cp.sf.GFX;
	import com.cp.sf.GV;
	import com.cp.sf.SoundManager;
	import com.cp.sf.Utils;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	import punk.fx.effects.GlitchFX;
	import punk.fx.effects.ScanLinesFX;
	import punk.fx.graphics.FXImage;
	import punk.fx.graphics.FXText;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameOverWorld extends World 
	{
		protected var textFont:Class = GFX.GFX_FONT_COURIER;
		
		protected var bg:FXImage;
		protected var heading:FXImage;
		protected var textbox:FXImage;
		protected var fadeOut:Image;
		
		protected var acceptButton:TitleButton;
		
		protected var t:TextField;
		protected var tf:TextFormat;
		protected var textBitmap:BitmapData;
				
		protected var fadeTween:VarTween;
		protected var soundFadeTween:VarTween;
		
		protected var titleGlitch:GlitchFX;
		protected var bgGlitch:GlitchFX;
		
		protected var titleTimer:Timer;
		protected var bgTimer:Timer;
		
		public function GameOverWorld() 
		{
			bg = new FXImage(GFX.GFX_GAMEOVER_BG);
			heading = new FXImage(GFX.GFX_GAMEOVER_HEADING);
			textbox = new FXImage(GFX.GFX_GAMEOVER_TEXTBOX);
			
			titleGlitch = new GlitchFX(0,5,1);
			heading.effects.add(titleGlitch);
			
			bgGlitch = new GlitchFX(0, 5, 1);
			bg.effects.add(bgGlitch);
			
			var fxScreen:FXImage = new FXImage();
			fxScreen.effects.add(new ScanLinesFX(true, 25));
			
			acceptButton = new TitleButton(254, 521, GFX.GFX_GAMEOVER_ACCEPT, 315, 38, restart);
			acceptButton.layer = 8;
			
			
			var text:String = "You descended " + GV.floors + " floors towards the AI mother brain in the basement and killed " + GV.kills + " of those electronic bastards before the robot uprising took your life.\n\n" +
			                  "Better luck next time, flesh bag!";
			
			textBitmap = new BitmapData(515, 100, true, 0);
			createTextfield(text);
			
			
			this.addGraphic(bg, 10);
			this.addGraphic(heading, 9, 44,130);
			this.addGraphic(textbox, 9, 128, 333);
			this.add(acceptButton);
			this.addGraphic(new Image(textBitmap), 9, 140, 350);
			this.addGraphic(fxScreen);
			
			titleTimer = new Timer(Utils.randomRange(4000,6000));
			titleTimer.addEventListener(TimerEvent.TIMER, glitchTitle);
			titleTimer.start();
			
			bgTimer = new Timer(Utils.randomRange(2000,5000));
			bgTimer.addEventListener(TimerEvent.TIMER, glitchBg);
			bgTimer.start();
			
			fadeOut = new Image(new BitmapData(800, 600, false, 0xFF000000));
			fadeOut.alpha = 1;
			addGraphic(fadeOut, -1);
			
			SoundManager.currentMusic = SoundManager.music_gameover;
			SoundManager.currentMusic.volume = 0;
			
			this.clearTweens();
			fadeTween = new VarTween();
			fadeTween.tween(fadeOut, "alpha", 0.0, 1.5, Ease.quadIn);
			this.addTween(fadeTween);
			
			soundFadeTween = new VarTween();
			soundFadeTween.tween(SoundManager.currentMusic, "volume", GV.volumeMusic, 1.5, Ease.quadIn);
			this.addTween(soundFadeTween);
		}
		
		private function createTextfield(text:String):void
		{
			tf = new TextFormat("Courier", 12, 0xeaeaea);
			tf.align = TextFormatAlign.CENTER;
			
			t = new TextField();
			t.defaultTextFormat = tf;
			t.embedFonts = true;
			t.width = 515;
			t.height = 100;
			t.text = text;
			t.multiline = true;
			t.wordWrap = true;
			
			textBitmap.draw(t);
		}
		
		private function glitchTitle(event:TimerEvent):void
		{
			if (titleGlitch.maxSlide == 0)
			{
				titleGlitch.maxSlide = Utils.randomRange(25, 45);
				titleTimer.delay = Utils.randomRange(500, 1500);
			}
			else
			{
				titleGlitch.maxSlide = 0;
				titleTimer.delay = Utils.randomRange(2000, 5000);
			}
			
			titleTimer.start();
		}
		
		private function glitchBg(event:TimerEvent):void
		{
			if (bgGlitch.maxSlide == 0)
			{
				bgGlitch.maxSlide = Utils.randomRange(15, 35);
				bgTimer.delay = Utils.randomRange(500, 1000);
			}
			else
			{
				bgGlitch.maxSlide = 0;
				bgTimer.delay = Utils.randomRange(4000, 6000);
			}
			
			bgTimer.start();
		}
		
		private function restart():void
		{
			SoundManager.playSound(SoundManager.SFX_TITLE_GUNSHOT);
			
			acceptButton.active = false;
			
			this.clearTweens();
			fadeTween = new VarTween();
			fadeTween.tween(fadeOut, "alpha", 1.0, 1.5, Ease.quadIn);
			this.addTween(fadeTween);
			
			soundFadeTween = new VarTween(goToTitle);
			soundFadeTween.tween(SoundManager.currentMusic, "volume", 0, 1.5, Ease.quadIn);
			this.addTween(soundFadeTween);
		}
		
		private function goToTitle():void
		{
			FP.world = new GameWorld();
		}
		
	}

}