package com.cp.sf.worlds 
{
	import com.cp.sf.entities.title.AboutScreen;
	import com.cp.sf.entities.title.TitleButton;
	import com.cp.sf.GFX;
	import com.cp.sf.SoundManager;
	import com.cp.sf.Utils;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import punk.fx.effects.FX;
	import punk.fx.effects.GlitchFX;
	import punk.fx.graphics.FXImage;
	
	/**
	 * ...
	 * @author 
	 */
	public class TitleWorld extends World 
	{
		protected var overlay:Image;
		protected var bg:FXImage;
		protected var title:FXImage;
		protected var fadeOut:Image;
		
		protected var titleTimer:Timer;
		protected var bgTimer:Timer;
		protected var shootTimer:Timer;
		
		protected var startButton:TitleButton;
		protected var aboutButton:TitleButton;
		protected var optionsButton:TitleButton;
		protected var backButton:TitleButton;
		
		protected var aboutScreen:AboutScreen;
		
		protected var titleGlitch:GlitchFX;
		protected var bgGlitch:GlitchFX;
		
		protected var shotsFired:int = 0;
		
		protected var fadeTween:VarTween;
		protected var soundFadeTween:VarTween;
		
		public function TitleWorld() 
		{
			overlay = new Image(GFX.GFX_MENU_OVERLAY);
			bg = new FXImage(GFX.GFX_TITLE_BG);
			title = new FXImage(GFX.GFX_TITLE_HEADING);
			title.x = 132;
			title.y = 122;
			
			addGraphic(overlay, 1);
			addGraphic(title, 9);
			addGraphic(bg, 10);
			
			titleGlitch = new GlitchFX(0,5,1);
			title.effects.add(titleGlitch);
			
			bgGlitch = new GlitchFX(0, 5, 1);
			bg.effects.add(bgGlitch);
			
			startButton = new TitleButton(251, 297, GFX.GFX_TITLE_START_BUTTON, 313, 38, startGame);
			startButton.layer = 8;
			this.add(startButton);
			
			aboutButton = new TitleButton(251, 412, GFX.GFX_TITLE_ABOUT_BUTTON, 313, 38, aboutButtonClicked);
			aboutButton.layer = 8;
			this.add(aboutButton);
			
			optionsButton = new TitleButton(251, 354, GFX.GFX_TITLE_OPTIONS_BUTTON, 313, 38, null);
			optionsButton.layer = 8;
			this.add(optionsButton);
			
			backButton = new TitleButton(670, 40, GFX.GFX_TITLE_BACK, 68, 30, closeScreen);
			backButton.layer = 6;
			this.add(backButton);
			backButton.visible = false;
			
			aboutScreen = new AboutScreen();
			aboutScreen.layer = 7;
			this.add(aboutScreen);
			aboutScreen.visible = false;
			
			titleTimer = new Timer(Utils.randomRange(4000,6000));
			titleTimer.addEventListener(TimerEvent.TIMER, glitchTitle);
			titleTimer.start();
			
			bgTimer = new Timer(Utils.randomRange(2000,5000));
			bgTimer.addEventListener(TimerEvent.TIMER, glitchBg);
			bgTimer.start();
			
			SoundManager.currentMusic = SoundManager.music_title;
		}
		
		override public function end():void
		{
			this.removeAll();
			super.end();
		}
		
		override public function update():void
		{
			if (Input.pressed("back"))
			{
				closeScreen();
			}
			
			super.update();
		}
		
		public function startGame():void
		{
			fireShot(null);
			startButton.active = false;
			optionsButton.active = false;
			aboutButton.active = false;
		}
		
		public function closeScreen():void
		{
			if (aboutScreen.visible) 
			{
				aboutScreen.visible = false;
				backButton.visible = false;
			}
		}
		
		public function aboutButtonClicked():void
		{
			aboutScreen.visible = true;
			aboutScreen.show();
			
			backButton.visible = true;
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
		
		private function fireShot(e:TimerEvent):void
		{
			SoundManager.playSound(SoundManager.SFX_TITLE_GUNSHOT);
			Utils.flash.start(0xFFFFFF, 0.05);
			
			switch(shotsFired)
			{
				case 0:
					addGraphic(new Image(GFX.GFX_TITLE_GUNSHOT1), 0, 300, 60);
					break;
				case 1:
					addGraphic(new Image(GFX.GFX_TITLE_GUNSHOT2), 0, 60, 250);
					break;
				case 2:
					addGraphic(new Image(GFX.GFX_TITLE_GUNSHOT3), 0, 550, 370);
					break;
				default:
					break;
			}
			
			switch(shotsFired)
			{
				case 0:
				case 1:
					++shotsFired;
					
					shootTimer = new Timer(200, 1);
					shootTimer.addEventListener(TimerEvent.TIMER, fireShot);
					shootTimer.start();
					
					break;
				case 2:
				default:
					shootTimer = null;
					fadeOut = new Image(new BitmapData(800, 600, false, 0xFF000000));
					fadeOut.alpha = 0;
					addGraphic(fadeOut, -1);
					
					this.clearTweens();
					fadeTween = new VarTween();
					fadeTween.tween(fadeOut, "alpha", 1.0, 1.5, Ease.quadIn);
					this.addTween(fadeTween);
					
					soundFadeTween = new VarTween(nextWorld);
					soundFadeTween.tween(SoundManager.currentMusic, "volume", 0, 1.5, Ease.quadIn);
					this.addTween(soundFadeTween);
			
					break;
			}
		}
		
		private function nextWorld():void
		{
			FP.world = new GameWorld();
		}
	}

}