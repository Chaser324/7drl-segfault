package com.cp.sf 
{
	import net.flashpunk.utils.BasePreloader;
	
	/**
	 * ...
	 * @author 
	 */
	public class Preloader extends BasePreloader 
	{		
		public function Preloader()
		{
			mainClass = com.cp.sf.sf;
			minTime = 60;
			super();
		}
		
	}

}