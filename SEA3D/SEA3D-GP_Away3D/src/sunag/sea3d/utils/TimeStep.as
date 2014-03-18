package sunag.sea3d.utils
{
	import flash.display.Stage;
	import flash.utils.getTimer;
	
	import sunag.sea3dgp;	

	use namespace sea3dgp;
	
	public class TimeStep
	{	
		private static const FRAME_RATE:int = 60;
		
		private static var time:Number = 0;
		private static var oldTime:int = 0;
		private static var step:int = 0;
		private static var timeScale:Number = 1;
		private static var deltaTime:Number = 0;
		private static var delta:Number = 0;
				
		sea3dgp static function init(stage:Stage):void
		{
		}
		
		sea3dgp static function update():void
		{
			var t:int = getTimer();		
			
			step = t - oldTime;
			deltaTime =  step / 1000;			
			
			if (deltaTime > .25) 
				deltaTime = .25;			
			
			delta = deltaTime * FRAME_RATE;
		}
		
		sea3dgp static function updateTime():void
		{									
			time += getStep() * timeScale;
			
			oldTime = getTimer();	
		}
		
		/**
		 * Value of frame rate of the application for calculating the delta value.
		 * 
		 * @see #getDelta
		 * */
		public static function getFixedFrameRate():Number
		{
			return FRAME_RATE;
		}
		
		/**
		 * Return delta time.
		 * */
		public static function getDelta():Number
		{
			update();			
			return delta * timeScale;
		}
		
		/**
		 * Return time in milliseconds of an update to another.
		 * */
		public static function getStep():Number
		{
			update();
			return step;
		}
		
		/**
		 * Return total time
		 * */
		public static function getTime():Number
		{
			return time;
		}
		
		/**
		 * Return actual frame rate
		 * */
		public static function getFrameRate():Number
		{
			return 1000 / step;
		}
		
		/**
		 * Calculates the coefficient of delta with the same <b>frame rate</b> of the application.
		 * 
		 * @param friction
		 * @see #getDelta
		 * */
		public static function getDeltaCoff(friction:Number):Number
		{
			return Math.pow(friction, getDelta());
		}
	}
}