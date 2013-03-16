package com.cp.sf.worlds 
{
	import com.cp.sf.entities.enemies.Enemy;
	import com.cp.sf.entities.Map;
	import com.cp.sf.entities.MapPoint;
	import com.cp.sf.entities.Player;
	import com.cp.sf.entities.ui.GameUI;
	import com.cp.sf.entities.ui.Minimap;
	import com.cp.sf.FOV;
	import com.cp.sf.GC;
	import com.cp.sf.GV;
	import com.cp.sf.SoundManager;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameWorld extends World 
	{
		protected var map:Map;
		protected var player:Player;
		protected var ui:GameUI;
		protected var minimap:Minimap;
		
		protected var fadeImage:Image;
		
		protected var cameraVX:Number = 0;
		protected var cameraVY:Number = 0;
		
		protected var lighting:FOV;
		
		protected var fadeTween:VarTween;
		protected var fadeMusicTween:VarTween;
		
		protected var floor:int = 1;
		
		protected var occupiedCells:Array;
		
		public function GameWorld() 
		{
			super();
		}
		
		override public function begin():void
		{
			ui = new GameUI();
			ui.layer = 0;
			this.add(ui);
			
			map = new Map();
			map.layer = 10;
			this.add(map);
			
			player = new Player(map.playerStartPosition.x, map.playerStartPosition.y);
			player.layer = 5;
			this.add(player);
			
			minimap = new Minimap(map.mapHeight, map.mapWidth);
			minimap.layer = 0;
			this.add(minimap);
			minimap.visible = false;
			
			lighting = new FOV(map);
			lighting.compute(player.mapX, player.mapY);
			
			occupiedCells = new Array(map.mapHeight * map.mapWidth);
			occupy(player.mapX, player.mapY, player.type);
			
			var enemies:Array = new Array();
			getType(GC.TYPE_ENEMY, enemies);
			for each (var e:Enemy in enemies)
			{
				occupy(e.mapX, e.mapY, e.type);
			}
			
			fadeImage = new Image(new BitmapData(FP.width, FP.height, false, 0xFF000000));
			fadeImage.scrollX = 0;
			fadeImage.scrollY = 0;
			this.addGraphic(fadeImage, -20);
			
			fadeIn();
			
			super.begin();
		}
		
		override public function update():void
		{
			followPlayer();
			
			updateEnemyVisibility();
			
			super.update();
		}
		
		public function occupy(mapX:int, mapY:int, type:String):void
		{
			occupiedCells[mapY * map.mapWidth + mapX] = type;
		}
		
		public function vacate(mapX:int, mapY:int):void
		{
			occupiedCells[mapY * map.mapWidth + mapX] = null;
		}
		
		public function cellOccupied(mapX:int, mapY:int):String
		{
			return occupiedCells[mapY * map.mapWidth + mapX];
		}
		
		public function attackEnemy(enemyX:int, enemyY:int, damage:int, chance:Number):void
		{
			var enemies:Array = new Array();
			getType(GC.TYPE_ENEMY, enemies);
			
			for each (var e:Enemy in enemies)
			{
				if (e.mapX == enemyX && e.mapY == enemyY)
				{
					e.hit(damage, chance);
				}
			}
		}
		
		private function updateEnemyVisibility():void
		{
			var enemies:Array = new Array();
			getType(GC.TYPE_ENEMY, enemies);
			
			for each (var e:Enemy in enemies)
			{
				e.setVisibility(map.getCellVisibility(e.mapX, e.mapY));
			}
		}
		
		public function updatePlayerPosition(x:int, y:int):void
		{
			map.clearTweens();
			lighting.compute(x, y);
			minimap.updatePlayerPosition(new MapPoint(x, y));
			moveEnemies(x, y);
		}
		
		public function revealMinimap(mapX:int, mapY:int, tile:String):void
		{
			minimap.revealCell(new MapPoint(mapX, mapY, tile));
		}
		
		public function addEnemy(e:Enemy):void
		{
			e.layer = 5;
			this.add(e);
		}
		
		public function moveEnemies(targetX:int, targetY:int):void
		{
			var enemies:Array = new Array();
			getType(GC.TYPE_ENEMY, enemies);
			
			for each (var e:Enemy in enemies)
			{
				e.moveTarget(targetX, targetY);
			}
		}
		
		private function followPlayer():void
		{
			FP.camera.x = (player.x + player.width / 2) - FP.width / 1.6;
			FP.camera.y = (player.y + player.height / 2) - FP.height / 2;
		}
		
		private function fadeIn():void
		{
			fadeImage.alpha = 1;
			fadeImage.visible = true;
			
			SoundManager.currentMusic = SoundManager.music_floor1;
			SoundManager.currentMusic.volume = 0;
			
			fadeTween = new VarTween(fadeInComplete);
			fadeTween.tween(fadeImage, "alpha", 0, 3, Ease.quadIn);
			
			fadeMusicTween = new VarTween();
			fadeMusicTween.tween(SoundManager.currentMusic, "volume", GV.volumeMusic, 3, Ease.quadIn);
			
			addTween(fadeTween);
			addTween(fadeMusicTween);
		}
		
		private function fadeInComplete():void
		{
			fadeImage.visible = false;
		}
		
		public function get gameMap():Map
		{
			return map;
		}
		
	}

}