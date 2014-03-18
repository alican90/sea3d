package sunag.sea3d.framework
{
	import away3d.primitives.WireframeCube;
	import away3d.sea3d.animation.DummyAnimation;
	
	import sunag.sea3dgp;
	import sunag.sea3d.objects.SEADummy;
	import sunag.sea3d.objects.SEAObject;

	use namespace sea3dgp;
	
	public class Dummy extends Object3D
	{
		public static function getAsset(name:String):Dummy
		{
			return Object3D.getAsset(name) as Dummy;
		}		
		
		sea3dgp var dummy:WireframeCube;
		
		public function Dummy()
		{
			super(dummy = new WireframeCube(100, 100, 100, 0x9AB9E5), DummyAnimation);
		}
		
		public function setWidth(width:Number):void
		{			
			dummy.width = width;
		}
		
		public function getWidth():Number
		{
			return dummy.width;
		}
		
		public function setHeight(height:Number):void
		{			
			dummy.height = height;
		}
		
		public function getHeight():Number
		{
			return dummy.height;
		}
		
		public function setDepth(depth:Number):void
		{			
			dummy.depth = depth;
		}
		
		public function getDepth():Number
		{
			return dummy.depth;
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	POINT LIGHT
			//
			
			var dmy:SEADummy = sea as SEADummy;
			
			dummy.transform = dmy.transform;
			
			dummy.width = dmy.width;
			dummy.height = dmy.height;
			dummy.depth = dmy.depth;					
		}
	}
}