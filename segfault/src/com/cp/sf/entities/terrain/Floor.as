package com.cp.sf.entities.terrain 
{
	import com.cp.sf.entities.ILitObject;
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import com.cp.sf.worlds.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	
	/**
	 * ...
	 * @author 
	 */
	public class Floor extends Entity implements ILitObject
	{
		private var discovered:Boolean = false;
		private var floorImage:Spritemap;
		private var lightTween:VarTween;
		
		public function Floor(posX:int, posY:int) 
		{
			floorImage = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(floorImage);
			floorImage.setFrame(0, 0);
			floorImage.alpha = 0;
			
			this.type = GC.ENTITY_FLOOR_TYPE;
			
			this.x = GC.MAP_CELL_SIZE * posX;
			this.y = GC.MAP_CELL_SIZE * posY;
		}
		
		public function light(val:Number):void
		{
			if (val > 0)
			{
				discovered = true;
				GameWorld(FP.world).revealMinimap(this.x / GC.MAP_CELL_SIZE, this.y / GC.MAP_CELL_SIZE, GC.MAP_FLOOR);
			}
			
			if (val < 20 && discovered) val = 20;
			
			this.clearTweens();
			lightTween = new VarTween();
			lightTween.tween(floorImage, "alpha", (val / 100), 0.3, Ease.quadIn);
			this.addTween(lightTween);
		}
		
		public function blocksLight():Boolean
		{
			return false;
		}
		
	}

}