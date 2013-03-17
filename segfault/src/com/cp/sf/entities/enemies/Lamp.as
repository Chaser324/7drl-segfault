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
	public class Lamp extends Enemy 
	{
		
		public function Lamp() 
		{
			enemyImg = new FXSpritemap(GFX.GFX_ENEMY, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			enemyImg.setFrame(2, 0);
			
			this.health = 15 * (GV.floors + 1);
			this.baseDamage = 15 * (GV.floors + 1);
			this.chanceToHit = 40;
			this.xp = 20 * (GV.floors + 1);
			
			super();
		}
		
	}

}