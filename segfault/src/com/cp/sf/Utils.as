package com.cp.sf 
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import net.flashpunk.FP;
	
	/**
	 * Static Utility Functions
	 */
	public final class Utils 
	{
		public static var quake:Quake = new Quake;
		public static var flash:Flash = new Flash;

		public static function openURL(url:String):void
		{
			navigateToURL(new URLRequest(url));
		}

		public static function pan(centerX:Number):Number
		{
			return ((centerX-FP.camera.x) / FP.width) * 2 - 1;
		}
		
		/**
		 * 
		 * @param	angle An angle in degrees.
		 * @return The angle normalized to the range of 0 to 360.
		 */
		public static function normalizeAngle(angle:Number):Number
		{	
			var retVal:Number = angle % 360;
			
			if (retVal < 0)
			{
				retVal += 360;
			}
			
			return retVal;
		}
		
		/**
		 * Get a random number within a range.
		 * @param	minNum Lowest allowed number.
		 * @param	maxNum Highest allowed number.
		 * @param	decimal Set to true to get a floating point number. Otherwise, an integer is returned.
		 * @return
		 */
		public static function randomRange(minNum:Number, maxNum:Number, decimal:Boolean=false):Number
		{
			var retVal:Number = (Math.random() * (maxNum - minNum)) + minNum;
			
			if (!decimal)
			{
				retVal = int(retVal);
			}
			
			return retVal;
		}
		
	}

}