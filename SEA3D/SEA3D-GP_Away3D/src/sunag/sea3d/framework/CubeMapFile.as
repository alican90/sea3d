package sunag.sea3d.framework
{
	import away3d.textures.AsynBitmapCubeTexture;
	
	import sunag.sea3dgp;
	import sunag.sea3d.objects.SEACubeMap;
	import sunag.sea3d.objects.SEAObject;
	
	use namespace sea3dgp;
	
	public class CubeMapFile extends CubeMap
	{
		sea3dgp var cubeMap:AsynBitmapCubeTexture;		
		
		public static function getAsset(name:String):CubeMapFile
		{
			return CubeMap.getAsset(name) as CubeMapFile;
		}
		
		public function CubeMapFile()
		{		
		}
		
		//
		//	LOADER
		//
		
		override sea3dgp function load(sea:SEAObject):void
		{
			super.load(sea);
			
			//
			//	CUBEMAP FILE
			//
			
			var cube:SEACubeMap = sea as SEACubeMap;
			
			this.scope = cubeMap = new AsynBitmapCubeTexture
				(
					cube.faces[1], 
					cube.faces[0],	
					cube.faces[3],
					cube.faces[2],
					cube.faces[5],
					cube.faces[4]
				);			
		}
	}
}