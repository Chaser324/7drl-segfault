package com.cp.sf.entities.rooms 
{
	import com.cp.sf.GC;
	import com.cp.sf.Utils;
	/**
	 * ...
	 * @author 
	 */
	public class SmallOffice extends Room
	{
		private static const MIN_SIDE:int = 5;
		private static const MAX_SIDE:int = 8;
		
		
		public function SmallOffice() 
		{
			super();
		}
		
		override protected function generateLayout():void
		{
			var height:int = Utils.randomRange(MIN_SIDE, MAX_SIDE);
			var width:int = Utils.randomRange(MIN_SIDE, MAX_SIDE);
			
			this.layout = new Array(height);
			
			for (var i:int = 0; i < height; i++)
			{
				this.layout[i] = new String();
				for (var j:int = 0; j < width; j++)
				{
					this.layout[i] = String(this.layout[i]).concat(GC.MAP_FLOOR);
				}
			}
		}
	}

}