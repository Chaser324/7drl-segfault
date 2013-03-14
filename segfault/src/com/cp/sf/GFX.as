package com.cp.sf 
{
	/**
	 * Container for Embedding Graphics
	 */
	public final class GFX 
	{
		/**
		 * FONTS
		 */
		
		[Embed(source="../../../../assets/fonts/cour.ttf", embedAsCFF="false", fontFamily="Courier")]
		public static const GFX_FONT_COURIER:Class;
		
		/**
		 * TEXT
		 */
		
		[Embed(source="../../../../assets/text/about.txt",mimeType="application/octet-stream")]
		public static const GFX_TEXT_ABOUT:Class;
		
		/**
		 * GAME SPRITES
		 */
		
		[Embed(source="../../../../assets/gfx/terrain.png")]
		public static const GFX_TERRAIN:Class;
		
		[Embed(source = "../../../../assets/gfx/player.png")]
		public static const GFX_PLAYER:Class;
		
		/**
		 * UI
		 */
		
		[Embed(source="../../../../assets/gfx/ui/ui-phone.png")]
		public static const GFX_UI_PHONE:Class;
		
		[Embed(source="../../../../assets/gfx/ui/ui-icons.png")]
		public static const GFX_UI_ICONS:Class;
		
		/**
		 * MENU
		 */
		
		[Embed(source="../../../../assets/gfx/menu/menu-overlay.png")]
		public static const GFX_MENU_OVERLAY:Class;
		
		/**
		 * TITLE SCREEN
		 */
		
		[Embed(source="../../../../assets/gfx/title/title-bg.png")]
		public static const GFX_TITLE_BG:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-about-button.png")]
		public static const GFX_TITLE_ABOUT_BUTTON:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-options-button.png")]
		public static const GFX_TITLE_OPTIONS_BUTTON:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-start-button.png")]
		public static const GFX_TITLE_START_BUTTON:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-heading.png")]
		public static const GFX_TITLE_HEADING:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-back.png")]
		public static const GFX_TITLE_BACK:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-gunshot-1.png")]
		public static const GFX_TITLE_GUNSHOT1:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-gunshot-2.png")]
		public static const GFX_TITLE_GUNSHOT2:Class;
		
		[Embed(source="../../../../assets/gfx/title/title-gunshot-3.png")]
		public static const GFX_TITLE_GUNSHOT3:Class;
	}

}