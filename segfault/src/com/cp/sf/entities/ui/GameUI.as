package com.cp.sf.entities.ui 
{
	import com.cp.sf.GFX;
	import flash.display.BitmapData;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import punk.fx.graphics.FXImage;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameUI extends Entity 
	{
		protected var textFont:Class = GFX.GFX_FONT_COURIER;
		
		private var phone:Image
		
		private var health:FXImage;
		private var floor:FXImage;
		private var level:FXImage;
		private var experience:FXImage;
		
		protected var t:TextField;
		protected var tf:TextFormat;
		protected var textBitmap:BitmapData;
		
		public function GameUI() 
		{
			phone = new Image(GFX.GFX_UI_PHONE);
			phone.x = 8;
			phone.y = 258;
			phone.scrollX = 0;
			phone.scrollY = 0;
			addGraphic(phone);
		}
		
		public function updateHealth(val:int):void
		{
			if (health != null) Graphiclist(graphic).remove(health);
			
			textBitmap = new BitmapData(100, 30, true, 0);
			createTextfield("HP: " + val);
			health = new FXImage(textBitmap);
			health.x = 20;
			health.y = 380;
			health.scrollX = 0;
			health.scrollY = 0;
			
			addGraphic(health);
		}
		
		public function updateFloor(val:int):void
		{
			if (floor != null) Graphiclist(graphic).remove(floor);
			
			textBitmap = new BitmapData(100, 30, true, 0);
			createTextfield("FLOOR: " + (val + 1));
			floor = new FXImage(textBitmap);
			floor.x = 20;
			floor.y = 350;
			floor.scrollX = 0;
			floor.scrollY = 0;
			
			addGraphic(floor);
		}
		
		public function updateLevel(val:int):void
		{
			if (level != null) Graphiclist(graphic).remove(level);
			
			textBitmap = new BitmapData(100, 30, true, 0);
			createTextfield("LVL: " + val);
			level = new FXImage(textBitmap);
			level.x = 20;
			level.y = 410;
			level.scrollX = 0;
			level.scrollY = 0;
			
			addGraphic(level);
		}
		
		public function updateXp(val:int):void
		{
			if (experience != null) Graphiclist(graphic).remove(experience);
			
			textBitmap = new BitmapData(100, 30, true, 0);
			createTextfield("XP: " + val);
			experience = new FXImage(textBitmap);
			experience.x = 20;
			experience.y = 440;
			experience.scrollX = 0;
			experience.scrollY = 0;
			
			addGraphic(experience);
		}
		
		private function createTextfield(text:String):void
		{
			tf = new TextFormat("Courier", 14, 0xeaeaea);
			tf.align = TextFormatAlign.LEFT;
			
			t = new TextField();
			t.defaultTextFormat = tf;
			t.embedFonts = true;
			t.width = 100;
			t.height = 30;
			t.text = text;
			t.multiline = true;
			t.wordWrap = true;
			
			textBitmap.draw(t);
		}
		
	}

}