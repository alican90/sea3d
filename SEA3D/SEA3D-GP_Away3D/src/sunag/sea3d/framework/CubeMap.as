package sunag.sea3d.framework
{
	import away3d.textures.CubeTextureBase;
	
	import sunag.sea3dgp;

	use namespace sea3dgp;
	
	public class CubeMap extends Asset
	{
		private static const TYPE:String = 'CubeMap/';
		
		public static function getAsset(name:String):CubeMap
		{
			return Asset.getAsset(TYPE+name) as CubeMap;
		}
		
		sea3dgp var scope:CubeTextureBase;
		sea3dgp var transparent:Boolean = false;
		
		function CubeMap(scope:CubeTextureBase=null)
		{
			super(TYPE);
			
			this.scope = scope;
		}
		
		override public function dispose():void
		{
			scope.dispose();
			
			super.dispose();			
		}
	}
}