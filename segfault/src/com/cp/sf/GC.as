package com.cp.sf 
{
	/**
	 * Global Constants
	 */
	public final class GC 
	{
		/**
		 * GAME WORLD CONSTANTS
		 */
		public static const MAP_CELL_SIZE:int = 32; // Height/Width in pixels of a single map sprite
		public static const MAP_WIDTH_MAX:int = 128; // Max width in cells of a map
		public static const MAP_WIDTH_MIN:int = 96; // Min width in cells of a map
		public static const MAP_HEIGHT_MAX:int = 128; // Max height in cells of a map
		public static const MAP_HEIGHT_MIN:int = 96; // Min height in cells of a map
		
		/**
		 * MAP CELL TYPES
		 */
		public static const MAP_EMPTY:String = "#";

		public static const MAP_FLOOR:String = "f";
		
		public static const MAP_WALL:String = "w";
		public static const MAP_WALL_NO_DOOR:String = "W";
		
		public static const MAP_STAIRS_UP:String = "S";
		public static const MAP_STAIRS_DOWN:String = "s";
		
		public static const MAP_DOOR:String = "d";
		public static const MAP_DOOR_CLOSED:String = "D";
		
		/**
		 * DIRECTIONS
		 */
		public static const DIR_NULL:int = -1;
		public static const DIR_UP:int = 0;
		public static const DIR_DOWN:int = 1;
		public static const DIR_LEFT:int = 2;
		public static const DIR_RIGHT:int = 3;
		
	}

}