package com.cp.sf.worlds 
{
	import com.cp.sf.entities.Map;
	import com.cp.sf.entities.MapPoint;
	import com.cp.sf.entities.Player;
	import com.cp.sf.entities.ui.GameUI;
	import com.cp.sf.entities.ui.Minimap;
	import com.cp.sf.FOV;
	import com.cp.sf.GC;
	import net.flashpunk.FP;
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
		
		protected var cameraVX:Number = 0;
		protected var cameraVY:Number = 0;
		
		protected var lighting:FOV;
		
		public function GameWorld() 
		{
			super();
		}
		
		override public function begin():void
		{
			ui = new GameUI();
			this.add(ui);
			
			map = new Map();
			this.add(map);
			
			player = new Player(map.playerStartPosition.x, map.playerStartPosition.y);
			this.add(player);
			
			minimap = new Minimap(map.mapHeight,map.mapWidth);
			this.add(minimap);
			minimap.visible = false;
			
			lighting = new FOV(map.terrainEntities);
			lighting.compute(player.mapX, player.mapY);
			
			super.begin();
		}
		
		override public function update():void
		{
			followPlayer();
			
			super.update();
		}
		
		public function updatePlayerPosition(x:int, y:int):void
		{			
			lighting.compute(x, y);
			minimap.updatePlayerPosition(new MapPoint(x, y));
		}
		
		public function getMapTerrain(mapX:int, mapY:int):Object
		{
			return this.map.getCellObject(mapX, mapY);
		}
		
		public function revealMinimap(mapX:int, mapY:int, tile:String):void
		{
			minimap.revealCell(new MapPoint(mapX, mapY, tile));
		}
		
		private function followPlayer():void
		{
			FP.camera.x = (player.x + player.width / 2) - FP.width / 1.6;
			FP.camera.y = (player.y + player.height / 2) - FP.height / 2;
		}
		
	}

}