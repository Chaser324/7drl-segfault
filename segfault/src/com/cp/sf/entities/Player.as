package com.cp.sf.entities 
{
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
		private var playerImg:Spritemap;
		
		private var actionDelay:Number = 0;
		
		public function Player(posX:int = 0, posY:int = 0) 
		{
			playerImg = new Spritemap(GFX.GFX_PLAYER, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
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
			actionDelay = FP.approach(actionDelay,0,FP.elapsed);
			
			if (!playerMoving && actionDelay == 0)
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
					
					if (playerImg.scaleX == 1)
					{
						playerImg.scaleX = -1;
						playerImg.x = GC.MAP_CELL_SIZE;
					}
				}
				else if (Input.check("right"))
				{
					target = new MapPoint(this.x + GC.MAP_CELL_SIZE, this.y);
					
					if (playerImg.scaleX == -1)
					{
						playerImg.scaleX = 1;
						playerImg.x = 0;
					}
				}
				
				if (target)
				{
					var targetTerrain:String = GameWorld(this.world).gameMap.getCell(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
					if (targetTerrain == GC.MAP_FLOOR || targetTerrain == GC.MAP_DOOR_OPEN)
					{
						GameWorld(this.world).updatePlayerPosition(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
						playerMoving = true;
					}
					else if (targetTerrain == GC.MAP_DOOR_CLOSED)
					{
						GameWorld(this.world).gameMap.openDoor(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
						GameWorld(this.world).updatePlayerPosition(this.mapX, this.mapY);
						actionDelay = 0.4;
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
		
		public function get mapX():int
		{
			return this.x / GC.MAP_CELL_SIZE
		}
		
		public function get mapY():int
		{
			return this.y / GC.MAP_CELL_SIZE
		}		
	}

}