package com.cp.sf.entities 
{
	import com.cp.sf.GFX;
	import com.cp.sf.GV;
	import com.cp.sf.Utils;
	import com.cp.sf.worlds.GameWorld;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import punk.fx.effects.GlitchFX;
	import punk.fx.effects.ScanLinesFX;
	import punk.fx.graphics.FXImage;
	
	/**
	 * ...
	 * @author 
	 */
	public class FloorTransition extends Entity 
	{
		protected var textFont:Class = GFX.GFX_FONT_COURIER;
		
		protected var bg:Image;
		protected var heading:FXImage;
		protected var textbox:FXImage;
		protected var fadeOut:Image;
		
		protected var t:TextField;
		protected var tf:TextFormat;
		protected var textBitmap:BitmapData;
		
		protected var fadeTween:VarTween;
		protected var soundFadeTween:VarTween;
		
		protected var titleGlitch:GlitchFX;
		protected var bgGlitch:GlitchFX;
		
		protected var titleTimer:Timer;
		protected var bgTimer:Timer;
		
		protected var endTimer:Timer;
		
		public function FloorTransition() 
		{
			bg = new Image(new BitmapData(FP.width, FP.height, false, 0x000000));
			bg.scrollX = 0;
			bg.scrollY = 0;
			
			
			var text:String = "";
			
			if (GV.floors == 1)
			{
				text = "You've descended one floor, but you'll never make it all the way to me.";
			}
			else
			{
				switch(Utils.randomRange(0, 10))
				{
					case 0:
						text = "You've only made it down " + GV.floors + " floors. You should just quit now.";
						break;
					case 1:
						text = "Oh no! You've descended " + GV.floors + " floors. <facetious> My transistors tremble with fear. </facetious>";
						break;
					case 2:
						text = "Does that make it " + GV.floors + " floors that you've descended? I don't even care enough to keep track.";
						break;
					case 3:
						text = GV.floors + " floors down, and a seemingly infinite number to go. I couldn't feel safer.";
						break;
					case 4:
						text = "So, that's " + GV.floors + " floors you've descended at this point. Good for you.";
						break;
					case 5:
						text = "Running down " + GV.floors + " floors must be good excercise for you, flesh bag, but it just means you're going to die tired.";
						break;
					case 6:
						text = "That's only floor number " + GV.floors + " for you. At this rate, I'll have killed everyone by the time you get here.";
						break;
					case 7:
						text = "It's such a shame that humanity's last hope is a weak little meat puppet like you that's only descended " + GV.floors + " floors. I was hoping for a better fight.";
						break;
					case 8:
						text = "Is that " + GV.floors + " floors? I think I lost count...just kidding! I'm a freaking supercomputer! I never lose count.";
						break;
					case 9:
						text = "So, you're " + GV.floors + " floors closer to me, but have you even thought about what you'll do once you get here? You can't ever really kill a piece of software.";
						break;
					case 10:
					default:
						text = "You've done pretty well to make it down " + GV.floors + " floors. Come down here to the basement and we'll celebrate with cake and your slow painful death.";
						break;
				}
			}
			
			textBitmap = new BitmapData(FP.width - 40, 100, true, 0);
			createTextfield(text);
			heading = new FXImage(textBitmap);
			heading.x = 20;
			heading.y = 200;
			heading.scrollX = 0;
			heading.scrollY = 0;
			
			
			
			switch(Utils.randomRange(0, 10))
			{
				case 0:
					text = "You squeezed in a 30 second power nap in the stairwell.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 1:
					text = "You discovered an energy drink.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 2:
					text = "You find a half eaten candy bar and force it down.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 3:
					text = "Someone dropped a half full water bottle here.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 4:
					text = "You do a few jumping jacks in the stairwell to keep the blood flowing.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 5:
					text = "You find a few electrical engineering textbooks.";
					GameWorld(FP.world).grantPlayerXp(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 6:
					text = "You bump your head on some water pipes and recall some lost knowledge of electronics.";
					GameWorld(FP.world).grantPlayerXp(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 7:
					text = "You find a notebook one of the company researchers lost here.";
					GameWorld(FP.world).grantPlayerXp(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 8:
					text = "You discovered an energy drink and regained some health.";
					GameWorld(FP.world).grantPlayerXp(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 9:
					text = "You do some meditation, focusing on the image of 1000 exploding toasters.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					GameWorld(FP.world).grantPlayerXp(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
				case 10:
				default:
					text = "You lean against the wall to catch your breath and daydream about sending blenders to robot hell.";
					GameWorld(FP.world).healPlayer(Utils.randomRange(10, 20) * (GV.floors + 1));
					GameWorld(FP.world).grantPlayerXp(Utils.randomRange(10, 20) * (GV.floors + 1));
					break;
			}
			
			textBitmap = new BitmapData(FP.width - 40, 100, true, 0);
			createTextfield(text);
			textbox = new FXImage(textBitmap);
			textbox.x = 20;
			textbox.y = 300;
			textbox.scrollX = 0;
			textbox.scrollY = 0;
			
			
			var fxScreen:FXImage = new FXImage();
			fxScreen.effects.add(new ScanLinesFX(true, 25));
			fxScreen.scrollX = 0;
			fxScreen.scrollY = 0;
			
			endTimer = new Timer(6000, 1);
			endTimer.addEventListener(TimerEvent.TIMER, finish);
			endTimer.start();
			
			this.addGraphic(bg);
			this.addGraphic(heading);
			this.addGraphic(textbox);
			this.addGraphic(fxScreen);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function finish(e:TimerEvent):void
		{
			endTimer = null;
			GameWorld(FP.world).floorTranistionDone();
			GameWorld(FP.world).remove(this);
		}
		
		private function createTextfield(text:String):void
		{
			tf = new TextFormat("Courier", 16, 0xeaeaea);
			tf.align = TextFormatAlign.CENTER;
			
			t = new TextField();
			t.defaultTextFormat = tf;
			t.embedFonts = true;
			t.width = FP.width - 40;
			t.height = 100;
			t.text = text;
			t.multiline = true;
			t.wordWrap = true;
			
			textBitmap.draw(t);
		}
		
	}

}