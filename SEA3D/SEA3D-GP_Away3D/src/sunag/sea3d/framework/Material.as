package sunag.sea3d.framework
{
	import away3d.materials.MaterialBase;
	
	import sunag.sea3dgp;

	use namespace sea3dgp;
	
	public class Material extends Asset
	{
		private static const TYPE:String = 'Material/';
		
		public static function getAsset(name:String):Material
		{
			return Asset.getAsset(TYPE+name) as Material;
		}
		
		sea3dgp var scope:MaterialBase;		
		
		public function Material(scope:MaterialBase)
		{
			super(TYPE);
			
			this.scope = scope;
		}
	}
}