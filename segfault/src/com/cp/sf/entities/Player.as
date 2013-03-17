package com.cp.sf.entities 
{
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import com.cp.sf.GV;
	import com.cp.sf.SoundManager;
	import com.cp.sf.Utils;
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
		
		public var health:int;
		public var experience:int;
		public var level:int;
		public var baseDamage:int;
		
		public function Player(posX:int = 0, posY:int = 0) 
		{
			health = 100;
			experience = 0;
			level = 1;
			baseDamage = 5;
			
			playerImg = new Spritemap(GFX.GFX_PLAYER, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(playerImg);
			
			if (GV.playerGender == "male")
			{
				playerImg.setFrame(0, 0);
			}
			else
			{
				playerImg.setFrame(0, 1);
			}
			
			this.type = GC.TYPE_PLAYER;
			
			this.x = GC.MAP_CELL_SIZE * posX;
			this.y = GC.MAP_CELL_SIZE * posY;
		}
		
		override public function update():void
		{
			if (experience >= (level * 100))
			{
				experience -= (level * 100);
				level += 1;
				
				if (health < (level * 100))
				{
					health = (level * 100);
				}
				
				GameWorld(FP.world).ui.updateLevel(level);
				GameWorld(FP.world).ui.updateXp(experience);
				GameWorld(FP.world).ui.updateHealth(health);
				SoundManager.playSound(SoundManager.SFX_LEVELUP);
			}
			
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
				else if (Input.check("wait"))
				{
					GameWorld(this.world).updatePlayerPosition(this.mapX, this.mapY);
					actionDelay = 0.4;
				}
				
				if (target)
				{
					var targetTerrain:String = GameWorld(this.world).gameMap.getCell(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
					var occupiedCell:String = GameWorld(this.world).cellOccupied(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
					if (occupiedCell != null)
					{
						if (occupiedCell == GC.TYPE_ENEMY)
						{
							var damage:int = baseDamage * level;
							
							if (level < GV.floors + 1 && Math.random() <= (0.1 + 0.05 * (GV.floors + 1 - level)))
								damage += (baseDamage * level * Utils.randomRange(0.3, 1.0, true));
							
							GameWorld(this.world).attackEnemy(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE, damage, 1.0);
							GameWorld(this.world).updatePlayerPosition(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
							actionDelay = 0.4;
						}
					}
					else if (targetTerrain == GC.MAP_FLOOR || targetTerrain == GC.MAP_DOOR_OPEN)
					{
						GameWorld(this.world).vacate(this.mapX, this.mapY);
						GameWorld(this.world).occupy(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE, this.type);
						
						GameWorld(this.world).updatePlayerPosition(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
						playerMoving = true;
						SoundManager.playSound(SoundManager.SFX_STEPS);
					}
					else if (targetTerrain == GC.MAP_DOOR_CLOSED)
					{
						GameWorld(this.world).gameMap.openDoor(target.x / GC.MAP_CELL_SIZE, target.y / GC.MAP_CELL_SIZE);
						GameWorld(this.world).updatePlayerPosition(this.mapX, this.mapY);
						actionDelay = 0.4;
					}
					else if (targetTerrain == GC.MAP_STAIRS)
					{	
						GameWorld(this.world).nextFloor();
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