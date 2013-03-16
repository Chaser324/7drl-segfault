package com.cp.sf.entities 
{
	import com.cp.sf.entities.rooms.Room;
	import com.cp.sf.entities.rooms.SmallOffice;
	import com.cp.sf.GC;
	import com.cp.sf.GFX;
	import com.cp.sf.SoundManager;
	import com.cp.sf.Utils;
	import com.cp.sf.worlds.GameWorld;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author 
	 */
	public class Map extends Entity
	{
		//{ region Instance Variables
		protected var layout:Array;
		
		protected var rooms:Array;
		protected var sortedRooms:Array;
		protected var firstRoom:Room;
		protected var lastRoom:Room;
		
		public var terrainEntities:Array;
		
		protected var tweens:Array = new Array();
		
		// Number of blocks in height/width of a cell of room grid
		protected var cell_height:int;
		protected var cell_width:int;
		
		// Number of cells in each column/row of room grid
		protected var grid_height:int;
		protected var grid_width:int;
		
		protected var playerStartPos:MapPoint;
		
		protected var buildDone:Boolean;
		
		//} endregion
		
		//{ region Constants
		
		protected static const GRID_BUFFER:int = 0;
		protected static const CELL_BUFFER:int = 4;
		protected static const GRID_MIN_SIZE:int = 3;
		protected static const MIN_RANDOM_CONNECTIONS:int = 5;
		protected static const MAX_RANDOM_CONNECTIONS:int = 8;
		
		//} endregion
		
		//{ region Constructor
		
		public function Map() 
		{
			buildMap();
			
			super();
		}
		
		//} endregion
		
		//{ region Public Methods
		
		override public function update():void
		{
			super.update();
		}
		
		public function getCell(cellX:int, cellY:int):String
		{
			if (cellX < 0 || cellX >= mapWidth || cellY < 0 || cellY >= mapHeight) 
				return null
			
			return String(layout[cellY]).charAt(cellX);
		}
		
		public function getCellObject(cellX:int, cellY:int):Object
		{
			if (cellX < 0 || cellX >= mapWidth || cellY < 0 || cellY >= mapHeight) 
				return null
			
			return terrainEntities[cellY][cellX];
		}
		
		public function openDoor(cellX:int, cellY:int):void
		{
			setCell(cellX, cellY, GC.MAP_DOOR_OPEN);
			Graphiclist(graphic).remove(terrainEntities[cellY][cellX]);
			drawOpenDoor(cellX, cellY);
			SoundManager.playSound(SoundManager.SFX_DOOR);
		}
		
		//} endregion
		
		//{ region Private Methods
		
		private function buildMap():void
		{
			buildRoomList();
			buildGrid();
			generateEmptyMap();
			placeRooms();
			buildConnections();
			
			addWalls();
			addDoors();
			
			drawMap();
			placePlayer();
			
			//traceMap();
		}
		
		//{ region Phase 1: Initial Map/Grid Generation
		
		private function generateEmptyMap():void
		{			
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
		
		//} endregion
		
		//{ region Phase 2: Room Generation/Placement
		
		private function buildRoomList():void
		{
			rooms = new Array();
			for (var i:int = 0; i < Utils.randomRange(12, 15); i++)
			{
				rooms.push(new SmallOffice());
			}
		}
		
		private function placeRooms():void
		{
			// As rooms are placed, they are added to this array (makes it easier to find neighbors)
			sortedRooms = new Array(grid_height * grid_width);
			
			// Generate a list of cell numbers
			var cells:Array = new Array();
			for (var i:int = 0; i < grid_height * grid_width; i++) cells.push(i);
			
			for each (var r:Room in rooms)
			{
				// Assign the room a cell
				var n:int = Utils.randomRange(0, cells.length - 1);
				r.cell_num = cells[n];
				cells.splice(n, 1);
				
				// Insert cell into sorted array
				sortedRooms[r.cell_num] = r;
				
				// Place room in cell on layout
				addRoomToMap(r);
			}
		}
		
		private function addRoomToMap(room:Room):void
		{
			// Set map x and y cooridantes of room
			room.mapX = (room.cell_num % grid_width) * cell_width + 1;
			room.mapY = int(room.cell_num / grid_width) * cell_height + 1;
			
			// Add random offset within the cell
			room.mapX += Utils.randomRange(0, (cell_width - room.roomWidth - 2));
			room.mapY += Utils.randomRange(0, (cell_height - room.roomHeight - 2));
			
			// Copy room layout to map layout
			for (var i:int = 0; i < room.roomHeight; i++)
			{
				for (var j:int = 0; j < room.roomWidth; j++)
				{
					setCell(j + room.mapX, i + room.mapY, String(room.roomLayout[i]).charAt(j));
				}
			}
		}

		//} endregion
		
		//{ region Phase 3: Connecting Rooms
		
		private function buildConnections():void
		{
			var done:Boolean = false;
			var r:Room;
			var r2:Room;
			var neighborIndex:int;
			
			// Build each room's list of neighbors
			while (!done)
			{
				done = true;
				for each (r in rooms)
				{
					r.neighbors = new Array();
					buildNeighborList(r);
					
					// If room has no neighbors, make one and rebuild neighbor lists.
					if (r.neighbors.length == 0)
					{
						generateNewNeighbor(r);
						done = false;
						break;
					}
				}
			}
			
			// Start with a random room
			var curRoom:Room = rooms[Utils.randomRange(0, rooms.length - 1)];
			firstRoom = curRoom;
			curRoom.connected = true;
			
			while (getUnconnectedNeighbors(curRoom).length > 0)
			{
				var unconnectedNeighbors:Array = getUnconnectedNeighbors(curRoom);
				neighborIndex = unconnectedNeighbors[Utils.randomRange(0, unconnectedNeighbors.length - 1)];
				
				connectRooms(curRoom, sortedRooms[neighborIndex]);
				curRoom = sortedRooms[neighborIndex];
				curRoom.connected = true;
				lastRoom = curRoom;
			}
			
			// Get an array of all rooms still unconnected.
			var unconnectedRooms:Array = new Array();
			for each (r in rooms)
			{
				if (!r.connected) unconnectedRooms.push(r);
			}
			
			// Cycle through those unconnected rooms until all of them are connected.
			while (unconnectedRooms.length > 0)
			{
				for each (r in unconnectedRooms)
				{
					var connectedNeighbors:Array = getConnectedNeighbors(r);
					
					if (connectedNeighbors.length == 0) continue;
					
					neighborIndex = connectedNeighbors[Utils.randomRange(0, connectedNeighbors.length - 1)];
					
					connectRooms(r, sortedRooms[neighborIndex]);
					r.connected = true;
					lastRoom = r;
				}
				
				unconnectedRooms = new Array();
				for each (r in rooms)
				{
					if (!r.connected) unconnectedRooms.push(r);
				}
			}
			
			// Make some additional random connections
			var randomConnections:int = Utils.randomRange(MIN_RANDOM_CONNECTIONS, MAX_RANDOM_CONNECTIONS);
			for (var i:int = 0; i < randomConnections; i++)
			{
				r = rooms[Utils.randomRange(0, rooms.length - 1)];
				r2 = rooms[Utils.randomRange(0, rooms.length - 1)];
				
				connectRooms(r, r2);
			}
			
			buildDone = true;
		}
		
		private function generateNewNeighbor(r:Room):void
		{
			var neighbor:Room = new SmallOffice();
			
			// Pick a random direction to place the new room
			neighbor.cell_num = -1;
			while (neighbor.cell_num == -1)
			{
				switch (Utils.randomRange(0, 3))
				{
					case 0: //up
						if (r.cell_num - grid_width > 0) 
							neighbor.cell_num = r.cell_num - grid_width;
						break;
					case 1: //down
						if (r.cell_num + grid_width < (grid_width * grid_height))
							neighbor.cell_num = r.cell_num + grid_width;
						break;
					case 2: //right
						if ((r.cell_num % grid_width) != (grid_width - 1))
							neighbor.cell_num = r.cell_num + 1;
						break;
					case 3: //left
						if ((r.cell_num % grid_width) != 0)
							neighbor.cell_num = r.cell_num - 1;
						break;
					default:
						break;
				}
			}
			
			addRoomToMap(neighbor);
		}
		
		private function buildNeighborList(r:Room):void
		{
			var testIndex:int;
			var i:int;
				
			// scan up
			for (testIndex = (r.cell_num - grid_width); testIndex >= 0; testIndex -= grid_width)
			{
				if (sortedRooms[testIndex])
				{
					r.neighbors.push(testIndex);
					break;
				}
			}
			
			// scan down
			for (testIndex = (r.cell_num + grid_width); testIndex < (grid_width * grid_height); testIndex += grid_width)
			{
				if (sortedRooms[testIndex])
				{
					r.neighbors.push(testIndex);
					break;
				}
			}
			
			if ((r.cell_num % grid_width) != 0)
			{
				// scan left
				testIndex = r.cell_num;
				for (i = (r.cell_num % grid_width); i > 0; i--)
				{
					--testIndex;
					if (sortedRooms[testIndex])
					{
						r.neighbors.push(testIndex);
						break;
					}
				}
			}
			
			if ((r.cell_num % grid_width) < grid_width - 1)
			{
				// scan right
				testIndex = r.cell_num;
				for (i = (r.cell_num % grid_width); i < (grid_width - 1); i++)
				{
					++testIndex;
					if (sortedRooms[testIndex])
					{
						r.neighbors.push(testIndex);
						break;
					}
				}
			}
		}
		
		private function getUnconnectedNeighbors(r:Room):Array
		{
			var unconnectedNeighbors:Array = new Array();
			for each (var index:int in r.neighbors)
			{
				if (!(Room(sortedRooms[index]).connected))
				{
					unconnectedNeighbors.push(index);
				}
			}
			
			return unconnectedNeighbors;
		}
		
		private function getConnectedNeighbors(r:Room):Array
		{
			var connectedNeighbors:Array = new Array();
			for each (var index:int in r.neighbors)
			{
				if (Room(sortedRooms[index]).connected)
				{
					connectedNeighbors.push(index);
				}
			}
			
			return connectedNeighbors;
		}
		
		private function connectRooms(r1:Room, r2:Room):void
		{
			var entrance:MapPoint = new MapPoint();
			var exit:MapPoint = new MapPoint();
			
			if ((r1.cell_num - r2.cell_num) % grid_width == 0)
			{
				if (r1.cell_num > r2.cell_num) // r1 below r2
				{
					// select a point at the top of r1
					entrance = r1.topConnectPoint;
					exit = r2.bottomConnectPoint;
				}
				else // r1 above r2
				{
					// select a point at the top of r1
					entrance = r1.bottomConnectPoint;
					exit = r2.topConnectPoint;
				}
			}
			else
			{
				if (r1.cell_num > r2.cell_num) // r1 right of r2
				{
					// select a point at the top of r1
					entrance = r1.leftConnectPoint;
					exit = r2.rightConnectPoint;
				}
				else // r1 left of r2
				{
					// select a point at the top of r1
					entrance = r1.rightConnectPoint;
					exit = r2.leftConnectPoint;
				}
			}
			
			while (exit.x != entrance.x || exit.y != entrance.y)
			{				
				var neighbors:Array = new Array();
				neighbors[0] = new MapPoint(exit.x, exit.y - 1);
				neighbors[1] = new MapPoint(exit.x + 1, exit.y);
				neighbors[2] = new MapPoint(exit.x, exit.y + 1);
				neighbors[3] = new MapPoint(exit.x - 1, exit.y);
				
				var best:int = int.MAX_VALUE;
				var choice:MapPoint = null;
				for(var i:int = 0; i < neighbors.length; i++){
					var dist:int = entrance.mDist(neighbors[i]);
					if(getCell(neighbors[i].x, neighbors[i].y) != GC.MAP_FLOOR) {
						dist+=3;
					}
					if(dist < best){
						best = dist;
						choice = neighbors[i];
					}
				}
				
				exit.x = choice.x;
				exit.y = choice.y;
				
				setCell(exit.x, exit.y, GC.MAP_HALLWAY);
			}
			
			for (var row:int = 0; row <= mapHeight; row++)
			{
				for (var col:int = 0; col <= mapWidth; col++)
				{
					if (getCell(col, row) == GC.MAP_HALLWAY)
						setCell(col, row, GC.MAP_FLOOR);
				}
			}
		}
		
		//} endregion
		
		//{ region Phase 4: Drawing Map
		
		private function drawMap():void
		{
			terrainEntities = new Array(this.mapHeight);
			for (var row:int = 0; row < layout.length; row++)
			{
				terrainEntities[row] = new Array(this.mapWidth);
				for (var col:int = 0; col < layout[row].length; col++)
				{
					var cell:String = getCell(col, row);
					
					if (cell == GC.MAP_WALL)
					{
						drawWall(col, row);
					}
					else if (cell == GC.MAP_FLOOR || cell == GC.MAP_HALLWAY)
					{
						drawFloor(col, row);
					}
					else if (cell == GC.MAP_DOOR_CLOSED)
					{
						drawClosedDoor(col, row);
					}
				}
			}
		}
		
		private function drawWall(col:int, row:int):void
		{
			var wallImage:Spritemap = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(wallImage);
			
			wallImage.setFrame(getTilesheetCol(), 1);
			wallImage.alpha = 0;
			
			wallImage.x = GC.MAP_CELL_SIZE * col;
			wallImage.y = GC.MAP_CELL_SIZE * row;
			
			terrainEntities[row][col] = wallImage;
		}
		
		private function drawFloor(col:int, row:int):void
		{
			var floorImage:Spritemap = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(floorImage);
			
			floorImage.setFrame(getTilesheetCol(), 0);
			floorImage.alpha = 0;
			
			floorImage.x = GC.MAP_CELL_SIZE * col;
			floorImage.y = GC.MAP_CELL_SIZE * row;
			
			terrainEntities[row][col] = floorImage;
		}
		
		private function drawClosedDoor(col:int, row:int):void
		{	
			var doorImage:Spritemap = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(doorImage);
			
			doorImage.setFrame(0, 2);
			doorImage.alpha = 0;
			
			doorImage.x = GC.MAP_CELL_SIZE * col;
			doorImage.y = GC.MAP_CELL_SIZE * row;
			
			terrainEntities[row][col] = doorImage;
		}
		
		private function drawOpenDoor(col:int, row:int):void
		{
			var doorImage:Spritemap = new Spritemap(GFX.GFX_TERRAIN, GC.MAP_CELL_SIZE, GC.MAP_CELL_SIZE);
			this.addGraphic(doorImage);
			
			doorImage.setFrame(1, 2);
			doorImage.alpha = 0;
			
			doorImage.x = GC.MAP_CELL_SIZE * col;
			doorImage.y = GC.MAP_CELL_SIZE * row;
			
			terrainEntities[row][col] = doorImage;
		}
		
		private function addWalls():void
		{
			for (var row:int = 0; row < layout.length; row++)
			{
				for (var col:int = 0; col < layout[row].length; col++)
				{
					if (getCell(col, row) == GC.MAP_EMPTY)
					{
						var neighbors:Array = new Array();
						neighbors[0] = new MapPoint(col, row - 1);
						neighbors[1] = new MapPoint(col + 1, row);
						neighbors[2] = new MapPoint(col, row + 1);
						neighbors[3] = new MapPoint(col - 1, row);
						neighbors[4] = new MapPoint(col + 1, row - 1);
						neighbors[5] = new MapPoint(col + 1, row + 1);
						neighbors[6] = new MapPoint(col - 1, row + 1);
						neighbors[7] = new MapPoint(col - 1, row - 1);
						
						for each (var point:MapPoint in neighbors)
						{
							if (getCell(point.x, point.y) == GC.MAP_FLOOR || getCell(point.x, point.y) == GC.MAP_HALLWAY)
							{
								setCell(col, row, GC.MAP_WALL);
								break;
							}
						}
					}
				}
			}
		}
		
		//} endregion
		
		//{ region Phase 5: Populating Map
		
		private function placePlayer():void
		{
			var tile:String = "";
			playerStartPos = new MapPoint();
			
			while (tile != GC.MAP_FLOOR)
			{
				playerStartPos.x = firstRoom.mapX + Utils.randomRange(0, firstRoom.roomWidth - 1);
				playerStartPos.y = firstRoom.mapY + Utils.randomRange(0, firstRoom.roomHeight - 1);
				tile = getCell(playerStartPos.x, playerStartPos.y);
			}
		}
		
		private function addDoors():void
		{
			for (var row:int = 0; row < layout.length; row++)
			{
				for (var col:int = 0; col < layout[row].length; col++)
				{
					var selectedCell:String = getCell(col, row);
					if (selectedCell == GC.MAP_FLOOR)
					{
						var neighbors:Array = new Array();
						neighbors[0] = new MapPoint(col, row - 1);
						neighbors[1] = new MapPoint(col + 1, row);
						neighbors[2] = new MapPoint(col, row + 1);
						neighbors[3] = new MapPoint(col - 1, row);
						neighbors[4] = new MapPoint(col + 1, row - 1);
						neighbors[5] = new MapPoint(col + 1, row + 1);
						neighbors[6] = new MapPoint(col - 1, row + 1);
						neighbors[7] = new MapPoint(col - 1, row - 1);
						
						var borderingFloorTiles:int = 0;
						for each (var point:MapPoint in neighbors)
						{
							var neighborCell:String = getCell(point.x, point.y);
							if (neighborCell == GC.MAP_DOOR_CLOSED)
							{
								borderingFloorTiles = 0;
								break;
							}
							
							if (neighborCell == GC.MAP_FLOOR || neighborCell == GC.MAP_HALLWAY)
							{
								++borderingFloorTiles;
							}
						}
						
						if (borderingFloorTiles == 3 || borderingFloorTiles == 4)
						{
							if ((getCell(neighbors[0].x, neighbors[0].y) == GC.MAP_WALL && getCell(neighbors[2].x, neighbors[2].y) == GC.MAP_WALL) ||
							    (getCell(neighbors[1].x, neighbors[1].y) == GC.MAP_WALL && getCell(neighbors[3].x, neighbors[3].y) == GC.MAP_WALL))
							{
								setCell(col, row, GC.MAP_DOOR_CLOSED);
							}
						}
					}
				}
			}
		}
		
		//} endregion
		
		//{ region Misc
		
		private function setCell(cellX:int, cellY:int, data:String):void
		{
			var curRow:String = this.layout[cellY];
			this.layout[cellY] = curRow.substr(0,cellX) + data + curRow.substr(cellX + 1);
		}
		
		public function light(x:int, y:int, val:Number):void
		{
			var tile:Spritemap = terrainEntities[y][x];
			
			if (tile == null || tile.alpha == (val/100)) return;
			
			if (tile.alpha > 0 && val < 20) val = 20;
			
			if (tile.alpha == 0 && val > 0)
			{
				GameWorld(FP.world).revealMinimap(x, y, getCell(x,y));
			}
			
			var lightTween:VarTween = new VarTween(null,Tween.ONESHOT);
			lightTween.tween(tile, "alpha", (val / 100), 0.3, Ease.quadIn);
			this.addTween(lightTween, true);
			
			//tile.alpha = val / 100;
		}
		
		public function blocksLight(x:int, y:int):Boolean
		{
			var tile:String = getCell(x, y);
			if (tile == GC.MAP_WALL || tile == GC.MAP_DOOR_CLOSED)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function getTilesheetCol():int
		{
			if (Math.random() > 0.97)
			{
				return Utils.randomRange(1, 6);
			}
			else
			{
				return 0;
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
		
		//} endregion
		
		//} endregion
		
		
		
		//{ region Public Accessors
		
		public function get playerStartPosition():MapPoint
		{
			return playerStartPos;
		}
		
		public function get mapWidth():int
		{
			return this.grid_width * this.cell_width;
		}
		
		public function get mapHeight():int
		{
			return this.grid_height * this.cell_height;
		}
		
		//} endregion
		
	}

}


