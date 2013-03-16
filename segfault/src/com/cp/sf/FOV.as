package com.cp.sf 
{
	import com.cp.sf.entities.ILitObject;
	import com.cp.sf.entities.Map;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author 
	 */
	public class FOV 
	{
		private var map:Map;
		private var terrainHeight:int;
		private var terrainWidth:int;
		
		private static const SIGHT_DIAMETER:int = 12;
		
		private static const DIRS:Array = [ [ 0, -1],
											[ 1,  0],
											[ 0,  1],
											[-1,  0]
										];
		
		public function FOV(map:Map) 
		{
			this.map = map;
			terrainHeight = map.mapHeight;
			terrainWidth = map.mapWidth;
		}
		
		public function compute(sx:int, sy:int):void
		{
			var i:int;
			
			// paint it black
			//for (i = sx - 10; i < sx + 10; i++)
			//{
				//for (var j:int = sy - 10; j < sy + 10; j++)
				//{
					//if (j >= 0 && j < terrainHeight && i >= 0 && i < terrainWidth)
						//map.light(i, j, 0);
				//}
			//}
			
			var doneCells:Array = new Array();
			var litCells:Array = new Array();
			
			// emit light from sx,sy
			emitLight(sx, sy, litCells);
			doneCells[sy * terrainWidth + sx] = 1;
			// TODO: computeEmitters
			
			for (i = 0; i < litCells.length; i++)
			{
				var x:int = i % terrainWidth;
				var y:int = i / terrainWidth;
				if (y >= 0 && y < terrainHeight && x >= 0 && x < terrainWidth)
				{
					if (litCells[i] != null)
					{
						map.light(x, y, litCells[i]);
					}
					else if (x != sx && y != sy)
					{
						map.light(x, y, 0);
					}
				}
			}
			
			map.light(sx, sy, 100);
		}
		
		private function emitLight(sx:int, sy:int, litCells:Array):void
		{
			var fov:Array = updateFov(sx, sy);
			
			for (var i:int = 0; i < fov.length; i++)
			{
				if (fov[i] == null) continue;
				
				var formFactor:Number = fov[i];
				var result:Number;
				if (litCells[i] != null)
				{
					result = litCells[i];
				}
				else
				{
					result = 0;					
				}
				
				result += Math.round(100 * formFactor);
				
				litCells[i] = result;
			}
		}
		
		private function updateFov(sx:int, sy:int):Array
		{
			var cache:Array = [];
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
				var neighborCount:int = neighbors.length;
				
				for (var i:int = 0; i < neighborCount; i++)
				{
					cx = neighbors[i][0];
					cy = neighbors[i][1];
					A1 = [ (i?(2 * i - 1):(2 * neighborCount - 1)), (2 * neighborCount)];
					A2 = [ (2 * i + 1), (2 * neighborCount)];
					
					blocks = !this.lightPasses(cx, cy);
					visibility = this.checkVisibility(A1, A2, blocks, shadows);
					if (visibility) {
						var formFactor:Number = visibility * (1 - r / SIGHT_DIAMETER);
						if (formFactor != 0) cache[cy * terrainWidth + cx] = formFactor;
					}
					if (shadows.length == 2 && shadows[0][0] == 0 && shadows[1][0] == shadows[1][1]) 
					{ 
						return cache; 
					}
				}
			}
			
			return cache;
		}
		
		private function checkVisibility(A1:Array, A2:Array, blocks:Boolean, shadows:Array):Number
		{
			var old:Array;
			var diff:Number;
			
			if (A1[0] > A2[0])
			{
				var v1:Number = this.checkVisibility(A1, [ A1[1], A1[1]], blocks, shadows);
				var v2:Number = this.checkVisibility([0, 1], A2, blocks, shadows);
				return (v1 + v2) / 2;
			}
			
			var index1:int = 0;
			var edge1:Boolean = false;
			while (index1 < shadows.length)
			{
				old = shadows[index1];
				diff = old[0] * A1[1] - A1[0] * old[1];
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
				old = shadows[index2];
				diff = A2[0] * old[1] - old[0] * A2[1];
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
			if (y >= 0 && y < terrainHeight && x >= 0 && x < terrainWidth)
				return !(map.blocksLight(x,y));
			else
				return false;
		}
		
		private function getCircle(sx:int, sy:int, r:int):Array
		{
			var result:Array = [];
			var x:int = sx + (-r);
			var y:int = sy + r;
			
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