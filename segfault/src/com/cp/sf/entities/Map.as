package com.cp.sf.entities 
{
	import com.cp.sf.entities.rooms.Room;
	import com.cp.sf.entities.rooms.SmallOffice;
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
		
		protected var rooms:Array;
		
		// Number of blocks in height/width of a cell of room grid
		protected var cell_height:int;
		protected var cell_width:int;
		
		// Number of cells in each column/row of room grid
		protected var grid_height:int;
		protected var grid_width:int;
		
		protected static const GRID_BUFFER:int = 1;
		protected static const CELL_BUFFER:int = 2;
		protected static const GRID_MIN_SIZE:int = 2;
		
		public function Map() 
		{
			this.mapWidth = Utils.randomRange(GC.MAP_WIDTH_MIN, GC.MAP_WIDTH_MAX);
			this.mapHeight = Utils.randomRange(GC.MAP_HEIGHT_MIN, GC.MAP_HEIGHT_MAX);
			
			buildMap();
			
			super();
		}
		
		private function buildMap():void
		{
			buildRoomList();
			buildGrid();
			generateEmptyMap();
			placeRooms();
			traceMap();
		}
		
		private function buildRoomList():void
		{
			rooms = new Array();
			for (var i:int = 0; i < Utils.randomRange(8, 12); i++)
			{
				rooms.push(new SmallOffice());
			}
		}
		
		private function placeRooms():void
		{
			// Generate a list of cell numbers
			var cells:Array = new Array();
			for (var i:int = 0; i < grid_height * grid_width; i++) cells.push(i);
			
			for each (var r:Room in rooms)
			{
				// Assign the room a cell
				var n:int = Utils.randomRange(0, cells.length - 1);
				r.cell_num = cells[n];
				cells.splice(n, 1);
				
				// Place room in cell on layout
				addRoomToMap(r);
			}
		}
		
		private function buildGrid():void
		{
			// Cell size has longest room height/width plus a small buffer.
			cell_height = 0;
			cell_width = 0;
			
			for each (var r:Room in rooms)
			{
				if (r.roomHeight > cell_height)
				{
					cell_height = r.roomHeight;
				}
				if (r.roomWidth > cell_width)
				{
					cell_width = r.roomWidth;
				}
			}
			
			cell_height += CELL_BUFFER;
			cell_width += CELL_BUFFER;
			
			// Get grid size
			grid_height = Utils.randomRange(GRID_MIN_SIZE, rooms.length / 2);
			grid_width = Math.ceil((1.0 * rooms.length) / grid_height);
			
			grid_height += GRID_BUFFER;
			grid_width += GRID_BUFFER;
		}
		
		private function addRoomToMap(room:Room):void
		{
			// Set map x and y cooridantes of room
			room.mapX = (room.cell_num % grid_width) * cell_width;
			room.mapY = int(room.cell_num / grid_width) * cell_height;
			
			// Add random offset within the cell
			room.mapX += Utils.randomRange(0, (cell_width - room.roomWidth));
			room.mapY += Utils.randomRange(0, (cell_height - room.roomHeight));
			
			// Copy room layout to map layout
			for (var i:int = 0; i < room.roomHeight; i++)
			{
				for (var j:int = 0; j < room.roomWidth; j++)
				{
					setCell(j + room.mapX, i + room.mapY, String(room.roomLayout[i]).charAt(j));
				}
			}
		}

		private function setCell(cellX:int, cellY:int, data:String)
		{
			var curRow:String = this.layout[cellY];
			this.layout[cellY] = curRow.substr(0,cellX) + data + curRow.substr(cellX + 1);
		}
		
		private function generateEmptyMap():void
		{
			this.mapHeight = this.grid_height * this.cell_height;
			this.mapWidth = this.grid_width * this.cell_width;
			
			this.layout = new Array(this.mapHeight);
			
			for (var i:int = 0; i < this.layout.length; i++)
			{
				this.layout[i] = new String();
				
				for (var j:int = 0; j < this.mapWidth; j++)
				{
					this.layout[i] = String(this.layout[i]).concat(GC.MAP_EMPTY);
				}
			}
		}
		
		private function traceMap():void
		{
			trace("Current " + this.mapWidth + "x" + this.mapHeight +  " map...");
			for (var i:int = 0; i < this.mapHeight; i++)
			{
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