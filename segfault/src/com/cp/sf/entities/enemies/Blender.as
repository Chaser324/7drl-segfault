package com.cp.sf.entities.enemies 
{
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author 
	 */
	public class Blender extends Enemy 
	{
		
		public function Blender() 
		{
			enemyImg = new Spritemap(GFX.GFX_ENEMY, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			enemyImg.setFrame(0, 0);
			
			health = 10;
			
			super();
		}
		
	}

}