package com.cp.sf.entities.terrain 
{
	import com.cp.sf.entities.ILitObject;
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	
	/**
	 * ...
	 * @author 
	 */
	public class Floor extends Entity implements ILitObject
	{
		private var discovered:Boolean = false;
		private var floorImage:Spritemap;
		
		public function Floor(posX:int, posY:int) 
		{
			floorImage = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(floorImage);
			floorImage.setFrame(0, 0);
			
			this.type = GC.ENTITY_FLOOR_TYPE;
			
			this.x = GC.MAP_CELL_SIZE * posX;
			this.y = GC.MAP_CELL_SIZE * posY;
		}
		
		public function light(val:Number):void
		{
			floorImage.alpha = val;
		}
		
		public function blocksLight():Boolean
		{
			return false;
		}
		
	}

}