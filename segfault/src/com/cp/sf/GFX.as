package com.cp.sf 
{
	/**
	 * Container for Embedding Graphics
	 */
	public final class GFX 
	{
		[Embed(source="../../../../assets/terrain.png")]
		public static const GFX_TERRAIN:Class;
		
		[Embed(source = "../../../../assets/player.png")]
		public static const GFX_PLAYER:Class;
	}

}