package com.cp.sf.entities.title 
{
	import com.cp.sf.GFX;
	import com.cp.sf.Utils;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import punk.fx.effects.GlitchFX;
	import punk.fx.graphics.FXText;
	
	/**
	 * ...
	 * @author 
	 */
	public class AboutScreen extends Entity 
	{
		protected var textFont:Class = GFX.GFX_FONT_COURIER;
		
		protected var bg:Image;
		protected var aboutTextBox:FXText;
		
		protected var glitchTimer:Timer;
		protected var glitchEffect:GlitchFX;
		
		public function AboutScreen() 
		{
			bg = new Image(new BitmapData(800, 600, false, 0xFF000000));
			this.addGraphic(bg);
			
			Text.font = "Courier";
			Text.size = 13;
			
			var b:ByteArray = new GFX.GFX_TEXT_ABOUT;
			var s:String = b.readUTFBytes(b.length);
			
			aboutTextBox = new FXText(s, 55, 40);
			aboutTextBox.wordWrap = true;
			aboutTextBox.width = 700;
			
			glitchEffect = new GlitchFX(0, 5, 1);
			aboutTextBox.effects.add(glitchEffect);
			
			this.addGraphic(aboutTextBox);
			
			super();
		}
		
		public function show():void
		{
			glitchEffect.maxSlide = 25;
			glitchTimer = new Timer(500);
			glitchTimer.addEventListener(TimerEvent.TIMER, stopGlitch);
			glitchTimer.start();			
		}
		
		private function stopGlitch(e:TimerEvent):void
		{
			glitchEffect.maxSlide = 0;
			glitchTimer = null;
		}
		
	}

}