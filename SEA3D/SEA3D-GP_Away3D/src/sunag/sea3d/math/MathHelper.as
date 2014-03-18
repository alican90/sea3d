package sunag.sea3d.math
{
	

	public class MathHelper
	{
		public static const RADIANS:Number = Math.PI/180;
		public static const DEGREES:Number = 180/Math.PI;
		
		public static function angleDifferenceRad(x:Number, y:Number):Number
		{
			return Math.atan2(Math.sin(x-y), Math.cos(x-y));
		}
		
		public static function angleDifference(x:Number, y:Number):Number
		{
			x = x * RADIANS;
			y = y * RADIANS;
			return Math.atan2(Math.sin(x-y), Math.cos(x-y)) * DEGREES;
		}
		
		public static function angleArea(angle:Number, target:Number, area:Number):Boolean
		{
			return Math.abs( angleDifference(angle,target) ) <= area;
		}
		
		public static function zero(val:Number, lim:Number=1.0E-3):Number
		{
			var pValue:Number = val < 0 ? -val : val;			
			if (pValue - lim < 0) val = 0;			
			return lim;			
		}
		
		public static function round(val:Number, lim:Number=1E-6):Number
		{			
			return Math.round(val * lim) / lim;
		}
		
		public static function isPowerOfTwo(num:uint):Boolean
		{			
			return num ? ((num & -num) == num) : false;
		}
		
		public static function nearestPowerOfTwo(num:uint):uint
		{
			return Math.pow( 2, Math.round( Math.log( num ) / Math.LN2 ) );
		}
		
		public static function lowerPowerOfTwo(num:uint):uint
		{
			return upperPowerOfTwo(num) >> 1;
		}
		
		public static function upperPowerOfTwo(num:uint):uint
		{
			if (num == 1) return 2;
			
			num--;
			num |= num >> 1;
			num |= num >> 2;
			num |= num >> 4;
			num |= num >> 8;
			num |= num >> 16;
			
			return num++;
		}
		
		public static function angleLimit(val:Number, lim:Number):Number			
		{
			if (val > lim) val = lim;
			else if (val < -lim) val = -lim;
			return val;
		}
		
		public static function angle(val:Number):Number			
		{
			const ang:Number = 180;
			var inv:Boolean = val < 0;
			
			val = (inv ? -val : val) % 360;
			
			if (val > ang)			
			{
				val = -ang + (val - ang);
			}
			
			return (inv ? -val : val);			
		}
		
		public static function invertAngle(val:Number):Number
		{
			return angle(val + 180);
		}
		
		public static function absAngle(val:Number):Number
		{
			if (val < 0) return 180 + (180 + val);										
			return val;
		}
		
		public static function lerp(val:Number, tar:Number, t:Number):Number
		{
			return val + ((tar - val) * t);
		}
						
		public static function lerpColor(val:Number, tar:Number, t:Number):Number
		{
			var a0:Number = val >> 24 & 0xff;
			var r0:Number = val >> 16 & 0xff;
			var g0:Number = val >> 8 & 0xff;
			var b0:Number = val & 0xff;
			
			var a1:Number = tar >> 24 & 0xff;
			var r1:Number = tar >> 16 & 0xff;
			var g1:Number = tar >> 8 & 0xff;
			var b1:Number = tar & 0xff;
			
			a0 += (a1 - a0) * t;
			r0 += (r1 - r0) * t;
			g0 += (g1 - g0) * t;
			b0 += (b1 - b0) * t;
			
			return a0 << 24 | r0 << 16 | g0 << 8 | b0;
		}
		
		public static function lerpAngle(val:Number, tar:Number, t:Number):Number			
		{				
			if (Math.abs(val - tar) > 180)
			{
				if (val > tar) 
				{		
					tar += 360;				
				}
				else 
				{
					tar -= 360;				
				}
			}
			
			val += (tar - val) * t;
			
			return angle(val);
		}
		
		public static function physicLerp(val:Number, to:Number, delta:Number, speed:Number):Number			
		{
			return val + ( (to - val) * (speed * delta) );
		}
		
		public static function physicLerpAngle(val:Number, to:Number, delta:Number, speed:Number):Number			
		{				
			if (Math.abs(val - to) > 180)
			{
				if (val > to) 
				{		
					to += 360;				
				}
				else 
				{
					to -= 360;				
				}
			}
			
			return angle( val + ( (to - val) * (speed * delta) ) );			
		}
	}
}