package com.cp.sf.entities.ui 
{
	import com.cp.sf.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameUI extends Entity 
	{
		private var phone:Image
		
		public function GameUI() 
		{
			phone = new Image(GFX.GFX_UI_PHONE);
			phone.x = 8;
			phone.y = 258;
			phone.scrollX = 0;
			phone.scrollY = 0;
			addGraphic(phone);
			this.layer = -1;
		}
		
	}

}