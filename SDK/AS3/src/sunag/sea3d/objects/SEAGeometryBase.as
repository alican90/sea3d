package sunag.sea3d.objects
{
	import sunag.sea3d.SEA;

	public class SEAGeometryBase extends SEAObject
	{
		public static const TYPE:String = "geom";
		
		public static var JOINT_STRIDE:uint = 3;
		
		public var attrib:uint;
		
		public var numVertex:uint;
		public var jointPerVertex:uint;
		
		public var isBig:Boolean = false;				
		
		public var vertex:Vector.<Number>;
		public var indexes:Array;
		
		public var uv:Array;		
		public var normal:Vector.<Number>;
		public var tangent:Vector.<Number>;
		public var color:Array;
		
		public var joint:Vector.<Number>;
		public var weight:Vector.<Number>;
				
		public function SEAGeometryBase(name:String, type:String, sea:SEA)
		{
			super(name, type, sea);
		}	
	}
}