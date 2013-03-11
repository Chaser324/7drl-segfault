package com.cp.sf 
{
	import com.cp.sf.Preloader;
	import com.cp.sf.worlds.GameWorld;
	import flash.display.StageQuality;
	import flash.events.FullScreenEvent;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Data;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	import flash.ui.ContextMenu;

	
	/**
	 * 
	 */
	[SWF(width = '800', height = '600', frameRate='60', backgroundColor = '#000000')]
	// TODO: finish preloader - [Frame(factoryClass = "com.cp.tde.Preloader")]
	public class sf extends Engine
	{
		
		public function sf() 
		{
			super(800, 600, 60, false);
		}
		
		override public function init():void
		{
			super.init();
			
			//FP.console.enable();

			FP.screen.scale = 1;

			Data.prefix = "ChasePettit";
			Data.id = "segfault-roguelike";
			Data.load("segfault-roguelike/preferences");

			GV.volumeMusic = Data.readBool("music") ? 1 : 0;
			GV.volumeSound = Data.readBool("sound") ? 1 : 0;

			Text.size = 16;

			Input.define("up", Key.W);
			Input.define("left", Key.A);
			Input.define("right", Key.D);
			Input.define("down", Key.S);

			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// TODO: Insert site-locking code here.
			FP.world = new GameWorld;

			//SoundManager.i.currentMusic = SoundManager.i.menuMusic;
		}
		
		override public function setStageProperties():void
		{
			super.setStageProperties();
			
			GV.fullscreen = false;
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.quality = StageQuality.LOW;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreen);
		}

		override public function update():void
		{
			super.update();

			Utils.quake.update();
			Utils.flash.update();
		}

		override public function render():void
		{
			super.render();

			Utils.flash.render();
		}
		
		private function handleFullScreen(e:FullScreenEvent):void
		{
			if (e.fullScreen) {
				var scale:Number;
				GV.fullscreen = true;
				if (FP.screen.width / FP.screen.height < FP.stage.fullScreenWidth / FP.stage.fullScreenHeight) {
					scale = FP.stage.fullScreenHeight / FP.height;
					FP.screen.x = FP.stage.fullScreenWidth / 2 - FP.halfWidth * scale;
				}
				else {
					scale = FP.stage.fullScreenWidth / FP.width;
					FP.screen.y = FP.stage.fullScreenHeight/ 2 - FP.halfHeight * scale;
				}
				FP.screen.scale = scale;
			} else {
				GV.fullscreen = false;
				FP.screen.scale = 1;
				FP.screen.x = FP.screen.y = 0;
			}
		}
		
	}

}