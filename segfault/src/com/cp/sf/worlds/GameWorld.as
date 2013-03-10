package com.cp.sf.worlds 
{
	import com.cp.sf.entities.Map;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameWorld extends World 
	{
		protected var map:Map;
		
		public function GameWorld() 
		{
			super();
		}
		
		override public function begin():void
		{
			map = new Map();
			this.add(map);
		}
		
	}

}