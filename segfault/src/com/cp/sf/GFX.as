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
		
		[Embed(source="../../../../assets/ui/ui-phone.png")]
		public static const GFX_UI_PHONE:Class;
		
		[Embed(source="../../../../assets/ui/ui-icons.png")]
		public static const GFX_UI_ICONS:Class;
	}

}