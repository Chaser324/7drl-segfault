package com.cp.sf.worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author 
	 */
	public class CharCreateWorld extends World 
	{
		
		public function CharCreateWorld() 
		{
			
		}
		
		override public function begin():void
		{
			super.begin();
		}
		
		override public function update():void
		{
			FP.world = new IntroWorld(6);
			super.update();
		}
		
	}

}