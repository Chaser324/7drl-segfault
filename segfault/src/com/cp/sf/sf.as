package com.cp.sf 
{
	import com.cp.sf.Preloader;
	import com.cp.sf.worlds.CharCreateWorld;
	import com.cp.sf.worlds.GameWorld;
	import com.cp.sf.worlds.TitleWorld;
	import flash.display.StageDisplayState;
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
	[SWF(width = '800', height = '600', backgroundColor = '#000000')]
	// TODO - [Frame(factoryClass = "com.cp.sf.Preloader")]
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
			FP.screen.color = 0x000000;

			Data.prefix = "ChasePettit";
			Data.id = "segfault-roguelike";
			Data.load("segfault-roguelike/preferences");

			GV.volumeMusic = Data.readBool("music") ? 1 : 0;
			GV.volumeSound = Data.readBool("sound") ? 1 : 0;

			Text.size = 16;

			Input.define("up", Key.W, Key.UP);
			Input.define("left", Key.A, Key.LEFT);
			Input.define("right", Key.D, Key.RIGHT);
			Input.define("down", Key.S, Key.DOWN);
			
			Input.define("map", Key.M);
			
			Input.define("fullscreen", Key.F2);
			
			Input.define("back", Key.BACKSPACE);

			contextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();

			// TODO: Insert site-locking code here.
			FP.world = new TitleWorld();
		}
		
		override public function setStageProperties():void
		{
			super.setStageProperties();
			
			GV.fullscreen = false;
			//stage.scaleMode = StageScaleMode.SHOW_ALL;
			stage.quality = StageQuality.HIGH;
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handleFullScreen);
		}

		override public function update():void
		{
			if (Input.pressed("fullscreen"))
			{
				toggleFullScreen();
			}
			
			super.update();

			Utils.quake.update();
			Utils.flash.update();
		}

		override public function render():void
		{
			super.render();

			Utils.flash.render();
		}
		
		private function toggleFullScreen():void
		{
			if (stage.displayState == StageDisplayState.NORMAL)
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{
				//stage.displayState = StageDisplayState.NORMAL;
			}
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