package com.cp.sf.entities.rooms 
{
	import com.cp.sf.Utils;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author 
	 */
	public class Room extends Entity
	{
		// The number of the cell assigned to this room
		public var cell_num:int;
		
		// The map cooridinates of this room's origin (top left cell)
		public var mapX:int;
		public var mapY:int;
		
		protected var layout:Array;
		
		public function Room() 
		{
			super();
		}
		
		public function get leftConnectPoint():Array
		{
			var retVal:Array = [ 0, Utils.randomRange(1, this.roomHeight - 2) ];
			return retVal;
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