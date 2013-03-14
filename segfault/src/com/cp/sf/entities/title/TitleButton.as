package com.cp.sf.entities.title 
{
	import com.cp.sf.Utils;
	import net.flashpunk.tweens.misc.VarTween;
	import punk.fx.effects.RGBDisplacementFX;
	import punk.fx.graphics.FXImage;
	import ui.Button;
	
	/**
	 * ...
	 * @author 
	 */
	public class TitleButton extends Button 
	{
		protected var btnNormal:FXImage;
		protected var shiftEffect:RGBDisplacementFX;
		
		protected var redTweenX:VarTween;
		protected var blueTweenX:VarTween;
		protected var greenTweenX:VarTween;
		
		protected var redTweenY:VarTween;
		protected var blueTweenY:VarTween;
		protected var greenTweenY:VarTween;
		
		public function TitleButton(x:Number=0, y:Number=0, image:Class=null, width:Number=313, height:Number=38, callback:Function=null, params:Object=null) 
		{
			super(x, y, "", width, height, callback, params);
			
			btnNormal = new FXImage(image);
			
			shiftEffect = new RGBDisplacementFX();
			btnNormal.effects.add(shiftEffect);
			
			addGraphic(btnNormal);
		}
		
		override protected function changeState(state:int = 0):void 
		{
			if (state == lastState) return;
			
			switch(state)
			{
				//normal and down will be the same image
				case NORMAL:
				case DOWN:
					break;
				case HOVER:
					hoverEffect();
					break;
				default:
					break;
			}
			
			super.changeState(state);
		}
		
		private function hoverEffect():void
		{
			this.clearTweens();
			
			shiftEffect.redOffsetX = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			shiftEffect.greenOffsetX = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			shiftEffect.blueOffsetX = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			
			shiftEffect.redOffsetY = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			shiftEffect.greenOffsetY = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			shiftEffect.blueOffsetY = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			
			redTweenX = new VarTween();
			greenTweenX = new VarTween();
			blueTweenX = new VarTween();
			redTweenY = new VarTween();
			greenTweenY = new VarTween();
			blueTweenY = new VarTween();
			
			redTweenX.tween(shiftEffect, "redOffsetX", 0, Utils.randomRange(0.1, 0.3, true));
			greenTweenX.tween(shiftEffect, "greenOffsetX", 0, Utils.randomRange(0.1, 0.3, true));
			blueTweenX.tween(shiftEffect, "blueOffsetX", 0, Utils.randomRange(0.1, 0.3, true));
			redTweenY.tween(shiftEffect, "redOffsetY", 0, Utils.randomRange(0.1, 0.3, true));
			greenTweenY.tween(shiftEffect, "greenOffsetY", 0, Utils.randomRange(0.1, 0.3, true));
			blueTweenY.tween(shiftEffect, "blueOffsetY", 0, Utils.randomRange(0.1, 0.3, true));
			
			this.addTween(redTweenX);
			this.addTween(greenTweenX);
			this.addTween(blueTweenX);
			this.addTween(redTweenY);
			this.addTween(greenTweenY);
			this.addTween(blueTweenY);
		}
		
	}

}