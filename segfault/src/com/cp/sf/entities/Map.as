package com.cp.sf.entities 
{
	import com.cp.sf.entities.rooms.Room;
	import com.cp.sf.GC;
	import com.cp.sf.Utils;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author 
	 */
	public class Map extends Entity
	{
		protected var mapWidth:int;
		protected var mapHeight:int;
		protected var layout:Array;
		
		
		public function Map() 
		{
			this.mapWidth = Utils.randomRange(GC.MAP_WIDTH_MIN, GC.MAP_WIDTH_MAX);
			this.mapHeight = Utils.randomRange(GC.MAP_HEIGHT_MIN, GC.MAP_HEIGHT_MAX);
			
			trace("Generating empty " + this.mapWidth + "x" + this.mapHeight +  " map...");
			generateEmptyMap();
			
			super();
		}
		
		private function buildMap():void
		{
			// Add a room to the center of the map
			
		}
		
		private function addRoom(destX:int, destY:int, room:Room, direction:int):Boolean
		{
			// Generate a list of all points
			var points:Array = new Array(room.roomHeight * room.roomWidth);
			switch(direction)
			{
				case GC.DIR_UP:
					destY -= (room.roomHeight - 1);
					// Check for connect point, shift along x if one isn't present.
				break;
				
				case GC.DIR_DOWN:
					// Check for connect point, shift along x if one isn't present.
				break;
				
				case GC.DIR_LEFT:
					destX -= (room.roomWidth - 1);
					// Check for connect point, shift along y if one isn't present.
				break;
				
				case GC.DIR_RIGHT:
					// Check for connect point, shift along y if one isn't present.
				break;
				
				default:
				break;
			}
			
			
			
			
			
			// Check if there's enough space for new room.
			for (var i:int = 0; i < room.roomHeight; i++)
			{
				for (var j:int = 0; j < room.roomWidth; j++)
				{
					if (curTile != GC.MAP_EMPTY && curTile != GC.MAP_WALL && curTile != GC.MAP_WALL_NO_DOOR)
					{
						return false;
					}
				}
			}
			
			// Copy room layout to map layout
			for (var i:int = 0; i < room.roomHeight; i++)
			{
				for (var j:int = 0; j < room.roomWidth; j++)
				{
					
				}
			}
		}
		
		private function generateEmptyMap():void
		{
			this.layout = new Array(this.mapHeight);
			
			for (var i:int = 0; i < this.mapHeight; i++)
			{
				this.layout[i] = new String();
				
				for (var j:int = 0; j < this.mapWidth; j++)
				{
					this.layout[i] = String(this.layout[i]).concat(GC.MAP_EMPTY);
				}
				
				trace(String(this.layout[i]));
			}
		}
		
	}

}
class MapPoint
{
	public var x:int;
	public var y:int;
	public var tile:String;
	
	public function MapPoint(x:int, y:int, tile:String)
	{
		this.x = x;
		this.y = y;
		this.tile = tile;
	}
}