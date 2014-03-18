package sunag.sea3d.loader
{
	import sunag.sea3dgp;
	import sunag.events.SEAEvent;
	import sunag.sea3d.SEA;
	import sunag.sea3d.config.ConfigBase;
	import sunag.sea3d.modules.ActionModuleBase;
	import sunag.sea3d.modules.ByteCodeModuleBase;

	use namespace sea3dgp;
	
	public class SEA3DLoader extends Loader
	{
		public static const CONFIG:ConfigBase = new ConfigBase();
		
		sea3dgp var sea3d:SEA;		
		
		public function SEA3DLoader(description:String="Loading SEA3D")
		{
			super(description);			
			
			sea3d = new SEA(CONFIG);
			sea3d.addModule(new ByteCodeModuleBase());
			sea3d.addModule(new ActionModuleBase());
			sea3d.addEventListener(SEAEvent.STREAMING_PROGRESS, onProgress, false, 0, true);
			sea3d.addEventListener(SEAEvent.PROGRESS, onProgress, false, 0, true);
			sea3d.addEventListener(SEAEvent.COMPLETE, onComplete, false, 0, true);
		}		
		
		override public function get streaming():Boolean
		{
			return sea3d.bytesLoaded < sea3d.bytesTotal;
		}
		
		override public function get bytesLoaded():Number
		{
			return sea3d.bytesPosition;
		}
		
		override public function get bytesTotal():Number
		{
			return sea3d.bytesTotal;
		}
		
		private function onComplete(e:SEAEvent):void
		{
			dispatchComplete();
		}
		
		private function onProgress(e:SEAEvent):void
		{
			dispatchProgress();
		}
		
		override sea3dgp function onLoad():void
		{
			if (data) sea3d.loadBytes( data );
			else sea3d.load( request );
		}
	}
}