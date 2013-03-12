package com.cp.sf.entities 
{
	import com.cp.sf.entities.terrain.Floor;
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import com.cp.sf.worlds.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Player extends Entity
	{
		private var playerMoving:Boolean = false;
		private var target:MapPoint = null;
		
		public function Player(posX:int = 0, posY:int = 0) 
		{
			var playerImg:Spritemap = new Spritemap(GFX.GFX_PLAYER, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(playerImg);
			playerImg.setFrame(0, 0);
			
			this.type = GC.ENTITY_PLAYER_TYPE;
			
			this.x = GC.MAP_CELL_SIZE * posX;
			this.y = GC.MAP_CELL_SIZE * posY;
		}
		
		override public function update():void
		{
			move();
		}
		
		private function move():void
		{
			
			processDirectionalInput();
		}
		
		private function processDirectionalInput():void
		{
			if (!playerMoving)
			{
				this.target = null;
				if (Input.check("up"))
				{
					target = new MapPoint(this.x, this.y - GC.MAP_CELL_SIZE);
				}
				else if (Input.check("down"))
				{
					target = new MapPoint(this.x, this.y + GC.MAP_CELL_SIZE);
				}
				else if (Input.check("left"))
				{
					target = new MapPoint(this.x - GC.MAP_CELL_SIZE, this.y);
				}
				else if (Input.check("right"))
				{
					target = new MapPoint(this.x + GC.MAP_CELL_SIZE, this.y);
				}
				
				if (target)
				{
					var targetTerrain:Object = GameWorld(this.world).getMapTerrain(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
					if (targetTerrain is Floor)
					{
						playerMoving = true;
					}
				}
			}
			
			if (playerMoving)
			{
				moveTowards(target.x, target.y, GC.PLAYER_MAX_SPEED);
				if (this.x == target.x && this.y == target.y)
				{
					playerMoving = false;
				}
			}
		}
		
		private function get mapX():int
		{
			return this.x / GC.MAP_CELL_SIZE
		}
		
		private function get mapY():int
		{
			return this.y / GC.MAP_CELL_SIZE
		}		
	}

}