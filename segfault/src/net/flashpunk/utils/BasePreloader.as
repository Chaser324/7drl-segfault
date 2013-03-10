package net.flashpunk.utils  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.getDefinitionByName;
	
	/**
	 * A simple, reusable preloader, FlashPunk Style!
	 * @author	Redkast
	 */
	public class BasePreloader extends MovieClip 
	{
		/**
		 * Edit these values in your preloader class to
		 * get the correct main class and game dementions
		 */
		public var mainClass:Class;
		public var bounds:Rectangle = new Rectangle(0, 0, 700, 600);
		//The minimum amout of time to display the preloader. Default '0' or any time.
		public var minTime:int = 0;
		
		/**
		 * Other variables to handle the animation and timing.
		 */
		//The Flashpunk logo, in classic retro style
		[Embed(source="../../../../assets/gfx/100x100strip.png")] private var _s:Class;
		//animation count
		private var count:int = 0;
		//t(ime)
		private var t:int = 0;
		//drawing buffer and background
		public var buffer:BitmapData;
		private var background:Bitmap;
		private var addedComplete:Boolean = false;
		
		/**
		 * Initialize the preloader.
		 */
		public function BasePreloader()
		{addEventListener(Event.ADDED_TO_STAGE, start); }
		/**
		 * Start the animation and add a few listeners.
		 * @param	e	The ADDED_TO_STAGE event.
		 */
		private function start(e:Event):void
		{
			//make sure we're in the top left corner with no scaling
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//add a few listeners
			addEventListener(Event.ENTER_FRAME, onFrame);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			//create the bitmap we're going to draw everything on
			buffer = new BitmapData(bounds.width / 2, bounds.height / 2, false, 0xFF202020);
			background = new Bitmap(buffer);
			background.scaleX = background.scaleY = 2;
			addChild(background);
		}
		public function onFrame(e:Event):void
		{
			//if t(ime) is a multiple of 2...
			if ((t % 2) == 0)
			{
				//...draw the next frame of logo animation
				buffer.copyPixels((new _s).bitmapData, new Rectangle(count * 100, 0, 100, 100), new Point((bounds.width / 4) - 50, (bounds.height / 4) -50));
				//add one to the count or loop back to 0 at the end
				(count < 4) ? count ++: count = 0;
			}
			//draw the loading bar based on loaderInfo values
			buffer.fillRect(new Rectangle(0, (bounds.height / 2) - 25, ((loaderInfo.bytesLoaded / loaderInfo.bytesTotal) * (bounds.width / 2)), 25), 0xFFFF3366);
			//add a frame to the t(ime)
			t ++;
			if (t >= minTime)
			{
				if ((loaderInfo.bytesLoaded / loaderInfo.bytesTotal) == 1)
					loadingFinished();
			}
		}
		/**
		 * Uh-oh! loading error!
		 * @param	e
		 */
		private function ioError(e:IOErrorEvent):void { trace(e.text); }
		/**
		 * All done with the loading.
		 */
		public function loadingFinished():void 
		{
			//remove thoes listeners to clear memory
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			removeEventListener(Event.ENTER_FRAME, onFrame);
			//remove the drawing bitmap
			removeChild(background);
			
			//create the main class, and add it to the stage
			var m:DisplayObject = new mainClass() as DisplayObject;
			addChild(m);
		}
	}
}