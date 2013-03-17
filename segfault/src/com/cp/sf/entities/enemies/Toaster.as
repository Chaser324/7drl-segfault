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
	public class Toaster extends Enemy 
	{
		
		public function Toaster() 
		{
			enemyImg = new FXSpritemap(GFX.GFX_ENEMY, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			enemyImg.setFrame(1, 0);
			
			this.health = 5 * (GV.floors + 1);
			this.baseDamage = 5 * (GV.floors + 1);
			this.chanceToHit = 90;
			this.xp = 10 * (GV.floors + 1);
			
			super();
		}
		
	}

}