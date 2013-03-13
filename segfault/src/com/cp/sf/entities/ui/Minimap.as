package com.cp.sf.entities.ui 
{
	import com.cp.sf.entities.MapPoint;
	import com.cp.sf.GC;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author 
	 */
	public class Minimap extends Entity 
	{
		private var mapHeight:int;
		private var mapWidth:int;
		
		private var mapBmap:BitmapData;
		private var mapImage:Image;
		private var player:Image;
		
		private var revealedCells:Array = new Array();
		
		private static const CELL_SIZE:int = 4;
		private static const MAP_WALL_COLOR:uint = 0xFF999999;
		private static const MAP_FLOOR_COLOR:uint = 0xFF333333;
		private static const PLAYER_COLOR:uint = 0xFFFF0000;
		
		public function Minimap(mapHeight:int, mapWidth:int)
		{
			this.mapHeight = mapHeight;
			this.mapWidth = mapWidth;
			
			mapBmap = new BitmapData(mapWidth * CELL_SIZE, mapHeight * CELL_SIZE, true, 0x00FFFFFF);
			
			mapImage = new Image(mapBmap);
			mapImage.x = FP.width - (mapWidth * CELL_SIZE) - 10;
			mapImage.y = FP.height - (mapHeight * CELL_SIZE) - 10;
			mapImage.scrollX = 0;
			mapImage.scrollY = 0;
			mapImage.alpha = 0.6;
			
			player = new Image(new BitmapData(CELL_SIZE, CELL_SIZE, false, PLAYER_COLOR));
			player.scrollX = 0;
			player.scrollY = 0;
			player.alpha = 0.9;
			
			addGraphic(mapImage);
			addGraphic(player);
			
			super();
		}
		
		override public function update():void
		{
			var updateMap:Boolean = (revealedCells.length > 0)? true : false;
			while (revealedCells.length > 0)
			{
				var mapPoint:MapPoint = revealedCells.pop();
				var mapColor:uint;
				
				if (mapPoint.tile == GC.MAP_WALL)
					mapColor = MAP_WALL_COLOR;
				else
					mapColor = MAP_FLOOR_COLOR;
				
				mapBmap.fillRect(new Rectangle(mapPoint.x * CELL_SIZE, mapPoint.y * CELL_SIZE, CELL_SIZE, CELL_SIZE), mapColor);
			}
			
			if (updateMap)
			{
				Graphiclist(graphic).remove(mapImage);
				mapImage = new Image(mapBmap);
				mapImage.x = FP.width - (mapWidth * CELL_SIZE) - 10;
				mapImage.y = FP.height - (mapHeight * CELL_SIZE) - 10;
				mapImage.scrollX = 0;
				mapImage.scrollY = 0;
				mapImage.alpha = 0.6;
				addGraphic(mapImage);
			}
			
			if (Input.pressed("map"))
			{
				this.visible = !this.visible;
			}
			
			super.update();
		}
		
		public function revealCell(mapPoint:MapPoint):void
		{
			revealedCells.push(mapPoint);
		}
		
		public function updatePlayerPosition(mapPoint:MapPoint):void
		{
			player.x = mapImage.x + mapPoint.x * CELL_SIZE;
			player.y = mapImage.y + mapPoint.y * CELL_SIZE;
		}
		
	}

}