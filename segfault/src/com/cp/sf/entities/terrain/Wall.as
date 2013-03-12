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
	public class Wall extends Entity implements ILitObject
	{
		private var discovered:Boolean = false;
		private var wallImage:Spritemap;
		
		public function Wall(posX:int, posY:int)
		{
			wallImage = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(wallImage);
			wallImage.setFrame(0, 1);
			
			this.type = GC.ENTITY_WALL_TYPE;
			
			this.x = GC.MAP_CELL_SIZE * posX;
			this.y = GC.MAP_CELL_SIZE * posY;
		}
		
		public function light(val:Number):void
		{
			wallImage.alpha = val;
		}
		
		public function blocksLight():Boolean
		{
			return true;
		}
		
	}

}