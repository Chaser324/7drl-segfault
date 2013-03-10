package com.cp.sf.entities.rooms 
{
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author 
	 */
	public class Room extends Entity
	{
		protected var layout:Array;
		
		public function Room() 
		{
			super();
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