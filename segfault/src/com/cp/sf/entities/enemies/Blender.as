package com.cp.sf.entities.enemies 
{
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import net.flashpunk.graphics.Spritemap;
	import punk.fx.graphics.FXSpritemap;
	/**
	 * ...
	 * @author 
	 */
	public class Blender extends Enemy 
	{
		
		public function Blender() 
		{
			enemyImg = new FXSpritemap(GFX.GFX_ENEMY, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			enemyImg.setFrame(0, 0);
			
			health = 10;
			baseDamage = 10;
			
			super();
		}
		
	}

}