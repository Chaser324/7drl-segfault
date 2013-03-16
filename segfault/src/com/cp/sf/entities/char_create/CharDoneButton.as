package com.cp.sf.entities.char_create 
{
	import flash.filters.DropShadowFilter;
	import punk.fx.graphics.FXImage;
	import ui.Button;
	
	/**
	 * ...
	 * @author 
	 */
	public class CharDoneButton extends Button 
	{
		protected var btnNormal:FXImage;
		private var shadowFilter:DropShadowFilter;
		
		public function CharDoneButton(x:Number=0, y:Number=0, image:Class=null, width:Number=313, height:Number=38, callback:Function=null, params:Object=null) 
		{
			super(x, y, "", width, height, callback, params);
			
			btnNormal = new FXImage(image);
			
			shadowFilter = new DropShadowFilter(0, 90, 0xAA0000, 0.8, 5, 5);
			btnNormal.effects.add(shadowFilter);
			shadowFilter.alpha = 0;
			
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
					shadowFilter.alpha = 0;
					break;
				case HOVER:
					shadowFilter.alpha = 0.8;
					break;
				default:
					shadowFilter.alpha = 0;
					break;
			}
			
			super.changeState(state);
		}
		
	}

}