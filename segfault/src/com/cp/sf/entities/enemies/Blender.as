package com.cp.sf.entities.enemies 
{
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import com.cp.sf.GV;
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
			
			this.health = 10 * (GV.floors + 1);
			this.baseDamage = 10 * (GV.floors + 1);
			this.chanceToHit = 70;
			this.xp = 15 * (GV.floors + 1);
			
			super();
		}
		
	}

}