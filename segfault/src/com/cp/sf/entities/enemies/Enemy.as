package com.cp.sf.entities.enemies 
{
	import com.cp.sf.entities.MapPoint;
	import com.cp.sf.GC;
	import com.cp.sf.SoundManager;
	import com.cp.sf.worlds.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	
	/**
	 * ...
	 * @author 
	 */
	public class Enemy extends Entity 
	{
		protected var health:int;
		protected var baseDamage:int;
		protected var level:int;
		
		protected var enemyImg:Spritemap;
		
		protected var alerted:Boolean;
		protected var moving:Boolean = false;
		
		private var target:MapPoint = null;
		
		protected var visitedCells:Array = new Array();
		
		public function Enemy() 
		{
			this.addGraphic(enemyImg);
			
			this.type = GC.TYPE_ENEMY;
		}
		
		override public function update():void
		{
			if (moving && target != null)
			{
				moveTowards(target.x, target.y, GC.PLAYER_MAX_SPEED);
				if (this.x == target.x && this.y == target.y)
				{
					moving = false;
				}
			}
		}
		
		public function moveTarget(targetX:int, targetY:int):void
		{
			// if we haven't spotted the player, don't move.
			if (!alerted) return;
			
			// get all neighboring cells.
			var neighbors:Array = new Array();
			neighbors[0] = new MapPoint(this.mapX, this.mapY - 1);
			neighbors[1] = new MapPoint(this.mapX + 1, this.mapY);
			neighbors[2] = new MapPoint(this.mapX, this.mapY + 1);
			neighbors[3] = new MapPoint(this.mapX - 1, this.mapY);
			neighbors[4] = new MapPoint(this.mapX, this.mapY);
			
			var best:int = int.MAX_VALUE;
			var choice:MapPoint = null;
			var target:MapPoint = new MapPoint(targetX, targetY);
			for(var i:int = 0; i < neighbors.length; i++){
				var dist:int = target.mDist(neighbors[i]);
				var targetCell:String = GameWorld(FP.world).gameMap.getCell(neighbors[i].x, neighbors[i].y);
				
				if (targetCell != GC.MAP_FLOOR && targetCell != GC.MAP_DOOR_OPEN)
				{
					dist = int.MAX_VALUE;
				}
				else if (i != 4 && GameWorld(FP.world).cellOccupied(neighbors[i].x, neighbors[i].y) != null)
				{
					dist = int.MAX_VALUE;
				}
				else if (haveVisitedCell(neighbors[i]))
				{
					dist += 1;
				}
				
				if(dist < best){
					best = dist;
					choice = neighbors[i];
				}
			}
			
			if (choice != null && (choice.x != this.mapX || choice.y != this.mapY))
			{
				GameWorld(FP.world).vacate(this.mapX, this.mapY);
				GameWorld(FP.world).occupy(choice.x, choice.y, this.type);
				
				visitedCells.push(new MapPoint(this.mapX, this.mapY));
				this.target = new MapPoint(choice.x * GC.MAP_CELL_SIZE, choice.y * GC.MAP_CELL_SIZE);
				moving = true;
			}
		}
		
		public function hit(damage:int, chance:Number):void
		{
			if (Math.random() <= chance)
			{
				health -= damage;
				
				if (health <= 0) 
				{
					die();
				}
				else
				{
					SoundManager.playSound(SoundManager.SFX_ENEMY_HIT);
				}
			}
		}
		
		public function die():void
		{
			GameWorld(FP.world).vacate(this.mapX, this.mapY);
			FP.world.remove(this);
		}
		
		public function setVisibility(alpha:Number):void
		{
			if (alpha <= 0.2)
			{
				enemyImg.alpha = 0;
				enemyImg.visible = false;
			}
			else
			{
				enemyImg.alpha = alpha;
				enemyImg.visible = true;
				alerted = true;
			}
		}
		
		private function haveVisitedCell(cell:MapPoint):Boolean
		{
			for each (var visited:MapPoint in visitedCells)
			{
				if (cell.x == visited.x && cell.y == visited.y) return true;
			}
			
			return false;
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