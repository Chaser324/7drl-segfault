package com.cp.sf.worlds 
{
	import com.cp.sf.entities.enemies.Enemy;
	import com.cp.sf.entities.FloorTransition;
	import com.cp.sf.entities.Map;
	import com.cp.sf.entities.MapPoint;
	import com.cp.sf.entities.Player;
	import com.cp.sf.entities.ui.GameUI;
	import com.cp.sf.entities.ui.Minimap;
	import com.cp.sf.FOV;
	import com.cp.sf.GC;
	import com.cp.sf.GV;
	import com.cp.sf.SoundManager;
	import com.cp.sf.Utils;
	import flash.display.BitmapData;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.World;
	import punk.fx.effects.RGBDisplacementFX;
	import punk.fx.effects.ScanLinesFX;
	import punk.fx.graphics.FXImage;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameWorld extends World 
	{
		protected var map:Map;
		protected var player:Player;
		public var ui:GameUI;
		protected var minimap:Minimap;
		protected var floorTransition:FloorTransition;
		
		protected var playerHitImage:FXImage;
		protected var playerHitEffect:RGBDisplacementFX;
		protected var redTweenX:VarTween;
		protected var blueTweenX:VarTween;
		protected var greenTweenX:VarTween;
		protected var redTweenY:VarTween;
		protected var blueTweenY:VarTween;
		protected var greenTweenY:VarTween;
		
		protected var fadeImage:Image;
		
		protected var cameraVX:Number = 0;
		protected var cameraVY:Number = 0;
		
		protected var lighting:FOV;
		
		protected var fadeTween:VarTween;
		protected var fadeMusicTween:VarTween;
		
		protected var floor:int = 1;
		
		protected var occupiedCells:Array;
		
		protected var movedToNextFloor:Boolean = false;
		
		public function GameWorld() 
		{
			super();
		}
		
		override public function begin():void
		{
			GV.floors = 0;
			GV.kills = 0;
			
			ui = new GameUI();
			ui.layer = 0;
			this.add(ui);
			
			map = new Map();
			map.layer = 10;
			this.add(map);
			
			player = new Player(map.playerStartPosition.x, map.playerStartPosition.y);
			player.layer = 5;
			this.add(player);
			
			ui.updateHealth(player.health);
			ui.updateLevel(player.level);
			ui.updateXp(player.experience);
			ui.updateFloor(GV.floors);
			
			playerHitImage = new FXImage();
			playerHitEffect = new RGBDisplacementFX();
			playerHitImage.effects.add(playerHitEffect);
			playerHitImage.scrollX = 0;
			playerHitImage.scrollY = 0;
			this.addGraphic(playerHitImage, -1);
			playerHitImage.visible = false;
			
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
			if (movedToNextFloor)
			{
				initNextFloor();
			}
			else
			{
				followPlayer();
				updateEnemyVisibility();
			}
			
			super.update();
		}
		
		public function healPlayer(amount:int):void
		{
			player.health += amount;
			ui.updateHealth(player.health);
		}
		
		public function grantPlayerXp(amount:int):void
		{
			player.experience += amount;
			ui.updateXp(player.experience);
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
		
		public function attackPlayer(damage:int, chance:Number):void
		{
			if (Math.random() <= chance)
			{
				player.health -= damage;
				ui.updateHealth(player.health);
				
				if (player.health <= 0) 
				{
					gameover();
				}
				else
				{
					SoundManager.playSound(SoundManager.SFX_ENEMY_HIT);
					playerHit();
				}
			}
		}
		
		private function playerHit():void
		{
			this.clearTweens();
			playerHitImage.visible = true;
			
			Utils.quake.start(0.5, 0.3);
			
			playerHitEffect.redOffsetX = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			playerHitEffect.greenOffsetX = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			playerHitEffect.blueOffsetX = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			
			playerHitEffect.redOffsetY = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			playerHitEffect.greenOffsetY = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			playerHitEffect.blueOffsetY = Utils.randomRange(5,10) * (Math.random() > 0.5? 1 : -1);
			
			redTweenX = new VarTween(stopPlayerHitEffect);
			greenTweenX = new VarTween();
			blueTweenX = new VarTween();
			redTweenY = new VarTween();
			greenTweenY = new VarTween();
			blueTweenY = new VarTween();
			
			redTweenX.tween(playerHitEffect, "redOffsetX", 0, Utils.randomRange(0.1, 0.3, true));
			greenTweenX.tween(playerHitEffect, "greenOffsetX", 0, Utils.randomRange(0.1, 0.3, true));
			blueTweenX.tween(playerHitEffect, "blueOffsetX", 0, Utils.randomRange(0.1, 0.3, true));
			redTweenY.tween(playerHitEffect, "redOffsetY", 0, Utils.randomRange(0.1, 0.3, true));
			greenTweenY.tween(playerHitEffect, "greenOffsetY", 0, Utils.randomRange(0.1, 0.3, true));
			blueTweenY.tween(playerHitEffect, "blueOffsetY", 0, Utils.randomRange(0.1, 0.3, true));
			
			this.addTween(redTweenX);
			this.addTween(greenTweenX);
			this.addTween(blueTweenX);
			this.addTween(redTweenY);
			this.addTween(greenTweenY);
			this.addTween(blueTweenY);
		}
		
		private function stopPlayerHitEffect():void
		{
			playerHitImage.visible = false;
		}
		
		private function gameover():void
		{
			player.active = false;
			
			SoundManager.playSound(SoundManager.SFX_GAMEOVER);
			
			fadeImage = new Image(new BitmapData(FP.width, FP.height, false, 0xFFFF0000));
			fadeImage.scrollX = 0;
			fadeImage.scrollY = 0;
			fadeImage.alpha = 0.5;
			addGraphic(fadeImage, -1);
			
			this.clearTweens();
			fadeTween = new VarTween();
			fadeTween.tween(fadeImage, "alpha", 1.0, 1.5, Ease.quadIn);
			this.addTween(fadeTween);
			
			fadeMusicTween = new VarTween(goToTitle);
			fadeMusicTween.tween(SoundManager.currentMusic, "volume", 0, 1.5, Ease.quadIn);
			this.addTween(fadeMusicTween);
		}
		
		public function nextFloor():void
		{
			GV.floors += 1;
			
			ui.updateFloor(GV.floors);
			
			SoundManager.playSound(SoundManager.SFX_STAIRS);
			
			this.removeAll();
			
			movedToNextFloor = true;
		}
		
		private function initNextFloor():void
		{
			movedToNextFloor = false;
			floorTransition = null;
			
			this.add(ui);
			
			ui.updateHealth(player.health);
			ui.updateLevel(player.level);
			ui.updateXp(player.experience);
			ui.updateFloor(GV.floors);
			
			
			map = new Map();
			map.layer = 10;
			this.add(map);
			
			player.x = GC.MAP_CELL_SIZE * map.playerStartPosition.x;
			player.y = GC.MAP_CELL_SIZE * map.playerStartPosition.y;
			this.add(player);
			
			//this.addGraphic(playerHitImage, -1);
			
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
			
			//this.addGraphic(fadeImage, -20);
			
			//fadeIn();
			
			floorTransition = new FloorTransition();
			floorTransition.layer = -1;
			this.add(floorTransition);
			player.active = false;
		}
		
		public function floorTranistionDone():void
		{
			player.active = true;
		}
		
		private function goToTitle():void
		{
			this.removeAll();
			FP.world = new GameOverWorld();
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