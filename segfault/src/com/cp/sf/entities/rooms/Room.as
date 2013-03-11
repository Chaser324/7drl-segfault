package com.cp.sf.entities.rooms 
{
	import com.cp.sf.entities.MapPoint;
	import com.cp.sf.GC;
	import com.cp.sf.Utils;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author 
	 */
	public class Room
	{
		// The number of the cell assigned to this room
		public var cell_num:int;
		
		// The map cooridinates of this room's origin (top left cell)
		public var mapX:int;
		public var mapY:int;
		
		public var connected:Boolean = false;
		
		public var neighbors:Array = new Array();;
		
		protected var layout:Array;
		
		public function Room() 
		{	
			generateLayout();
			super();
		}
		
		protected function generateLayout():void
		{
			// should be overriden by derived class.
		}
		
		public function get topConnectPoint():MapPoint
		{
			var tile:String = "";
			var conX:int = -1;
			var conY:int = -1;
			while (tile != GC.MAP_FLOOR)
			{
				conX = Utils.randomRange(0, roomWidth - 1);
				conY = 0;
				tile = getTile(conX, conY);
			}
			
			return new MapPoint(mapX + conX, mapY + conY);
		}
		
		public function get bottomConnectPoint():MapPoint
		{
			var tile:String = "";
			var conX:int = -1;
			var conY:int = -1;
			while (tile != GC.MAP_FLOOR)
			{
				conX = Utils.randomRange(0, roomWidth - 1);
				conY = roomHeight - 1;
				tile = getTile(conX, conY);
			}
			
			return new MapPoint(mapX + conX, mapY + conY);
		}
		
		public function get rightConnectPoint():MapPoint
		{
			var tile:String = "";
			var conX:int = -1;
			var conY:int = -1;
			while (tile != GC.MAP_FLOOR)
			{
				conX = roomWidth - 1;
				conY = Utils.randomRange(0, roomHeight - 1);
				tile = getTile(conX, conY);
			}
			
			return new MapPoint(mapX + conX, mapY + conY);
		}
		
		public function get leftConnectPoint():MapPoint
		{
			var tile:String = "";
			var conX:int = -1;
			var conY:int = -1;
			while (tile != GC.MAP_FLOOR)
			{
				conX = 0;
				conY = Utils.randomRange(0, roomHeight - 1);
				tile = getTile(conX, conY);
			}
			
			return new MapPoint(mapX + conX, mapY + conY);
		}
		
		public function getMapTile(x:int, y:int):String
		{
			return getTile(x - mapX, y - mapY);
		}
		
		public function getTile(x:int, y:int):String
		{
			if (x < 0 || x >= roomWidth || y < 0 || y >= roomHeight)
				return null;
			else
				return String(layout[y]).charAt(x);
		}
		
		public function get roomLayout():Array
		{
			return layout;
		}
		
		public function get roomHeight():int
		{
			if (layout)
			{
				return layout.length;
			}
			else
			{
				return 0;
			}
		}
		
		public function get roomWidth():int
		{
			if (layout)
			{
				return String(layout[0]).length;
			}
			else
			{
				return 0;
			}
		}
		
	}

}