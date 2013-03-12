package com.cp.sf.worlds 
{
	import com.cp.sf.entities.Map;
	import com.cp.sf.entities.Player;
	import com.cp.sf.GC;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author 
	 */
	public class GameWorld extends World 
	{
		protected var map:Map;
		protected var player:Player;
		
		protected var cameraVX:Number = 0;
		protected var cameraVY:Number = 0;
		
		public function GameWorld() 
		{
			super();
		}
		
		override public function begin():void
		{
			map = new Map();
			this.add(map);
			
			player = new Player(map.playerStartPosition.x, map.playerStartPosition.y);
			this.add(player);
			
			super.begin();
		}
		
		override public function update():void
		{
			followPlayer();
			
			super.update();
		}
		
		public function getMapTerrain(mapX:int, mapY:int):Object
		{
			return this.map.getCellObject(mapX, mapY);
		}
		
		private function followPlayer():void
		{
			FP.camera.x = (player.x + player.width / 2) - FP.width / 2;
			FP.camera.y = (player.y + player.height / 2) - FP.height / 2;
			
			//if (player.x - FP.camera.x < GC.CAMERA_OFFSET)
			//{
				//cameraVX -= GC.CAMERA_SPEED;
			//}
			//else if ((FP.camera.x + FP.width) - (player.x + player.width) < GC.CAMERA_OFFSET)
			//{
				//cameraVX += GC.CAMERA_SPEED;
			//}
			//else
			//{
				//cameraVX *= GC.CAMERA_FRICTION;
			//}
			//
			//if (player.y - FP.camera.y < GC.CAMERA_OFFSET)
			//{
				//cameraVY -= GC.CAMERA_SPEED;
			//}
			//else if ((FP.camera.y + FP.height) - (player.y + player.height) < GC.CAMERA_OFFSET)
			//{
				//cameraVY += GC.CAMERA_SPEED;
			//}
			//else
			//{
				//cameraVY *= GC.CAMERA_FRICTION;
			//}
			//
			//cameraVX = FP.clamp(cameraVX, -GC.PLAYER_MAX_SPEED, GC.PLAYER_MAX_SPEED);
			//cameraVY = FP.clamp(cameraVY, -GC.PLAYER_MAX_SPEED, GC.PLAYER_MAX_SPEED);
			//
			//FP.camera.x += cameraVX;
			//FP.camera.y += cameraVY;
		}
		
	}

}