package com.cp.sf 
{
	import com.cp.sf.entities.ILitObject;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author 
	 */
	public class FOV 
	{
		private var terrain:Array;
		private var terrainHeight:int;
		private var terrainWidth:int;
		
		private static const SIGHT_DIAMETER:int = 3;
		
		private static const DIRS:Array = [ [ 0, -1],
											[ 1, -1],
											[ 1,  0],
											[ 1,  1],
											[ 0,  1],
											[-1,  1],
											[-1,  0],
											[-1, -1]
										];
		
		public function FOV(terrain:Array) 
		{
			this.terrain = terrain;
			terrainHeight = terrain.length;
			terrainWidth = Array(terrainHeight[0]).length;
		}
		
		public function compute(sx:int, sy:int):void
		{
			var doneCells:Array = new Array();
			var litCells:Array = new Array();
			
			// emit light from sx,sy
			emitLight(sx, xy);
		}
		
		private function emitLight(sx:int, sy:int):void
		{
			var fov:Array = updateFov(sx, sy);
		}
		
		private function updateFov(sx:int, sy:int):void
		{
			var shadows:Array = [];
			var cx:int;
			var cy:int;
			var A1:Array;
			var A2:Array;
			var blocks:Boolean;
			var visibility:Number;
			
			for (var r:int = 1; r <= SIGHT_DIAMETER; r++)
			{
				var neighbors:Array = getCircle(sx, sy, r);
				var neighborCount = neighbors.length;
				
				for (var i:int = 0; i < neighborCount; i++)
				{
					cx = neighbors[i][0];
					cy = neighbors[i][1];
					A1 = [ (i?2 * i - 1:2 * neighborCount - 1), (2 * neighborCount)];
					A2 = [ (2 * i + 1), (2 * neighborCount)];
					
					blocks = !this.lightPasses(cx, cy);
					visibility = this.checkVisibility(A1, A2, blocks, shadows);
				}
			}
		}
		
		private function checkVisibility(A1:Array, A2:Array, blocks:Boolean, shadows:Array):Number
		{
			if (A1[0] > A2[0])
			{
				var v1 = this.checkVisibility(A1, [ A1[1], A1[1]], blocks, shadows);
				var v2 = this.checkVisibility([0, 1], A2, blocks, shadows);
				return (v1 + v2) / 2;
			}
			
			var index1:int = 0;
			var edge1:Boolean = false;
			while (index1 < shadows.length)
			{
				var old:Array = shadows[index1];
				var diff:Number = old[0] * A1[1] - A1[0] * old[1];
				if (diff >= 0)
				{
					if (diff == 0 && !(index1 % 2)) 
					{
						edge1 = true;
					}
					break;
				}
				index1++;
			}
			
			var index2:int = shadows.length;
			var edge2:Boolean = false;
			while (index2--)
			{
				var old:Array = shadows[index2];
				var diff:Number = A2[0] * old[1] - old[0] * A2[1];
				if (diff >= 0)
				{
					if (diff == 0 && (index2 % 2))
					{
						edge2 = true;
					}
					break;
				}
			}
			
			var visible:Boolean = true;
			if (index1 == index2 && (edge1 || edge2)) { visible = false; }
			else if (edge1 && edge2 && index1 + 1 == index2 && (index2 % 2)) { visible = false; }
			else if (index1 > index2 && (index1 % 2)) { visible = false; }
			
			if (!visible) { return 0; }
			
			var visibleLength:Number;
			var P:Array;
			var remove:int = index2 - index1 + 1;
			if (remove % 2)
			{
				if (index1 % 2)
				{
					P = shadows[index1];
					visibleLength = (A2[0] * P[1] - P[0] * A2[1]) / (P[1] * A2[1]);
					if (blocks) { shadows.splice(index1, remove, A2); }
				}
				else
				{
					P = shadows[index2];
					visibleLength = (P[0] * A1[1] - A1[0] * P[1]) / (A1[1] * P[1]);
					if (blocks) { shadows.splice(index1, remove, A1); }
				}
			}
			else
			{
				if (index1 % 2)
				{
					var P1:Array = shadows[index1];
					var P2:Array = shadows[index2];
					visibleLength = (P2[0] * P1[1] - P1[0] * P2[1]) / (P1[1] * P2[1]);
					if (blocks) { shadows.splice(index1, remove); }
				}
				else
				{
					if (blocks) { shadows.splice(index1, remove, A1, A2); }
					return 1;
				}
			}
			
			var arcLength:Number = (A2[0] * A1[1] - A1[0] * A2[1]) / (A1[1] * A2[1]);
			
			return visibleLength / arcLength;
		}
		
		private function lightPasses(x:int, y:int):Boolean
		{
			return !(ILitObject(terrain[y][x]).blocksLight());
		}
		
		private function getCircle(sx:int, sy:int, r:int):Array
		{
			var result:Array = [];
			var x = sx + (-r);
			var y = sy + r;
			
			for (var i:int = 0; i < DIRS.length; i++)
			{
				for (var j:int = 0; j < (r * 2); j++)
				{
					result.push([x, y]);
					x += DIRS[i][0];
					y += DIRS[i][1];
				}
			}
			
			return result;
		}
		
	}

}