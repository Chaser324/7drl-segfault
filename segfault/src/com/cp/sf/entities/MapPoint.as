package com.cp.sf.entities 
{
	/**
	 * ...
	 * @author 
	 */
	public class MapPoint 
	{
		
		public var x:int;
		public var y:int;
		public var tile:String;
		
		public function MapPoint(x:int = 0, y:int = 0, tile:String = "#")
		{
			this.x = x;
			this.y = y;
			this.tile = tile;
		}
		
		public function mDist(p:MapPoint):Number
		{
			return Math.abs(p.x - this.x) + Math.abs(p.y - y);
		}
		
	}

}